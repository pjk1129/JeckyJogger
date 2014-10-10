//
//  RunParamsView.m
//  JeckyMenu
//
//  Created by Jecky on 14-9-28.
//  Copyright (c) 2014年 njut. All rights reserved.
//

#import "RunParamsView.h"
#import "JeckyJogger-Swift.h"

@interface RunParamsView()

@property (nonatomic, strong) UIImageView   *topImageView;
@property (nonatomic, strong) UIImageView   *bottomImageView;

@property (nonatomic, strong) UILabel       *mainLabel;
@property (nonatomic, strong) UILabel       *mainUnitLabel;

@property (nonatomic, strong) UILabel       *midLabel;
@property (nonatomic, strong) UILabel       *midUnitLabel;

@property (nonatomic, strong) UILabel       *leftLabel;
@property (nonatomic, strong) UILabel       *leftUnitLabel;

@property (nonatomic, strong) UILabel       *rightLabel;
@property (nonatomic, strong) UILabel       *rightUnitLabel;

@end

@implementation RunParamsView

- (void)dealloc{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [self bottomImageView];
        
    }
    return self;
}

- (void)reloadRunParamsView:(NSString *)dis
                       pace:(NSString *)pace
                  totalTime:(NSString *)time
                    calorie:(NSString *)calorie
{
    _mainLabel.text = time;
    _leftLabel.text = pace;
    _midLabel.text = dis;
    _rightLabel.text = calorie;
}

- (void)resetRunParams
{
    _mainLabel.text = @"00:00:00";
    _leftLabel.text = @"0:00";
    _midLabel.text = @"0.00";
    _rightLabel.text = @"0.0";
}

#pragma mark - getter
- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 79)];
//        _topImageView.backgroundColor = [JUtil colorWithHexString:@"3CB8D9"];
        _topImageView.image = [UIImage imageNamed:@"bg_navbar"];
        _topImageView.userInteractionEnabled = YES;
        _mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.frame), 40)];
        _mainLabel.backgroundColor = [UIColor clearColor];
        _mainLabel.textColor = [JUtil colorWithHexString:@"FFFFFF"];
        _mainLabel.text= @"00:00:00";
        _mainLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:50];
        _mainLabel.textAlignment = NSTextAlignmentCenter;
        [_topImageView addSubview:_mainLabel];
        
        [self addSubview:_topImageView];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topImageView.frame), CGRectGetWidth(self.frame), 49)];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.backgroundColor = [UIColor clearColor];
        _bottomImageView.image = [UIImage imageNamed:@"bg_run_info"];
        
        _midUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-self.bounds.size.width/6, 6, self.bounds.size.width/3, 14)];
        _midUnitLabel.backgroundColor = [UIColor clearColor];
        _midUnitLabel.textColor = [JUtil colorWithHexString:@"76C3EB"];
        _midUnitLabel.font = [UIFont systemFontOfSize:12];
        _midUnitLabel.textAlignment = NSTextAlignmentCenter;
        _midUnitLabel.text = @"距离(km)";
        [_bottomImageView addSubview:_midUnitLabel];
        
        _midLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_midUnitLabel.frame), CGRectGetMaxY(_midUnitLabel.frame), CGRectGetWidth(_midUnitLabel.frame), 16)];
        _midLabel.backgroundColor = [UIColor clearColor];
        _midLabel.textColor = [JUtil colorWithHexString:@"318BB9"];
        _midLabel.text= @"0.00";
        _midLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
        _midLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomImageView addSubview:_midLabel];
        
        
        _leftUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, CGRectGetMinY(_midUnitLabel.frame),self.bounds.size.width/3, 14)];
        _leftUnitLabel.backgroundColor = [UIColor clearColor];
        _leftUnitLabel.textColor = [JUtil colorWithHexString:@"76C3EB"];
        _leftUnitLabel.font = [UIFont systemFontOfSize:12];
        _leftUnitLabel.textAlignment = NSTextAlignmentCenter;
        _leftUnitLabel.text = @"配速(min/km)";
        [_bottomImageView addSubview:_leftUnitLabel];
        
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_leftUnitLabel.frame), CGRectGetMaxY(_leftUnitLabel.frame), CGRectGetWidth(_leftUnitLabel.frame), 16)];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.textColor = [JUtil colorWithHexString:@"318BB9"];
        _leftLabel.text= @"0:00";
        _leftLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomImageView addSubview:_leftLabel];
        
        _rightUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_midUnitLabel.frame), CGRectGetMinY(_midUnitLabel.frame), self.bounds.size.width/3, 14)];
        _rightUnitLabel.backgroundColor = [UIColor clearColor];
        _rightUnitLabel.textColor = [JUtil colorWithHexString:@"76C3EB"];
        _rightUnitLabel.font = [UIFont systemFontOfSize:12];
        _rightUnitLabel.textAlignment = NSTextAlignmentCenter;
        _rightUnitLabel.text = @"卡路里(kcal)";
        [_bottomImageView addSubview:_rightUnitLabel];
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_rightUnitLabel.frame), CGRectGetMaxY(_rightUnitLabel.frame), CGRectGetWidth(_rightUnitLabel.frame), 16)];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textColor = [JUtil colorWithHexString:@"318BB9"];
        _rightLabel.text= @"0.0";
        _rightLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        [_bottomImageView addSubview:_rightLabel];
        
        [self addSubview:_bottomImageView];
    }
    return _bottomImageView;
}

@end
