//
//  RunAnnotationView.h
//  JeckyJogger
//
//  Created by Jecky on 14-10-2.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface RunAnnotationView : MAAnnotationView

@property (nonatomic, strong) UIImageView  *annotationImageView;
@property (nonatomic, strong) UILabel      *nameLabel;
@end
