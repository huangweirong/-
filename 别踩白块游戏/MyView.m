//
//  MyView.m
//  别踩白块游戏
//
//  Created by I三生有幸I on 16/1/29.
//  Copyright (c) 2016年 盛辰. All rights reserved.
//

#import "MyView.h"

@implementation MyView


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.target performSelector:self.action withObject:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
