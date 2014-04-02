//
//  UIView+Additon.m
//  XianchangjiaAlbum
//
//  Created by JIJIA &&&&& ljh on 12-12-10.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import "UIView+Additon.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (Additon)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.left + self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.top + self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//截图
- (UIImage *)viewToImage:(UIView *)view
{
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) viewBackgroundShadow
{
	// Background shadow
	CAGradientLayer *dropshadowLayer = [CAGradientLayer layer];
//	dropshadowLayer.contentsScale = scale;
	dropshadowLayer.startPoint = CGPointMake(0.0f, 0.0f);
	dropshadowLayer.endPoint = CGPointMake(0.0f, 1.0f);
	dropshadowLayer.opacity = 1.0;
	dropshadowLayer.frame = CGRectMake(1.0f, 1.0f, self.frame.size.width - 2.0, self.frame.size.height - 2.0);
	dropshadowLayer.locations = [NSArray arrayWithObjects:
								 [NSNumber numberWithFloat:0.0f],
								 [NSNumber numberWithFloat:1.0f], nil];
	dropshadowLayer.colors = [NSArray arrayWithObjects:
							  (id)[[UIColor colorWithWhite:224.0/256.0 alpha:1.0] CGColor],
							  (id)[[UIColor colorWithWhite:235.0/256.0 alpha:1.0] CGColor], nil];
	
	[self.layer insertSublayer:dropshadowLayer below:self.layer];
	
}
 
- (void)showAnimatingLayer
{
    // Here we are creating an explicit animation for the layer's "transform" property.
    // - The duration (in seconds) is controlled by the user.
    // - The repeat count is hard coded to go "forever".
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [pulseAnimation setDuration:0.3];
    [pulseAnimation setRepeatCount:DOMAIN];
    
    // The built-in ease in/ ease out timing function is used to make the animation look smooth as the layer
    // animates between the two scaling transformations.
    [pulseAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // Scale the layer to half the size
    CATransform3D transform = CATransform3DMakeScale(1.50, 1.50, 1.0);
    
    // Tell CA to interpolate to this transformation matrix
    [pulseAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [pulseAnimation setToValue:[NSValue valueWithCATransform3D:transform]];
    
    // Tells CA to reverse the animation (e.g. animate back to the layer's transform)
    [pulseAnimation setAutoreverses:YES];
    
    // Finally... add the explicit animation to the layer..t. the animation automatically starts.
    [self.layer addAnimation:pulseAnimation forKey:@"BTSPulseAnimation"];
}

- (void)endAnimatingLayer
{
    [self.layer removeAnimationForKey:@"BTSPulseAnimation"];
}

//椭圆  圆形   根据图片切图
/*
// displaying the image in a rounded rect
UIImageView *backingViewForRoundedCorner = [[UIImageView alloc] initWithFrame:CGRectMake(20, 180, 120, 120)];
backingViewForRoundedCorner.layer.cornerRadius = 20.0f;
backingViewForRoundedCorner.clipsToBounds = YES;
[self.view addSubview:backingViewForRoundedCorner];

self.imageViewWithRoundedCorners = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
imageViewWithRoundedCorners.backgroundColor = [UIColor lightGrayColor];
[backingViewForRoundedCorner addSubview:imageViewWithRoundedCorners];


// displaying the image in a circle by using a shape layer
// layer fill color controls the masking
CAShapeLayer *maskLayer = [CAShapeLayer layer];
maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
UIBezierPath *layerPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, 118, 118)];
maskLayer.path = layerPath.CGPath;
maskLayer.fillColor = [UIColor blackColor].CGColor;

// use another view for clipping so that when the image size changes, the masking layer does not need to be repositioned
UIView *clippingViewForLayerMask = [[UIView alloc] initWithFrame:CGRectMake(160, 180, 120, 120)];
clippingViewForLayerMask.layer.mask = maskLayer;
clippingViewForLayerMask.clipsToBounds = YES;
[self.view addSubview:clippingViewForLayerMask];

self.layerMaskedCircleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
layerMaskedCircleImageView.backgroundColor = [UIColor lightGrayColor];
[clippingViewForLayerMask addSubview:layerMaskedCircleImageView];


// displaying the image in a radial gradient by using a png mask
// image alpha channel controls the masking
CALayer *imageMaskLayer = [CALayer layer];
UIImage *pattern = [UIImage imageNamed:@"pattern.png"];
imageMaskLayer.contents = (__bridge id)pattern.CGImage;
imageMaskLayer.frame = CGRectMake(0, 0, pattern.size.width, pattern.size.height);

// use another view for clipping so that when the image size changes, the masking layer does not need to be repositioned
UIView *clippingViewForLayerImageMask = [[UIView alloc] initWithFrame:CGRectMake(20, 310, 120, 120)];
clippingViewForLayerImageMask.layer.mask = imageMaskLayer;
clippingViewForLayerImageMask.clipsToBounds = YES;
[self.view addSubview:clippingViewForLayerImageMask];
*/

@end
