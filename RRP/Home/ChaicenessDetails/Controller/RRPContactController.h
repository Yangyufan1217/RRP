//
//  RRPContactController.h
//  RRP
//
//  Created by sks on 16/3/4.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RRPContactControllerDelegate <NSObject>

- (void)passValueWithArray:(NSMutableArray *)contactShowArray;

@end

@interface RRPContactController : UIViewController
@property (nonatomic, strong)NSString *personCount;//人数
@property (nonatomic, assign)id<RRPContactControllerDelegate> delegate;

@end
