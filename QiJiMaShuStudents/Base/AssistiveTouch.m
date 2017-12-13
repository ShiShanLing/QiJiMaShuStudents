//
//  AssistiveTouch.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/12/13.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "AssistiveTouch.h"

@implementation AssistiveTouch {
    UIButton *_button;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert + 1;
        //这句话很重要
        [self makeKeyAndVisible];
        _button.font = [UIFont systemFontOfSize:13];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor grayColor];
        _button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_button setTitle:[NSString stringWithFormat:@"一键\n预约"] forState:(UIControlStateNormal)];
        [_button setBackgroundImage:[UIImage imageNamed:@"QuickA"]  forState:(UIControlStateNormal)];
        _button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _button.layer.cornerRadius = frame.size.width/2;
        [_button addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        //放一个拖动手势，用来改变控件的位置
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        pan.delegate = self;
        [_button addGestureRecognizer:pan];
    }
    return self;
}

//按钮事件
-(void)choose {
    if ([_delegate respondsToSelector:@selector(aKeyClickBookin)]) {
        [_delegate aKeyClickBookin];
    }
}
//手势事件 －－ 改变位置
-(void)changePostion:(UIPanGestureRecognizer *)pan
{
    
    

    
    CGPoint point = [pan translationInView:self];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect originalFrame = self.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    self.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _button.enabled = NO;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
    } else {
        
        CGRect frame = self.frame;
        //记录是否越界
        BOOL isOver = NO;
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
            isOver = YES;
        } else if (frame.origin.x+frame.size.width > width) {
            frame.origin.x = width - frame.size.width;
            isOver = YES;
        }
        
        if (frame.origin.y < 0) {
            frame.origin.y = 0;
            isOver = YES;
        } else if (frame.origin.y+frame.size.height > height) {
            frame.origin.y = height - frame.size.height;
            isOver = YES;
        }
        if (isOver) {
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = frame;
            }];
        }
        _button.enabled = YES;
    }
    
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        CGFloat middle = (kScreen_widht - 80)/2;
        CGRect frame = self.frame;
        if(frame.origin.x <= middle) {
            frame.origin.x = 0;
            
            [UIView animateWithDuration:0.8 animations:^{
                self.frame = frame;
            }];
            
            
        }else {
            frame.origin.x = kScreen_widht - 80;
            [UIView animateWithDuration:0.8 animations:^{
                self.frame = frame;
            }];
        }
    }
    
}


@end
