//
//  MyOrderCViewCell.m
//  EntityConvenient
//
//  Created by 石山岭 on 2016/11/29.
//  Copyright © 2016年 石山岭. All rights reserved.
//

#import "MyOrderCViewCell.h"

@interface MyOrderCViewCell()<FloorVIewDelegate>




@end

@implementation MyOrderCViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = MColor(238, 238, 238);
        [self CreatingControls];
    }
    return self;
}

- (void)CreatingControls {
    [self.contentView addSubview:self.headerView];
    
}
- (JSWave *)headerView{
    if (!_headerView) {
        _headerView = [[JSWave alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, kFit(180))];
        _headerView.backgroundColor = kNavigation_Color;
        //_headerView.maskWaveColor = MColor(234, 234, 234);
        [_headerView addSubview:self.floorView];
        _floorView.sd_layout.leftSpaceToView(_headerView, 0).topSpaceToView(_headerView, 0).widthIs(kScreen_widht).heightIs(kFit(175));
        self.subjectsShow = [[UILabel alloc] init];
        _subjectsShow.textAlignment = 1;
        _subjectsShow.textColor = [UIColor whiteColor];
        _subjectsShow.font = MFont(kFit(15));
        [_headerView addSubview:_subjectsShow];
        _subjectsShow.sd_layout.leftSpaceToView(_headerView, 0).bottomSpaceToView(_headerView, kFit(10)).rightSpaceToView(_headerView, 0).heightIs(kFit(20));
        __weak typeof(self)weakSelf = self;
        _headerView.waveBlock = ^(CGFloat currentY){
            CGRect iconFrame = [weakSelf.floorView frame];
            iconFrame.origin.y = CGRectGetHeight(weakSelf.headerView.frame)-CGRectGetHeight(weakSelf.floorView.frame)+currentY-weakSelf.headerView.waveHeight;
            weakSelf.floorView.frame  =iconFrame;
        };
        [_headerView startWaveAnimation];
    }
    return _headerView;
}

- (FloorVIew *)floorView {
    if (!_floorView) {
        _floorView = [[FloorVIew alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, kFit(170))];
        _floorView.delegate = self;
    }
    return _floorView;
}

- (void)OrderChoose:(int)index {
    if ([_delegate respondsToSelector:@selector(MyOrderChoose:)]) {
        [_delegate MyOrderChoose:index];
    }
}

- (void)DataOrIntegral:(NSInteger)index {
    
    if ([_delegate respondsToSelector:@selector(MyOrderChoose:)]) {
        [_delegate MyOrderChoose:(int)index];
    }
}
- (void)SetDefaultValue {
    _floorView.nameLabel.text = @"未登录";
    _floorView.TextImage.image = [UIImage imageNamed:@"logo.jpg"];
}

-(void)setModel:(UserDataModel *)model {
    _floorView.nameLabel.text = [NSString stringWithFormat:@"用户名:%@",model.userName];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURL_SHY, model.avatar]];
    [_floorView.TextImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo.jpg"] options:1];
    if ([UserDataSingleton mainSingleton].subState.length == 0) {
        _subjectsShow.text = @"等待预约学习骑马!";
    }
  
    
    
}
@end
