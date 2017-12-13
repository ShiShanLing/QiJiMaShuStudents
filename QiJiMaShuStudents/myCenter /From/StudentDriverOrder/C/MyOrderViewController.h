//
//  MyOrderViewController.h
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"


@interface MyOrderViewController : GreyTopViewController

/* input */
@property (assign, nonatomic) int comeFrom; //0:地图主页 1:订单确认预定页面

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, assign)NSInteger index;
//选择付款方式的界面
@property (strong, nonatomic) IBOutlet UIView *payMethodView;
@property (weak, nonatomic) IBOutlet UIButton *balancePay;
@property (weak, nonatomic) IBOutlet UIButton *PayTreasurePayBtn;
@property (weak, nonatomic) IBOutlet UITextField *PayAmountTF;
@property (weak, nonatomic) IBOutlet UIView *payView;

@property (weak, nonatomic) IBOutlet UILabel *balanceNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmPayBtn;

@end
