//
//  ConfirmBuyersTVCell.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/8/10.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "ConfirmBuyersTVCell.h"

@implementation ConfirmBuyersTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.showBtnOne.userInteractionEnabled = NO;
    self.showBtnTwo.userInteractionEnabled = NO;
}

@end
