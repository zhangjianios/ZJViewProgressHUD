//
//  ZJProgressHUD.h
//  ZJViewProgressHUD
//http://blog.sina.com.cn/resoftios
//  Created by 张建 on 17/1/3.
//  Copyright © 2017年 zhangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @zhangjian01
 *  @自定义加载加载按钮,更换之前第三方的样式.
 */
typedef void (^ZJViewShowHUDCompletionBlock)();
//http://blog.sina.com.cn/resoftios
@interface ZJProgressHUD : UIView

//加载文字
@property (nonatomic,strong)UILabel *labelTexts;


@property (nonatomic, strong) UIImageView *bgImageView;

@property (assign) BOOL taskInProgress;

@property (assign) float minShowTime;

@property (assign) float graceTime;

//初始化视图
- (id)initWithView:(UIView *)view;

//开始加载动画
- (void) startRotates:(BOOL)animated;
- (void) startRotate;
//停止加载动画
- (void) stopRotates:(BOOL)animated;
- (void) stopRotate;

@property (copy) ZJViewShowHUDCompletionBlock completionBlock;

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(ZJViewShowHUDCompletionBlock)completion;

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
     completionBlock:(ZJViewShowHUDCompletionBlock)completion;

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue;
//http://blog.sina.com.cn/resoftios
@end
//http://blog.sina.com.cn/resoftios
