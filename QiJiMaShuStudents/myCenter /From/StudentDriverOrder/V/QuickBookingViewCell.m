//
//  QuickBookingViewCell.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/11/24.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "QuickBookingViewCell.h"

@implementation QuickBookingViewCell

- (void)setModel:(StudentDriverOrderModel *)model {
    self.coachNameLabel.text = model.coachName;
    self.orderPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.orderAmount];
    self.schoolNameLabel.text = model.orderSn;
    self.phoneLabel.text = model.phone;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
