//
//  MethodPaymentView.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/11/29.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "MethodPaymentView.h"

@implementation MethodPaymentView

#pragma mark 选择规格的弹出视图
////创建一个存在于视图最上层的UIViewController
//- (UIViewController *)appRootViewController{
//    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *topVC = appRootVC;
//    while (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    return topVC;
//}
//- (void)ShoppingCellClickEvent{//
//
//    //xia面是弹窗的初始化
//    UIViewController *topVC = [self appRootViewController];
//    if (!self.backImageView1) {
//        self.backImageView1 = [[UIView alloc] initWithFrame:self.view.bounds];
//        self.backImageView1.backgroundColor = [UIColor blackColor];
//        self.backImageView1.alpha = 0.3f;
//        self.backImageView1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
//        tapGesture.numberOfTapsRequired=1;
//        [self.backImageView1 addGestureRecognizer:tapGesture];
//    }
//    [topVC.view addSubview:self.backImageView1];
//    self.moreOperationView.frame = [UIScreen mainScreen].bounds;
//    [self.view addSubview:self.moreOperationView];
//    self.moreOperationView.frame = CGRectMake((kScreen_widht-280)/2, kScreen_heigth, 280, 290);
//    [topVC.view addSubview:self.moreOperationView];
//    [UIView animateWithDuration: 0.2 animations:^{
//        self.moreOperationView.frame =  CGRectMake((kScreen_widht-280)/2, (kScreen_heigth-290)/2, 280, 290);
//    }];
//}

@end
