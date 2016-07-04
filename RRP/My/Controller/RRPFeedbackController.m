//
//  RRPFeedbackController.m
//  RRP
//
//  Created by sks on 16/3/22.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "RRPFeedbackController.h"

static const NSInteger maxInputCount = 255;
@interface RRPFeedbackController ()<UITextViewDelegate>

@property (nonatomic, strong) HWTextView *textView;
@property (nonatomic, strong) UILabel *explainLabel;//退票说明
@property (nonatomic, strong) UIView *wireView;//分割线
@property (nonatomic, strong) UILabel *lbNums;//显示字数
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic ,strong) UIButton *submitButton;//提交

@end

@implementation RRPFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorWithColors(IWColor(241, 241, 241), IWColor(200, 200, 200));
    self.title = @"意见反馈";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:nil];
    //键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.submitButton];

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
- (UITextView *)textView {
    if (_textView == nil) {
        self.textView = [[HWTextView alloc] initWithFrame:CGRectMake(10, 74, RRPWidth-20, 175)];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.placeholder = @"请输入你的建议";
        self.textView.placeholderColor = IWColor(216, 216, 216);
        self.textView.delegate = self;
        self.textView.font = [UIFont systemFontOfSize:12];
        [self.textView addSubview:self.lbNums];
    }
    return _textView;
}

- (UIButton *)submitButton {
    if (_submitButton == nil) {
        self.submitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.submitButton.frame = CGRectMake((RRPWidth - 200)/2, CGRectGetMaxY(self.textView.frame)+20, 200, 40);
        self.submitButton.layer.cornerRadius = 5;
        self.submitButton.layer.masksToBounds = YES;
        self.submitButton.layer.borderColor = IWColor(166, 188, 157).CGColor;
        self.submitButton.layer.borderWidth = 1;
        [self.submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
        [self.submitButton setTitleColor:IWColor(102, 102, 102) forState:(UIControlStateNormal)];
        [self.submitButton addTarget:self action:@selector(submitButton:) forControlEvents:(UIControlEventTouchUpInside)];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _submitButton;
}

- (void)submitButton:(UIButton *)sender {
    if (![self.textView.text isEqualToString:@""]) {
        self.textView.text = nil;
        self.lbNums.text = @"0/255";
        [[[UIAlertView alloc] initWithTitle:@"提交成功"
                                    message:@"感谢您宝贵的建议"
                                   delegate:nil
                          cancelButtonTitle:@"确认"
                          otherButtonTitles:nil] show];
    }
    //统计:用户反馈提交点击
    [MobClick event:@"98"];
}

- (UILabel *)lbNums {
    if (_lbNums == nil) {
        //字数限制
        self.lbNums = [[UILabel alloc] initWithFrame:CGRectMake(self.textView.frame.size.width - 80, self.textView.frame.size.height - 15, 70, 12)];
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
#pragma mark 键盘即将弹出
-(void)keyboardWillShow:(NSNotification *) notification {
    if(!self.tapGesture){
        //增加tap手势，点击使退出键盘
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    }
    [self.view addGestureRecognizer:self.tapGesture];

}

-(void)dismissKeyBoard{
    [self.textView resignFirstResponder];
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
