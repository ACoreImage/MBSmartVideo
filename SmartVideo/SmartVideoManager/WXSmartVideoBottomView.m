//
//  WXSmartVideoBottomView.m
//  SmartVideo
//
//  Created by yindongbo on 2017/5/5.
//  Copyright © 2017年 Nxin. All rights reserved.
//

#import "WXSmartVideoBottomView.h"
#import "WXSmartVideoControlView.h"
@interface WXSmartVideoBottomView()<
SmartVideoControlDelegate
>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) WXSmartVideoControlView *controlView;
@property (nonatomic, assign) CGFloat tempY;
@property (nonatomic, assign) CGFloat scaleNum;
@end

@implementation WXSmartVideoBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _controlView = [[WXSmartVideoControlView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _controlView.center = CGPointMake(frame.size.width/2, 100);
        _controlView.layer.cornerRadius = 80/2;
        _controlView.delegate = self;
        [self addSubview:_controlView];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"arrow_white_left"] forState:UIControlStateNormal];
        _backBtn.frame = CGRectMake(0, 0, 50, 50);
        _backBtn.center = CGPointMake(SCREEN_WIDTH/5, _controlView.centerY);
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        _tipLabel.text = @"长按进行拍摄";
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:13];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.bottom = _controlView.top - 30;
        [self addSubview:_tipLabel];
        
        _scaleNum = 1;
        _tempY = 0;
    }
    return self;
}

- (void)backAction:(UIButton *)btn {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)smartVideoControl:(WXSmartVideoControlView *)control gestureRecognizer:(UIGestureRecognizer *)gest {
    switch (gest.state) {
        case UIGestureRecognizerStateBegan:{
            _backBtn.hidden = YES;
            _tipLabel.hidden = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(wxSmartVideo:isRecording:)]) {
                [self.delegate wxSmartVideo:self isRecording:YES];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [gest locationInView:self];
//            NSLog(@"point == %@", NSStringFromCGPoint(point));
            
#warning 有问题
            if (point.y <0)
            { //  NSLog(@"伸缩");
                if (_tempY - point.y> 0)
                {
                    if (_scaleNum <3)  _scaleNum += 0.05;
                }else {
                    if (_scaleNum >1)   _scaleNum -= 0.05;
                }
            }
            else // NSLog(@"不伸缩");
            if (self.delegate && [self.delegate respondsToSelector:@selector(wxSmartVideo:zoomLens:)]) {
                [self.delegate wxSmartVideo:self zoomLens:_scaleNum];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            _backBtn.hidden = NO;
            _tipLabel.hidden = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(wxSmartVideo:isRecording:)]) {
                [self.delegate wxSmartVideo:self isRecording:NO];
            }
        }
            break;
        default:
            break;
    }
}
@end
