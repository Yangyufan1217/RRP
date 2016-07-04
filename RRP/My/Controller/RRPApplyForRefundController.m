//
//  RRPApplyForRefundController.m
//  RRP
//
//  Created by sks on 16/3/11.
//  Copyright © 2016年 sks. All rights reserved.



#import "RRPApplyForRefundController.h"
#import "RRPRefundCell.h"
#import "RRPMyCauseCell.h"

static const NSInteger maxInputCount = 255;
@interface RRPApplyForRefundController ()<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate> {
    BOOL click;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) HWTextView *textView;
@property (nonatomic, strong) UILabel *explainLabel;//退票说明
@property (nonatomic, strong) UIView *wireView;//分割线
@property (nonatomic, strong)UILabel *lbNums;//显示字数
@property (nonatomic, assign)NSInteger keyboardheight;
@property (nonatomic, strong)UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIImageView *backImageView;//背景图片视图
@property (nonatomic, strong) UITableView *causeTabelView;//原因
@property (nonatomic,strong)NSMutableArray *refoundReasonArr;//退款原因数组
@property (nonatomic,strong)NSString *selectReason;

@end

@implementation RRPApplyForRefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"申请退票";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(returnAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = IWColor(0, 122, 255);
    self.refoundReasonArr = [@[] mutableCopy];
    //取消滚动视图的自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"RRPRefundCell" bundle:nil] forCellReuseIdentifier:@"RRPRefundCell" ];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.causeTabelView registerNib:[UINib nibWithNibName:@"RRPMyCauseCell" bundle:nil] forCellReuseIdentifier:@"RRPMyCauseCell"];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
    //键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
       [self requestRefoundReason];
}
//返回
- (void)returnAction:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma 请求接口
//退款原因
- (void)requestRefoundReason
{
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"refund_message" forKey:@"method"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MyRefundTicket parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary *nullDict = [RRPPrintObject nullDic:dict];
//        NSLog(@"退票原因%@",nullDict);
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            
            for (NSString *key in nullDict[@"ResponseBody"]) {
                NSString *reason = [nullDict[@"ResponseBody"] valueForKey:key];
                [self.refoundReasonArr addObject:reason];
            }
            
        }
//        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    
    }];

    
}
#pragma mark 键盘即将弹出
-(void)keyboardWillShow:(NSNotification *) notification {
    [self.backImageView removeFromSuperview];
    click = NO;
    //键盘的frame
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardheight = keyboardRect.size.height;
    self.keyboardheight = keyboardheight;
    
    self.tableView.frame = CGRectMake(0, -keyboardheight/2,RRPWidth, RRPHeight-64);
    if(!self.tapGesture){
        //增加tap手势，点击使退出键盘
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
        
    }
    [self.tableView addGestureRecognizer:self.tapGesture];
}

#pragma mark 键盘即将消失
-(void)keyboardWillHide:(NSNotification *) notification {
    [self.tableView removeGestureRecognizer:self.tapGesture];
    self.tableView.frame = CGRectMake(0, 64, RRPWidth, RRPHeight-64);
}
-(void)dismissKeyBoard{
    self.tableView.frame = CGRectMake(0, 64,RRPWidth, RRPHeight-64);
    [self.textView resignFirstResponder];
}
#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, RRPWidth, RRPHeight-64) style:(UITableViewStyleGrouped)];
        self.tableView.backgroundColor = IWColor(242, 242, 242);
        self.tableView.showsVerticalScrollIndicator = NO;
//        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableView == tableView) {
        if (section == 0) {
            return 2;
        }else if (section == 1) {
            return 1;
        }else {
            return 1;
        }
    }else {
        return self.refoundReasonArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.tableView == tableView) {
        return 3;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                RRPRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPRefundCell" forIndexPath:indexPath];
                [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
                cell.mostLabel.hidden = cell.totalLabel.hidden = cell.deductContentLabel.hidden = cell.deductMoneyLabel.hidden = cell.unitLabel.hidden = cell.moreImageView.hidden = YES;
                cell.typeLabel.text = @"申请服务";
                cell.RRPcontentLabel.textColor = IWColor(0, 0, 0);
                cell.RRPcontentLabel.text = @"退票";
                cell.backgroundColor = [UIColor whiteColor];
                return cell;
            }else {
                RRPRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPRefundCell" forIndexPath:indexPath];
                [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
                cell.typeLabel.text = @"退款金额";
                cell.RRPcontentLabel.text = [NSString stringWithFormat:@"￥%@",self.orgin];
                cell.totalLabel.text = self.orgin;
                cell.deductMoneyLabel.text = @"0";
                cell.moreImageView.hidden = YES;
                cell.backgroundColor = [UIColor whiteColor];
                return cell;
            }
        }else if (indexPath.section == 1) {
            RRPRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPRefundCell" forIndexPath:indexPath];
            cell.mostLabel.hidden = cell.totalLabel.hidden = cell.deductContentLabel.hidden = cell.deductMoneyLabel.hidden = cell.unitLabel.hidden = YES;
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            cell.typeLabel.text = @"退票原因";
            cell.RRPcontentLabel.textColor = IWColor(0, 0, 0);
            cell.RRPcontentLabel.text = self.selectReason;
            [cell.moreButton addTarget:self action:@selector(moreButton:) forControlEvents:(UIControlEventTouchUpInside)];
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            [cell addSubview:self.explainLabel];
            [cell addSubview:self.wireView];
            [cell addSubview:self.textView];
            return cell;
        }

    }else {
        RRPMyCauseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRPMyCauseCell" forIndexPath:indexPath];
        [cell showDataWithString:self.refoundReasonArr[indexPath.row]];
//        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView == tableView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 45;
            }else {
                return 67.5;
            }
        }else if (indexPath.section == 1) {
            return 45;
        }else {
            return 165;
        }
    }else {
        return [RRPMyCauseCell cellHight:self.refoundReasonArr[indexPath.row]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.tableView == tableView) {
        return 22.5;
    }else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.tableView == tableView) {
        if (section == 0) {
            return 0.1;
        }else if (section == 1) {
            return 0.1;
        }else {
            return 180;
        }
    }else {
        return 0;
    }
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = IWColor(242, 242, 242);
        return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RRPWidth, 80)];
        view.backgroundColor = IWColor(242, 242, 242);
        if (section == 2) {
            self.submitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            self.submitButton.frame = CGRectMake(40, 15, RRPWidth - 80, 50);
            self.submitButton.layer.cornerRadius = 5;
            self.submitButton.layer.masksToBounds = YES;
            self.submitButton.backgroundColor = IWColor(36, 193, 251);
            [self.submitButton setTitle:@"提交申请" forState:(UIControlStateNormal)];
            [self.submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            self.submitButton.titleLabel.font =[UIFont systemFontOfSize:20];
            [self.submitButton addTarget:self action:@selector(submitButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [view addSubview:self.submitButton];
        }
        return view;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.causeTabelView == tableView) {
        [self.backImageView removeFromSuperview];
        self.selectReason = self.refoundReasonArr[indexPath.row];
        click = NO;
        [self.tableView reloadData];
    }
}

//退票说明
- (UILabel *)explainLabel {
    if (_explainLabel == nil) {
        self.explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 100, 15)];
        self.explainLabel.font = [UIFont systemFontOfSize:15];
        self.explainLabel.textColor = IWColor(169, 169, 169);
        self.explainLabel.text = @"退票说明";
    }
    return _explainLabel;
}
//分割线
- (UIView *)wireView {
    if (_wireView == nil) {
        self.wireView = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.explainLabel.frame)+10, RRPWidth-50, 1)];
        self.wireView.backgroundColor = IWColor(217, 217, 217);
    }
    return _wireView;
}

- (UITextView *)textView {
    if (_textView == nil) {
        self.textView = [[HWTextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.wireView.frame)+10, RRPWidth-50, 105)];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.placeholder = @"文字最多不超过255字";
        self.textView.placeholderColor = IWColor(216, 216, 216);
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:12];
        [self.textView addSubview:self.lbNums];
    }
    return _textView;
}

- (UILabel *)lbNums {
    if (_lbNums == nil) {
        //字数限制
        self.lbNums = [[UILabel alloc] initWithFrame:CGRectMake(self.textView.frame.size.width - 70, self.textView.frame.size.height - 15, 70, 12)];
        self.lbNums.backgroundColor = [UIColor clearColor];
        self.lbNums.font = [UIFont systemFontOfSize:12];
        self.lbNums.textColor = IWColor(115, 115, 115);
        self.lbNums.textAlignment = 2;
        self.lbNums.text = @"0/255";
        [self.view addSubview:self.lbNums];
    }
    return _lbNums;
}

//字数限制
- (void)textViewEditChanged:(NSNotification *)notifi{
    UITextView * textField = (UITextView *)notifi.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //MAX_STARWORDS_LENGTH
    NSInteger MAX_STARWORDS_LENGTH = 254;
    if (!position)
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}

//判断字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSString* text = textView.text;
    NSInteger len = text.length;
    self.lbNums.text = [self countText:len];
    if (len >= maxInputCount) {
        self.lbNums.textColor = [UIColor redColor];
        self.lbNums.text =@"(255/255)";
    }else {
        self.lbNums.textColor = [UIColor lightGrayColor];
    }
}
//label计数
- (NSString*)countText:(NSInteger)count
{
    NSString* s = [NSString stringWithFormat:@"(%ld/%ld)", (long)count, (long)maxInputCount];
    return s;
}


- (void)moreButton:(UIButton *) sender {
    if (click == NO) {
        [self.tableView addSubview:self.backImageView];
        [self.backImageView addSubview:self.causeTabelView];
        click = YES;
    }else {
        [self.backImageView removeFromSuperview];
        click = NO;
    }
    
    
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RRPWidth/2, 190, RRPWidth/2-10, 200)];
        self.backImageView.image = [UIImage imageNamed:@"退票申请条件框"];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UITableView *)causeTabelView {
    if (_causeTabelView == nil) {
        self.causeTabelView = [[UITableView alloc] initWithFrame:CGRectMake(3, 10, self.backImageView.frame.size.width-6, self.backImageView.frame.size.height-18)];
        self.causeTabelView.backgroundColor = [UIColor whiteColor];
        self.causeTabelView.showsVerticalScrollIndicator = NO;
//        self.causeTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
        self.causeTabelView.tableFooterView = [[UIView alloc] init];
        self.causeTabelView.delegate = self;
        self.causeTabelView.dataSource = self;
    }
    return _causeTabelView;
}


//提交
- (void)submitButton:(UIButton *)sender {
//    NSLog(@"%@",self.textView.text);
//    self.textView.text = nil;
    if ([self.orgin length] > 0 && [self.selectReason length] > 0) {
        //统计:申请退票提交按钮点击
        [MobClick event:@"61"];
        [self requestRefoundTicket];
    }else
    {
        [[MyAlertView sharedInstance]showFrom:@"请选择退票原因"];
    }
   
}
//请求退款
- (void)requestRefoundTicket
{

    NSString *user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:@"refund_ticket" forKey:@"method"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:user_id forKey:@"memberid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.orderid forKey:@"orderid"];
    [[RRPDataRequestModel shareDataRequestModel].dataPortMessageDic setValue:self.selectReason forKey:@"refundremark"];
    NSMutableDictionary *dic = [RRPDataRequestModel shareDataRequestModel].dataPortMessageDic;
    [[NetWorkManager sharedManager] requestSerializer].timeoutInterval = TimeOutInterval;
    [[NetWorkManager sharedManager] POST:MyRefundTicket parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //检查字典中是否含有：“<NULL>”这样的字符串，有就改为“”
        NSDictionary *nullDict = [RRPPrintObject nullDic:dict];
        NSInteger code = [[nullDict[@"ResponseHead"] valueForKey:@"code"] integerValue];
        if (code == 1000)  {
            NSInteger code = [[nullDict[@"ResponseBody"] valueForKey:@"code"] integerValue];
            if (code == 2000) {
                
                //申请退款成功弹框
                NSString *sizeString = @"申请退款成功,我们将于7个工作日之内处理,请您及时到消息列表中查看退款通知";
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:sizeString preferredStyle:(UIAlertControllerStyleAlert)];
                // 创建按钮
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                //添加按钮 将按钮添加到UIAlertController对象上
                [alertController addAction:okAction];
                [self.navigationController presentViewController:alertController animated:YES completion:nil];
                
           }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
      
    }];

}
- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
- (void) viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
