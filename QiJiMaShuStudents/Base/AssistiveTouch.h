//
//  AssistiveTouch.h
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/12/13.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AssistiveTouchDelegate <NSObject>

- (void)aKeyClickBookin;

@end

@interface AssistiveTouch : UIWindow <UIGestureRecognizerDelegate>


-(id) initWithFrame:(CGRect)frame;

@property (nonatomic, weak)id<AssistiveTouchDelegate>delegate;

@end
