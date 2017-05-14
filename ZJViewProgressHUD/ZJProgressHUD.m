//
//  ZJProgressHUD.m
//  ZJViewProgressHUD
//
//  Created by 张建 on 17/1/3.
//  Copyright © 2017年 zhangjian. All rights reserved.
//

#import "ZJProgressHUD.h"

#define MDXFrom6(x) ([[UIScreen mainScreen] bounds].size.width/375.0*x)

/**
 *  zhangjian01
 *  自定义加载加载按钮,更换之前第三方的样式.
 */
@interface ZJProgressHUD (){
    BOOL animating;
    UIView *bgView;
    UIView *bg1;
    UIView *maskview;
    UIImageView *bgImageView1;
    UIImageView *bgImageView2;
}

@property (nonatomic, strong) UIView  *contentView;

@property (atomic, strong) NSDate *showStarted;

@property (atomic, strong) NSTimer *minShowTimer;

@property (atomic, strong) NSTimer *graceTimer;

- (void)done;
- (void)showUsingAnimation:(BOOL)animated;
- (void)hideUsingAnimation:(BOOL)animated;
- (void)handleGraceTimers:(NSTimer *)theTimer ;

@end

@implementation ZJProgressHUD

- (void)dealloc {
#if !__has_feature(objc_arc)
    [labelTexts release];
    [graceTimer release];
    [minShowTimer release];
    [showStarted release];
#if NS_BLOCKS_AVAILABLE
    [completionBlock release];
#endif
    [super dealloc];
#endif
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self) {
        self.taskInProgress = NO;
        [self layoutAllSubviews:frame];
        
    }
    return self;
}

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (void)layoutSubviews {
    maskview.frame = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
    
    //    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    //    CGPoint windowCenter = CGPointMake(keywindow.frame.size.width/2, keywindow.frame.size.height/2);
    //    CGPoint convertCenter = [keywindow convertPoint:windowCenter toView:self.superview];
    //    CGPoint convertCenter = [keywindow convertPoint:windowCenter toWindow:self.superview.window];
    bgView.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2);
    self.bgImageView.center = CGPointMake(self.superview.frame.size.width/2, self.superview.frame.size.height/2);
    //    bgView.center = convertCenter;
    //    self.bgImageView.center = convertCenter;
}

- (void)layoutAllSubviews:(CGRect)frame{
    
    /*创建灰色背景*/
    maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:maskview];
    maskview.backgroundColor = [UIColor lightGrayColor];
    maskview.alpha = 0.4;
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(MDXFrom6(124), (frame.size.height-64)/2, MDXFrom6(128), MDXFrom6(64))];
    bgView.center = self.center;
    [maskview addSubview:bgView];
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:bgView.frame];
    self.bgImageView.image = [UIImage imageNamed:@"d.png"];
    
    [self addSubview:self.bgImageView];
    bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(MDXFrom6(17), MDXFrom6(17), MDXFrom6(31), MDXFrom6(31))];
    bgImageView1.image = [UIImage imageNamed:@"c1.png"];
    [self.bgImageView addSubview:bgImageView1];
    
    bgImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(MDXFrom6(17), MDXFrom6(17), MDXFrom6(31), MDXFrom6(31))];
    bgImageView2.image = [UIImage imageNamed:@"c.png"];
    [self.bgImageView addSubview:bgImageView2];
    
    _labelTexts = [[UILabel alloc]initWithFrame:CGRectMake(bgImageView1.frame.origin.x + bgImageView1.frame.size.width + MDXFrom6(10), 0, MDXFrom6(70), MDXFrom6(64))];
    [_labelTexts setFont:[UIFont systemFontOfSize:12]];
    _labelTexts.text = @"加载中...";
    [self.bgImageView addSubview:_labelTexts];
    
    
//    /*创建灰色背景*/
//    UIView *maskview = [[UIView alloc] initWithFrame:frame];
//    [self addSubview:maskview];
//    maskview.backgroundColor = [UIColor blackColor];
//    maskview.alpha = 0.5;
//    
//    bgView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width - 100- 61 - 10 * 3) / 2, (self.frame.size.height - 64) / 2, 191, 81)];
//    bgView.center = self.center;
//    //    bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    [self addSubview:bgView];
//    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:bgView.frame];
//    //    bgImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    //    bgImageView.image = [UIImage imageNamed:@"d"];
//    bgImageView.backgroundColor = [UIColor whiteColor];
//    bgImageView.layer.masksToBounds = YES;
//    bgImageView.layer.cornerRadius = 3;
//    [self addSubview:bgImageView];
//    
//    bg1 = [[UIView alloc]initWithFrame:CGRectMake(10, 21, 40, 40)];
//    //    bg1.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    [bgImageView addSubview:bg1];
//    
//    bgImageView1 = [[UIImageView alloc] initWithFrame:bg1.frame];
//    bgImageView1.image = [UIImage imageNamed:@"c1.png"];
//    [bgImageView addSubview:bgImageView1];
//    
//    bgImageView2 = [[UIImageView alloc] initWithFrame:bg1.frame];
//    bgImageView2.image = [UIImage imageNamed:@"c.png"];
//    [bgImageView addSubview:bgImageView2];
//    
//    _labelTexts = [[UILabel alloc]initWithFrame:CGRectMake(bgImageView1.frame.origin.x + 61, 10, 100, 61)];
//    [_labelTexts setFont:[UIFont systemFontOfSize:17]];
//    _labelTexts.text = @"加载中...";
//    [bgImageView addSubview:_labelTexts];
    
    //    [self startRotate];
    self.minShowTime = 0.0f;
    self.graceTime = 0.0f;
    
}
//zhangjian01_可以自定义转速哦,越转越快啊
- (void) rotateWithOptions: (UIViewAnimationOptions) options {
    
    [UIView animateWithDuration: 0.08f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         bgImageView2.transform = CGAffineTransformRotate(bgImageView2.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 
                                 [self rotateWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 
                                 [self rotateWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}
//http://blog.sina.com.cn/resoftios
- (void) startRotate {
    if (!animating) {
        animating = YES;
        [self rotateWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
    [self showUsingAnimation:animating];
}
- (void) stopRotate{
    animating = NO;
    self.taskInProgress = NO;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        //        [weakSelf stopRotate];
        [weakSelf removeFromSuperview];
    }];
    
}

- (void) startRotates:(BOOL)animated {
    animating = animated;
    if (self.graceTime > 0.0) {
        self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self
                                                         selector:@selector(handleGraceTimers:) userInfo:nil repeats:NO];
    }
    
    [self showUsingAnimation:animating];
}

- (void)handleGraceTimers:(NSTimer *)theTimer {
    
    if (_taskInProgress) {
        [self setNeedsDisplay];
        [self showUsingAnimation:animating];
    }
}

- (void) stopRotates:(BOOL)animated{
    animating = animated;
    self.taskInProgress = NO;
    if (self.minShowTime > 0.0 && _showStarted) {
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:_showStarted];
        if (interv < self.minShowTime) {
            self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self
                                                               selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
            return;
        }
    }
    
    [self hideUsingAnimation:animating];
    
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
    [self hideUsingAnimation:animating];
}

- (void)hideUsingAnimation:(BOOL)animated {
    
    if (animated && _showStarted) {
        
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            //        [weakSelf stopRotate];
            [weakSelf removeFromSuperview];
        }];
        
        [self done];
        
    }else{
        self.alpha = 0.0f;
        
    }
    self.showStarted = nil;
}


- (void)done{
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = NULL;
    }
}

- (void)showUsingAnimation:(BOOL)animated{
    
    //    if (animated) {
    [self rotateWithOptions: UIViewAnimationOptionCurveEaseIn];
    //    }
    
    self.showStarted = [NSDate date];
    
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(ZJViewShowHUDCompletionBlock)completion{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
    
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
    [self showAnimated:animated whileExecutingBlock:block onQueue:queue	completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
     completionBlock:(ZJViewShowHUDCompletionBlock)completion{
    self.taskInProgress = YES;
    self.completionBlock = completion;
    dispatch_async(queue, ^(void) {
        block();
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self stopRotates:animating];
        });
    });
    [self startRotates:animated];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
//http://blog.sina.com.cn/resoftios

@end
//备份
//- (void)dealloc {
//#if !__has_feature(objc_arc)
//    [labelTexts release];
//    [graceTimer release];
//    [minShowTimer release];
//    [showStarted release];
//#if NS_BLOCKS_AVAILABLE
//    [completionBlock release];
//#endif
//    [super dealloc];
//#endif
//}
//
//- (id)initWithView:(UIView *)view {
//    NSAssert(view, @"View must not be nil.");
//    return [self initWithFrame:view.bounds];
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.taskInProgress = NO;
//        [self layoutAllSubviews:frame];
//        
//    }
//    return self;
//}
//
//- (id)initWithWindow:(UIWindow *)window {
//    return [self initWithView:window];
//}
//
//- (void)layoutAllSubviews:(CGRect)frame{
//    /*创建灰色背景*/
//    UIView *maskview = [[UIView alloc] initWithFrame:frame];
//    [self addSubview:maskview];
//    maskview.backgroundColor = [UIColor blackColor];
//    maskview.alpha = 0.3;
//    
//    bgView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width - 100- 61 - 10 * 3) / 2, (self.frame.size.height - 64) / 2, 191, 81)];
//    //    bgView.center = CGPointMake(CGRectGetWidth(maskview.frame)/2, CGRectGetHeight(maskview.frame)/2);
//    //    bgView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - 64)/2);
//    [self addSubview:bgView];
//    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:bgView.frame];
//    //    bgImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    //    bgImageView.image = [UIImage imageNamed:@"d"];
//    bgImageView.backgroundColor = [UIColor whiteColor];
//    bgImageView.layer.masksToBounds = YES;
//    bgImageView.layer.cornerRadius = 3;
//    [self addSubview:bgImageView];
//    
//    bg1 = [[UIView alloc]initWithFrame:CGRectMake(10, 21, 40, 40)];
//    //    bg1.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    [bgImageView addSubview:bg1];
//    
//    bgImageView1 = [[UIImageView alloc] initWithFrame:bg1.frame];
//    bgImageView1.image = [UIImage imageNamed:@"c1.png"];
//    [bgImageView addSubview:bgImageView1];
//    
//    bgImageView2 = [[UIImageView alloc] initWithFrame:bg1.frame];
//    bgImageView2.image = [UIImage imageNamed:@"c.png"];
//    [bgImageView addSubview:bgImageView2];
//    
//    _labelTexts = [[UILabel alloc]initWithFrame:CGRectMake(bgImageView1.frame.origin.x + 61, 10, 100, 61)];
//    [_labelTexts setFont:[UIFont systemFontOfSize:17]];
//    _labelTexts.text = @"加载中...";
//    [bgImageView addSubview:_labelTexts];
//    
//    //    [self startRotate];
//    self.minShowTime = 0.0f;
//    self.graceTime = 0.0f;
//    
//}
////zhangjian01_可以自定义转速哦,越转越快啊
//- (void) rotateWithOptions: (UIViewAnimationOptions) options {
//    
//    [UIView animateWithDuration: 0.08f
//                          delay: 0.0f
//                        options: options
//                     animations: ^{
//                         bgImageView2.transform = CGAffineTransformRotate(bgImageView2.transform, M_PI / 2);
//                     }
//                     completion: ^(BOOL finished) {
//                         if (finished) {
//                             if (animating) {
//                                 
//                                 [self rotateWithOptions: UIViewAnimationOptionCurveLinear];
//                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
//                                 
//                                 [self rotateWithOptions: UIViewAnimationOptionCurveEaseOut];
//                             }
//                         }
//                     }];
//}
//
//- (void) startRotate {
//    if (!animating) {
//        animating = YES;
//        [self rotateWithOptions: UIViewAnimationOptionCurveEaseIn];
//    }
//    [self showUsingAnimation:animating];
//}
//- (void) stopRotate{
//    animating = NO;
//    self.taskInProgress = NO;
//    __weak typeof(self)weakSelf = self;
//    [UIView animateWithDuration:0.5 animations:^{
//        weakSelf.alpha = 0;
//    } completion:^(BOOL finished) {
//        //        [weakSelf stopRotate];
//        [weakSelf removeFromSuperview];
//    }];
//    
//}
//
//- (void) startRotates:(BOOL)animated {
//    animating = animated;
//    if (self.graceTime > 0.0) {
//        self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self
//                                                         selector:@selector(handleGraceTimers:) userInfo:nil repeats:NO];
//    }
//    
//    [self showUsingAnimation:animating];
//}
//
//- (void)handleGraceTimers:(NSTimer *)theTimer {
//    
//    if (_taskInProgress) {
//        [self setNeedsDisplay];
//        [self showUsingAnimation:animating];
//    }
//}
//
//- (void) stopRotates:(BOOL)animated{
//    animating = animated;
//    self.taskInProgress = NO;
//    if (self.minShowTime > 0.0 && _showStarted) {
//        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:_showStarted];
//        if (interv < self.minShowTime) {
//            self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self
//                                                               selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
//            return;
//        }
//    }
//    
//    [self hideUsingAnimation:animating];
//    
//}
//
//- (void)handleMinShowTimer:(NSTimer *)theTimer {
//    [self hideUsingAnimation:animating];
//}
//
//- (void)hideUsingAnimation:(BOOL)animated {
//    
//    if (animated && _showStarted) {
//        
//        __weak typeof(self)weakSelf = self;
//        [UIView animateWithDuration:0.5 animations:^{
//            weakSelf.alpha = 0;
//        } completion:^(BOOL finished) {
//            //        [weakSelf stopRotate];
//            [weakSelf removeFromSuperview];
//        }];
//        
//        [self done];
//        
//    }else{
//        self.alpha = 0.0f;
//        
//    }
//    self.showStarted = nil;
//}
//
//
//- (void)done{
//    if (self.completionBlock) {
//        self.completionBlock();
//        self.completionBlock = NULL;
//    }
//}
//
//- (void)showUsingAnimation:(BOOL)animated{
//    
//    //    if (animated) {
//    [self rotateWithOptions: UIViewAnimationOptionCurveEaseIn];
//    //    }
//    
//    self.showStarted = [NSDate date];
//    
//}
//
//- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(ZJViewShowHUDCompletionBlock)completion{
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    [self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
//    
//}
//
//- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
//    [self showAnimated:animated whileExecutingBlock:block onQueue:queue	completionBlock:NULL];
//}
//
//- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
//completionBlock:(ZJViewShowHUDCompletionBlock)completion{
//    self.taskInProgress = YES;
//    self.completionBlock = completion;
//    dispatch_async(queue, ^(void) {
//        block();
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            [self stopRotates:animating];
//        });
//    });
//    [self startRotates:animated];
//}
///*
// // Only override drawRect: if you perform custom drawing.
// // An empty implementation adversely affects performance during animation.
// - (void)drawRect:(CGRect)rect {
// // Drawing code
// }
// */

