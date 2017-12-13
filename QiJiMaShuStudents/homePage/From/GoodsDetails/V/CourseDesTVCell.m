//
//  CourseDesTVCell.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/11/28.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "CourseDesTVCell.h"

@interface CourseDesTVCell ()

@property (nonatomic, strong)UIButton *logoImageBtn;
@property (nonatomic, strong)UILabel *contentLabel;

@end

@implementation CourseDesTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

    }
    return  self;
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
