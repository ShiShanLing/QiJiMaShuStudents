//
//  LearnCarShowTVCell.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/8/8.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "LearnCarShowTVCell.h"

@interface LearnCarShowTVCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *这个使用的btn 不要介意 拉错了 label就能实现
 */
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *directionBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation LearnCarShowTVCell

-(void)setModel:(CourseListModel *)model {
    self.titleImage.layer.cornerRadius = 35;
    self.titleImage.layer.masksToBounds = YES;
    self.directionBtn.layer.cornerRadius = 11;
    self.directionBtn.layer.masksToBounds = YES;
    self.titleLabel.text = model.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥:%.2f/鞍时+¥100教练费/鞍时", model.goodsStorePrice-100];
}



-(void)layoutSubviews {
    self.directionBtn.userInteractionEnabled = NO;

}


@end
