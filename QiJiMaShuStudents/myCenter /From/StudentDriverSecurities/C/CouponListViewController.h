//
//  CouponListViewController.h
//  guangda_student
//
//  Created by guok on 15/6/2.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "GreyTopViewController.h"



@interface CouponListViewController : GreyTopViewController
//1 只是用满减券 2 鞍时券满减券都能用 但是要把不能使用的灰掉  3 只是用鞍时券
@property (nonatomic, strong)NSString *type;
@property (nonatomic, assign)CGFloat payAmount;
@property (nonatomic,assign)NSInteger courseNum;

/**
 couponsID 优惠券Id
 amount 优惠金额
 couponsType 优惠券类型
 */
@property (nonatomic,copy) void(^obtainCoupons)(NSString *couponsID,NSInteger amount ,NSString *couponsType,NSString *couponsTitle);

@end
