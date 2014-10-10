//
//  RunParamsView.h
//  JeckyMenu
//
//  Created by Jecky on 14-9-28.
//  Copyright (c) 2014年 njut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunParamsView : UIView

- (void)reloadRunParamsView:(NSString *)dis
                       pace:(NSString *)pace
                  totalTime:(NSString *)time
                    calorie:(NSString *)calorie;

- (void)resetRunParams;
@end
