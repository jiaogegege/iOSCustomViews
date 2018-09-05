//
//  TickWhiteView.h
//
//  Code generated using QuartzCode 1.63.0 on 18/5/29.
//  www.quartzcodeapp.com
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TickWhiteView : UIView

@property (nonatomic, strong) UIColor * ck_red;
@property (nonatomic, strong) UIColor * white;
@property (nonatomic, strong) UIColor * ck_gray;

- (void)addTickViewAnimation;
- (void)addTickViewAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock;
- (void)addTickViewAnimationTotalDuration:(CFTimeInterval)totalDuration completionBlock:(void (^)(BOOL finished))completionBlock;
- (void)removeAnimationsForAnimationId:(NSString *)identifier;
- (void)removeAllAnimations;

@end
