//
//  DetailController.m
//  music
//
//  Created by 郑业强 on 2018/9/27.
//  Copyright © 2018年 kk. All rights reserved.
//

#import "DetailController.h"
#import "DetailCollectionTransition.h"

#define BTN_W 30
#define BTN_PADDING countcoordinatesX(20)

#pragma mark - 声明
@interface DetailController()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray<UIButton *> *btns;

@end

#pragma mark - 实现
@implementation DetailController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[kColor_Text_Black colorWithAlphaComponent:0.2]];
    [self contentV];
    [self btns];
}

#pragma mark - 动画
- (void)show {
    NSTimeInterval delay = 0.1;
    for (int i=0; i<self.btns.count; i++) {
        POPSpringAnimation *basic1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        basic1.toValue = @(CGRectGetMaxY(self.contentV.frame) + 30);
        basic1.springSpeed = 2;
        basic1.springBounciness = 4;
        basic1.beginTime = 0.5 + CACurrentMediaTime() + i * delay;
        
        UIButton *btn = self.btns[i];
        [btn pop_addAnimation:basic1 forKey:@"position.y"];
    }
    
    POPBasicAnimation *basic2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    basic2.toValue = @(1);
    basic2.beginTime = 0.5 + CACurrentMediaTime();
    basic2.duration = 0.3;
    for (UIButton *btn in self.btns) {
        [btn pop_addAnimation:basic2 forKey:@"view.alpha"];
    }
}
- (void)hide {
    NSTimeInterval delay = 0.1;
    for (int i=0; i<self.btns.count; i++) {
        POPSpringAnimation *basic1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        basic1.toValue = @(CGRectGetMaxY(self.contentV.frame) + SCREEN_HEIGHT);
        basic1.springSpeed = 2;
        basic1.springBounciness = 4;
        basic1.beginTime = CACurrentMediaTime() + i * delay;
        
        UIButton *btn = self.btns[i];
        [btn pop_addAnimation:basic1 forKey:@"position.y"];
    }
    
    POPBasicAnimation *basic2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    basic2.toValue = @(0);
    basic2.beginTime = CACurrentMediaTime();
    basic2.duration = 0.3;
    for (UIButton *btn in self.btns) {
        [btn pop_addAnimation:basic2 forKey:@"view.alpha"];
    }
}

#pragma mark - get
- (UIView *)contentV {
    if (!_contentV) {
        _contentV = [[UIView alloc] initWithFrame:({
            CGFloat cellW = SCREEN_WIDTH - 80 + 10;
            CGFloat cellH = 5 + cellW / 2 * 3 + 20;
            cellW = cellW - 10;
            cellH = cellH - 25;
            
            CGFloat left = countcoordinatesX(30);
            CGFloat width = (SCREEN_WIDTH - left * 2);
            CGFloat height = width / cellW * cellH;
            CGFloat top = (SCREEN_HEIGHT - BTN_PADDING - BTN_W - height) / 2;
            CGRectMake(left, top, width, height);
        })];
        [_contentV setAlpha:0];
        [_contentV setBackgroundColor:[UIColor whiteColor]];
        [_contentV shadowWithColor:[kColor_Text_Gary colorWithAlphaComponent:0.2] offset:CGSizeMake(0, 5) opacity:1 radius:5];
        [_contentV.layer setCornerRadius:5];
        [self.view addSubview:_contentV];
    }
    return _contentV;
}
- (NSMutableArray<UIButton *> *)btns {
    if (!_btns) {
        _btns = [[NSMutableArray alloc] init];
        for (int i=0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:({
                CGFloat width = BTN_W;
                CGFloat height = BTN_W;
                CGFloat left = self.contentV.centerX - width / 2 + (width + BTN_PADDING) * (i - 1);
                CGFloat top = CGRectGetMaxY(self.contentV.frame) + 20 + SCREEN_HEIGHT;
                CGRectMake(left, top, width, height);
            })];
            [btn setAlpha:0];
            [btn.layer setCornerRadius:btn.height / 2];
            [btn.layer setMasksToBounds:NO];
            [btn.layer setShadowColor:[kColor_Text_Light colorWithAlphaComponent:0.3].CGColor];
            [btn.layer setShadowOffset:CGSizeMake(0, 3)];
            [btn.layer setShadowOpacity:1];
            [btn.layer setShadowRadius:5];
            [btn setBackgroundColor:[UIColor redColor]];
            [btn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [self.view addSubview:btn];
            [_btns addObject:btn];
        }
    }
    return _btns;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    // 初始化presentType
    return [DetailCollectionTransition transitionWithTransitionType:DetailCollectionTransitionTypePresent];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    // 初始化dismissType
    return [DetailCollectionTransition transitionWithTransitionType:DetailCollectionTransitionTypeDismiss];
}

@end
