//
//  QuickBookingViewCell.h
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/11/24.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickBookingViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
@property (nonatomic, strong)StudentDriverOrderModel *model;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
