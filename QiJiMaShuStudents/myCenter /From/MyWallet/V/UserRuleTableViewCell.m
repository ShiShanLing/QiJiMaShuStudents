//
//  UserRuleTableViewCell.m
//  guangda_student
//
//  Created by Ray on 15/7/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "UserRuleTableViewCell.h"

@implementation UserRuleTableViewCell

- (void)awakeFromNib {
    NSString *desStr = @"骑马币是骐骥马术发放给学骑马学员的，在使用骑马预约教练时，用于抵扣订单金额的虚拟货币。";
    CGFloat textHeight = [CommonUtil sizeWithString:desStr fontSize:13 sizewidth:(kScreen_widht - 44) sizeheight:0].height;
    self.describeLabelHeightCon.constant = textHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
