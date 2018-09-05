//
//  TickView.m
//
//  Code generated using QuartzCode 1.63.0 on 18/5/29.
//  www.quartzcodeapp.com
//

#import "TickView.h"
#import "QCMethod.h"

@interface TickView ()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableDictionary * layers;
@property (nonatomic, strong) NSMapTable * completionBlocks;
@property (nonatomic, assign) BOOL  updateLayerValueForCompletedAnimation;


@end

@implementation TickView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setupProperties];
		[self setupLayers];
	}
	return self;
}



- (void)setupProperties{
	self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];;
	self.layers = [NSMutableDictionary dictionary];
	self.ck_red = [UIColor colorWithRed:0.892 green: 0.25 blue:0.373 alpha:1];
	self.white = [UIColor colorWithRed:1 green: 1 blue:1 alpha:1];
}

- (void)setupLayers{
	self.backgroundColor = [UIColor colorWithRed:1 green: 1 blue:1 alpha:1];
	
	CAShapeLayer * oval = [CAShapeLayer layer];
	oval.frame = CGRectMake(1, 1, 58, 58);
	oval.path = [self ovalPath].CGPath;
	[self.layer addSublayer:oval];
	self.layers[@"oval"] = oval;
    oval.strokeEnd = 0;
	
	CAShapeLayer * oval2 = [CAShapeLayer layer];
	oval2.frame = CGRectMake(1, 1, 58, 58);
	oval2.path = [self oval2Path].CGPath;
	[self.layer addSublayer:oval2];
	self.layers[@"oval2"] = oval2;
	
	CAShapeLayer * path = [CAShapeLayer layer];
	path.frame = CGRectMake(14.46, 19.8, 31.34, 25.2);
	path.path = [self pathPath].CGPath;
	[self.layer addSublayer:path];
	self.layers[@"path"] = path;
	
	[self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	if(!layerIds || [layerIds containsObject:@"oval"]){
		CAShapeLayer * oval = self.layers[@"oval"];
		[oval setValue:@(-315 * M_PI/180) forKeyPath:@"transform.rotation"];
		oval.fillColor   = nil;
		oval.strokeColor = [UIColor colorWithRed:0.892 green: 0.25 blue:0.373 alpha:1].CGColor;
		oval.lineWidth   = 3;
	}
	if(!layerIds || [layerIds containsObject:@"oval2"]){
		CAShapeLayer * oval2 = self.layers[@"oval2"];
		oval2.fillColor   = nil;
		oval2.strokeColor = self.ck_red.CGColor;
		oval2.lineWidth   = 0;
	}
	if(!layerIds || [layerIds containsObject:@"path"]){
		CAShapeLayer * path = self.layers[@"path"];
		path.hidden      = YES;
		path.lineCap     = kCALineCapRound;
		path.fillColor   = nil;
		path.strokeColor = self.white.CGColor;
		path.lineWidth   = 4;
	}
	
	[CATransaction commit];
}

#pragma mark - Animation Setup

- (void)addTickViewAnimation{
	[self addTickViewAnimationCompletionBlock:nil];
}

- (void)addTickViewAnimationCompletionBlock:(void (^)(BOOL finished))completionBlock{
	[self addTickViewAnimationTotalDuration:1.452 completionBlock:completionBlock];
}

- (void)addTickViewAnimationTotalDuration:(CFTimeInterval)totalDuration completionBlock:(void (^)(BOOL finished))completionBlock{
	if (completionBlock){
		CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
		completionAnim.duration = totalDuration;
		completionAnim.delegate = self;
		[completionAnim setValue:@"TickView" forKey:@"animId"];
		[completionAnim setValue:@(NO) forKey:@"needEndAnim"];
		[self.layer addAnimation:completionAnim forKey:@"TickView"];
		[self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"TickView"]];
	}
	
	NSString * fillMode = kCAFillModeForwards;
	
	////Oval animation
	CAKeyframeAnimation * ovalStrokeEndAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
	ovalStrokeEndAnim.values   = @[@0, @1];
	ovalStrokeEndAnim.keyTimes = @[@0, @1];
	ovalStrokeEndAnim.duration = 0.399 * totalDuration;
	
	CAKeyframeAnimation * ovalTransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	ovalTransformAnim.values         = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation(315 * M_PI/180, 0, 0, -1)], 
		 [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeScale(1.2, 1.2, 1.2), CATransform3DMakeRotation(-315 * M_PI/180, -0, 0, 1))]];
	ovalTransformAnim.keyTimes       = @[@0, @1];
	ovalTransformAnim.duration       = 0.196 * totalDuration;
	ovalTransformAnim.beginTime      = 0.607 * totalDuration;
	ovalTransformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	ovalTransformAnim.autoreverses   = YES;
	
	CAKeyframeAnimation * ovalFillColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
	ovalFillColorAnim.values    = @[(id)self.ck_red.CGColor, 
		 (id)self.ck_red.CGColor];
	ovalFillColorAnim.keyTimes  = @[@0, @1];
	ovalFillColorAnim.duration  = 0.196 * totalDuration;
	ovalFillColorAnim.beginTime = 0.607 * totalDuration;
	
	CAAnimationGroup * ovalTickViewAnim = [QCMethod groupAnimations:@[ovalStrokeEndAnim, ovalTransformAnim, ovalFillColorAnim] fillMode:fillMode];
	[self.layers[@"oval"] addAnimation:ovalTickViewAnim forKey:@"ovalTickViewAnim"];
	
	////Oval2 animation
	CAKeyframeAnimation * oval2TransformAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	oval2TransformAnim.values    = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], 
		 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
	oval2TransformAnim.keyTimes  = @[@0, @1];
	oval2TransformAnim.duration  = 0.208 * totalDuration;
	oval2TransformAnim.beginTime = 0.399 * totalDuration;
	
	CAKeyframeAnimation * oval2LineWidthAnim = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
	oval2LineWidthAnim.values         = @[@0, @60];
	oval2LineWidthAnim.keyTimes       = @[@0, @1];
	oval2LineWidthAnim.duration       = 0.208 * totalDuration;
	oval2LineWidthAnim.beginTime      = 0.399 * totalDuration;
	oval2LineWidthAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.42 :0 :1.02 :0.974];
	
	CAAnimationGroup * oval2TickViewAnim = [QCMethod groupAnimations:@[oval2TransformAnim, oval2LineWidthAnim] fillMode:fillMode];
	[self.layers[@"oval2"] addAnimation:oval2TickViewAnim forKey:@"oval2TickViewAnim"];
	
	////Path animation
	CAKeyframeAnimation * pathHiddenAnim = [CAKeyframeAnimation animationWithKeyPath:@"hidden"];
	pathHiddenAnim.values                = @[@NO, @NO];
	pathHiddenAnim.keyTimes              = @[@0, @1];
	pathHiddenAnim.duration              = 0.214 * totalDuration;
	pathHiddenAnim.beginTime             = 0.607 * totalDuration;
	
	CAKeyframeAnimation * pathOpacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	pathOpacityAnim.values                = @[@0, @1];
	pathOpacityAnim.keyTimes              = @[@0, @1];
	pathOpacityAnim.duration              = 0.214 * totalDuration;
	pathOpacityAnim.beginTime             = 0.607 * totalDuration;
	
	CAAnimationGroup * pathTickViewAnim = [QCMethod groupAnimations:@[pathHiddenAnim, pathOpacityAnim] fillMode:fillMode];
	[self.layers[@"path"] addAnimation:pathTickViewAnim forKey:@"pathTickViewAnim"];
}

#pragma mark - Animation Cleanup

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
	if (completionBlock){
		[self.completionBlocks removeObjectForKey:anim];
		if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
			[self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
			[self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
		}
		completionBlock(flag);
	}
}

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"TickView"]){
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"oval"] animationForKey:@"ovalTickViewAnim"] theLayer:self.layers[@"oval"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"oval2"] animationForKey:@"oval2TickViewAnim"] theLayer:self.layers[@"oval2"]];
		[QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"path"] animationForKey:@"pathTickViewAnim"] theLayer:self.layers[@"path"]];
	}
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
	if([identifier isEqualToString:@"TickView"]){
		[self.layers[@"oval"] removeAnimationForKey:@"ovalTickViewAnim"];
		[self.layers[@"oval2"] removeAnimationForKey:@"oval2TickViewAnim"];
		[self.layers[@"path"] removeAnimationForKey:@"pathTickViewAnim"];
	}
}

- (void)removeAllAnimations{
	[self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
		[layer removeAllAnimations];
	}];
}

#pragma mark - Bezier Path

- (UIBezierPath*)ovalPath{
//    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(30, 30) radius:30 - 1.5 startAngle:-2 * M_PI + M_PI / 4.0 endAngle:2 * M_PI - M_PI / 4.0 clockwise:YES];
	UIBezierPath *ovalPath = [UIBezierPath bezierPath];
	[ovalPath moveToPoint:CGPointMake(49.506, 49.506)];
	[ovalPath addCurveToPoint:CGPointMake(49.506, 8.494) controlPoint1:CGPointMake(60.831, 38.181) controlPoint2:CGPointMake(60.831, 19.819)];
	[ovalPath addCurveToPoint:CGPointMake(8.494, 8.494) controlPoint1:CGPointMake(38.181, -2.831) controlPoint2:CGPointMake(19.819, -2.831)];
	[ovalPath addCurveToPoint:CGPointMake(8.494, 49.506) controlPoint1:CGPointMake(-2.831, 19.819) controlPoint2:CGPointMake(-2.831, 38.181)];
	[ovalPath addCurveToPoint:CGPointMake(49.506, 49.506) controlPoint1:CGPointMake(19.819, 60.831) controlPoint2:CGPointMake(38.181, 60.831)];
	
	return ovalPath;
}

- (UIBezierPath*)oval2Path{
	UIBezierPath * oval2Path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 58, 58)];
	return oval2Path;
}

- (UIBezierPath*)pathPath{
	UIBezierPath *pathPath = [UIBezierPath bezierPath];
	[pathPath moveToPoint:CGPointMake(0, 15.619)];
	[pathPath addCurveToPoint:CGPointMake(22.14, 12.861) controlPoint1:CGPointMake(14.687, 28.943) controlPoint2:CGPointMake(10.74, 28.692)];
	[pathPath addCurveToPoint:CGPointMake(31.338, 0) controlPoint1:CGPointMake(24.562, 9.497) controlPoint2:CGPointMake(27.657, 5.273)];
	
	return pathPath;
}


@end
