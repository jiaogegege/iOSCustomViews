//
//  TickView.h
//
//  Code generated using QuartzCode 1.63.0 on 18/5/29.
//  www.quartzcodeapp.com
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TickView : UIView

@property (nonatomic, strong) UIColor * ck_red;
@property (nonatomic, strong) UIColor * white;

- (void)addTickViewAnimation;
- (void)addTickViewAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock;
- (void)addTickViewAnimationTotalDuration:(CFTimeInterval)totalDuration completionBlock:(void (^)(BOOL finished))completionBlock;
- (void)removeAnimationsForAnimationId:(NSString *)identifier;
- (void)removeAllAnimations;

@end
