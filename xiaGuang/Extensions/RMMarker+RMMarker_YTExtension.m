//
//  RMMarker+RMMarker_YTExtension.m
//  BeaconTest
//
//  Created by Ke ZhuoPeng on 14-7-28.
//  Copyright (c) 2014年 YunTOP. All rights reserved.
//

#import "RMMarker+RMMarker_YTExtension.h"
#import "UIColor+ExtensionColor_UIImage+ExtensionImage.h"
#define BUBBLE_LAYER_NAME @"bubble"

static YTCompletion Completion = nil;
@implementation RMMarker (RMMarker_YTExtension)
- (id)initWithUserLocation{
    self = [super init];
    if (self) {
        self.zPosition = 0;
        self.bounds = CGRectMake(0, 0, 0, 0);
        self.masksToBounds = NO;

        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(-50,-50, 100, 100);
        layer.backgroundColor = [[UIColor blueColor] CGColor];
        layer.opacity = 0;
        layer.name = @"halo";
        layer.cornerRadius = 50.0;
        //[self addSublayer:layer];
        //[self didAppear];
        
        CALayer *circle2 = [CALayer layer];
        UIImage *circle2Image = [UIImage imageNamed:@"nav_img_circle2"];
        circle2.frame = CGRectMake(-circle2Image.size.width / 2, -circle2Image.size.height / 2, circle2Image.size.width, circle2Image.size.height);
        circle2.contents = (id)[circle2Image CGImage];
        [self addSublayer:circle2];
       
        
        CALayer *circle1 = [CALayer layer];
        UIImage *circle1Image = [UIImage imageNamed:@"nav_img_circle1"];
        circle1.frame = CGRectMake(-circle1Image.size.width / 2, -circle1Image.size.height / 2, circle1Image.size.width, circle1Image.size.height);
        circle1.contents = (id)[circle1Image CGImage];
        [self addSublayer:circle1];
        
        CALayer *direction = [CALayer layer];
        layer.masksToBounds = NO;
        UIImage *directionImage = [UIImage imageNamed:@"nav_img_pionter"];
        direction.frame = CGRectMake(-directionImage.size.width / 2,-directionImage.size.height / 2, directionImage.size.width, directionImage.size.height);
        
        //direction.backgroundColor = [[UIColor blackColor] CGColor];
        
        direction.contents = (id)[directionImage CGImage];
        //direction.anchorPoint = CGPointMake(0.5, 1);
        direction.name = @"arrow";
        [self addSublayer:direction];
        
        CALayer *userLayer = [CALayer layer];
        userLayer.masksToBounds = NO;
        UIImage *userImage = [UIImage imageNamed:@"nav_img_me"];
        userLayer.frame = CGRectMake(0, 0, userImage.size.width - 40,userImage.size.height - 40);
        userLayer.anchorPoint = CGPointMake(1, 1);
        userLayer.contentsScale = 0.8;
        userLayer.contents = (id)userImage.CGImage;
       //[self addSublayer:userLayer];
       
        CABasicAnimation *circle1animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        circle1animation.toValue = [NSNumber numberWithFloat:-M_PI * 2.0];
        circle1animation.duration = 17.0;
        circle1animation.repeatCount = MAXFLOAT;
        [circle1 addAnimation:circle1animation forKey:@"circle1rotation"];
        
        CABasicAnimation *circle2animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        circle2animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        circle2animation.duration = 20.0;
        circle2animation.repeatCount = MAXFLOAT;
        [circle2 addAnimation:circle2animation forKey:@"circle2rotation"];
        
        
        
//        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        CGContextSetShadow(context, CGSizeMake(0, 0), whiteWidth / 4.0);
//        
//        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
//        CGContextFillEllipseInRect(context, CGRectMake((rect.size.width - whiteWidth) / 2.0, (rect.size.height - whiteWidth) / 2.0, whiteWidth, whiteWidth));
//        
//        UIImage *whiteBackground = UIGraphicsGetImageFromCurrentImageContext();
//        
//        UIGraphicsEndImageContext();
//        
//        CALayer *imageLayer = [CALayer layer];
//        imageLayer.bounds = CGRectMake(0, 0, whiteBackground.size.width, whiteBackground.size.height);
//        imageLayer.contents = (id)[whiteBackground CGImage];
//        [self addSublayer:imageLayer];
//        
//        CGFloat tintedWidth = whiteWidth * 0.7;
//        
//        rect = CGRectMake(0, 0, tintedWidth, tintedWidth);
//        
//        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
//        context = UIGraphicsGetCurrentContext();
//        
//        CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
//        CGContextFillEllipseInRect(context, CGRectMake((rect.size.width - tintedWidth) / 2.0, (rect.size.height - tintedWidth) / 2.0, tintedWidth, tintedWidth));
//        
//        UIImage *tintedForeground = UIGraphicsGetImageFromCurrentImageContext();
//        
//        UIGraphicsEndImageContext();
//        
//        CALayer *dotLayer = [CALayer layer];
//        dotLayer.bounds = CGRectMake(0, 0, tintedForeground.size.width, tintedForeground.size.height);
//        dotLayer.contents = (id)[tintedForeground CGImage];
//        dotLayer.position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
//        
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//        animation.repeatCount = MAXFLOAT;
//        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
//        animation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)];
//        animation.removedOnCompletion = NO;
//        animation.autoreverses = YES;
//        animation.duration = 1.5;
//        animation.beginTime = CACurrentMediaTime() + 1.0;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        
//        [dotLayer addAnimation:animation forKey:@"animateTransform"];
//        
//        [self addSublayer:dotLayer];
        
    }
    return self;
}

- (void)userLocationDirection:(CATransform3D)transform3D{
    for (CALayer *directionLayer in self.sublayers) {
        if ([directionLayer.name isEqualToString:@"arrow"]) {
            directionLayer.transform = transform3D;
        }
    }
}


- (id)initWithMerchantImage:(UIImage *)image{
    self = [super init];
    if (self) {
        self.contents = (id)[image CGImage];
        self.contentsScale = image.scale;
        self.bounds = CGRectMake(0, 0, image.size.width,image.size.height);
        self.masksToBounds = NO;
    }
    self.zPosition = 10;
    return self;
}


-(id)initWithMerchant:(NSString *)merchantName{
    self = [super init];
    if (self) {
        CATextLayer *textLayer = [[CATextLayer alloc] init];
        textLayer.frame = CGRectMake(0,0, 100, 20);
        textLayer.string = @"";
        textLayer.name = @"textLayer";
        textLayer.fontSize = 10;
        textLayer.foregroundColor =[[UIColor colorWithString:@"404040"] CGColor];
        textLayer.backgroundColor = [[UIColor blackColor] CGColor];
        self.bounds = CGRectMake(0, 0, 100, 20);
        self.masksToBounds = NO;
        
        CALayer *imageLayer = [CALayer layer];
        UIImage *image = [UIImage imageNamed:@"nav_img_end"];
        int imgWidth = image.size.width - 60;
        imageLayer.frame = CGRectMake(50-imgWidth/2,0, imgWidth, image.size.height - 60);
        imageLayer.anchorPoint = CGPointMake(0.5, 1);
        imageLayer.contents = (id)[image CGImage];
        imageLayer.contentsScale = image.scale;
        imageLayer.opacity = 0;
        imageLayer.name = BUBBLE_LAYER_NAME;
        
        
        [self addSublayer:textLayer];
        [self addSublayer:imageLayer];
    }
    self.zPosition = 10;
    return self;
}


-(id)initWithBubbleHeight:(float)height width:(float)width{
    self = [super init];
    if (self) {
        CATextLayer *textLayer = [[CATextLayer alloc] init];
        textLayer.frame = CGRectMake(-width * 13 / 2,0, (width + 0.5) * 13,(height + 0.5)* 13);
        textLayer.string = @"";
        textLayer.name = @"textLayer";
        textLayer.fontSize = 10;
        textLayer.foregroundColor =[[UIColor colorWithString:@"404040"] CGColor];
        //textLayer.backgroundColor = [[UIColor blackColor] CGColor];
        self.masksToBounds = NO;
        
        CALayer *imageLayer = [CALayer layer];
        UIImage *image = [UIImage imageNamed:@"nav_img_end_un"];
        int imgWidth = image.size.width;
        int imgHeight = image.size.height;
        imageLayer.frame = CGRectMake(-imgWidth / 2 - 5,-imgHeight / 2, 38, 49);
        imageLayer.anchorPoint = CGPointMake(0.5, 1);
        imageLayer.contents = (id)[image CGImage];
        imageLayer.contentsScale = image.scale;
        imageLayer.opacity = 0;
        imageLayer.name = BUBBLE_LAYER_NAME;
        
        CALayer *iconLayer = [CALayer layer];
        iconLayer.name = @"icon";
        iconLayer.frame = CGRectMake(4, 4, 30, 30);
        iconLayer.masksToBounds = YES;
        iconLayer.cornerRadius = CGRectGetWidth(iconLayer.frame) / 2;
        [imageLayer addSublayer:iconLayer];
        [self addSublayer:textLayer];
        [self addSublayer:imageLayer];
    }
    self.zPosition = 10;
    return self;
}


-(void)superHightlightMerchantLayer{
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:BUBBLE_LAYER_NAME]) {
            //[curLayer removeAllAnimations];
            
            
            curLayer.opacity = 1;
            UIImage *image = [UIImage imageNamed:@"nav_img_end"];

            curLayer.contents =(id)[image CGImage];
            break;
        }
    }
}

-(void)cancelSuperHighlight{
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:BUBBLE_LAYER_NAME]) {
            //[curLayer removeAllAnimations];
            
            
            curLayer.opacity = 1;
            UIImage *image = [UIImage imageNamed:@"nav_img_end_un"];
            
            curLayer.contents =(id)[image CGImage];
            break;
        }
    }
}

-(void)setMerchantIcon:(UIImage *)image{
    for (CALayer *layer in self.sublayers) {
        if ([layer.name isEqualToString:BUBBLE_LAYER_NAME]) {
            for (CALayer *subLayer in layer.sublayers) {
                if ([subLayer.name isEqualToString:@"icon"]) {
                    subLayer.contents = (id)[image CGImage];
                    subLayer.contentsScale = image.scale;
                }
            }
        }
    }
}

-(id)initWithElevator{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"nav_img_near"];
        self.bounds = CGRectMake(0, 0, 0, 0);
        self.masksToBounds = NO;
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        imageLayer.anchorPoint = CGPointMake(0.5, 1);
        imageLayer.contents = (id)[image CGImage];
        imageLayer.contentsScale = image.scale;
        imageLayer.opacity = 0;
        imageLayer.name = @"Elevator";
        [self addSublayer:imageLayer];
        
    }
    self.zPosition = 10;
    return self;
}

- (id)initWithBeaconForMajorAreaID:(NSString *)majorID minorID:(NSString *)minorID{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 5, 5);
        self.masksToBounds = NO;
        CGFloat whiteWidth = 5.0;
        CGRect rect = CGRectMake(0, 0, whiteWidth * 1.25, whiteWidth * 1.25);
        
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetShadow(context, CGSizeMake(0, 0), whiteWidth / 4.0);
        
        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
        CGContextFillEllipseInRect(context, CGRectMake((rect.size.width - whiteWidth) / 2.0, (rect.size.height - whiteWidth) / 2.0, whiteWidth, whiteWidth));
        
        UIImage *whiteBackground = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        self.contents = (id)[whiteBackground CGImage];
    
        
        NSString *string = [NSString stringWithFormat:@"major:%@  minor:%@",majorID,minorID];
        CGSize textSize = [string boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.frame), textSize.width, textSize.height);
        textLayer.foregroundColor = [UIColor redColor].CGColor;
        textLayer.fontSize = 12;
        textLayer.string = string;
        [self addSublayer:textLayer];
    }
    return self;
    
}
- (void)activeBubbleImage:(UIImage *)image{
    
    CALayer *curBubble = [self getBubbleLayer];
    if(curBubble == Nil){
        CALayer *imageLayer = [CALayer new];
        imageLayer.contents = (id)[image CGImage];
        imageLayer.frame = CGRectMake(0, image.size.height*-1, image.size.width, image.size.height);
        imageLayer.name = BUBBLE_LAYER_NAME;
        [self addSublayer:imageLayer];
        
    }
    
    curBubble.opacity = 1;
    /*self.contents = (id)[image CGImage];
     self.bounds = CGRectMake(0, 0, image.size.width,image.size.height);
     self.masksToBounds = NO;*/
}

-(void)deactiveBubble{
    CALayer *curBubble = [self getBubbleLayer];
    if(curBubble != nil){
        curBubble.opacity = 0;
    }
}

-(CALayer *)getBubbleLayer{
    CALayer *result;
    for(CALayer *curLayer in self.sublayers){
        if([curLayer.name isEqualToString:BUBBLE_LAYER_NAME])
        {
            result = curLayer;
        }
    }
    return result;
}


- (void)disappear{
    for(int i = 0; i<self.sublayers.count; i++){
        CALayer * curLayer = [self.sublayers objectAtIndex:i];
        if([curLayer.name isEqualToString:@"halo"]){
            [curLayer removeAllAnimations];
            CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            
            boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
            boundsAnimation.duration = 4;
            [curLayer addAnimation:boundsAnimation forKey:@"animateScale"];
            
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
            opacityAnimation.toValue   = [NSNumber numberWithFloat:-1.0];
            opacityAnimation.duration = 4;
            opacityAnimation.removedOnCompletion = NO;
            opacityAnimation.fillMode = kCAFillModeForwards;
            [curLayer addAnimation:opacityAnimation forKey:@"animateOpacity"];
            break;
        }
    }
}

-(void)didAppear{
    self.opacity = 1;
    for (CALayer* curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:@"halo"]) {
            [curLayer removeAllAnimations];
            CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            
            boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
            boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)];

            
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            opacityAnimation.toValue   = [NSNumber numberWithFloat:-1.0];

            
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.animations = @[boundsAnimation,opacityAnimation];
            group.repeatCount = MAXFLOAT;
            group.removedOnCompletion = NO;
            group.duration = 1;
            [curLayer addAnimation:group forKey:@"group"];
            break;
        }
    }
}
- (void)showMerchantAnimation:(BOOL)animation{
    Completion = nil;
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:BUBBLE_LAYER_NAME]) {
            [curLayer removeAllAnimations];
            curLayer.opacity = 1;
            if (animation) {
                CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                boundsAnimation.repeatCount = 1;
                boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
                boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
                boundsAnimation.delegate = self;
                boundsAnimation.removedOnCompletion = NO;
                boundsAnimation.duration = 1;
                [curLayer addAnimation:boundsAnimation forKey:@"merchantShow"];
            }
            break;
        }
    }
}

- (void)showBubble:(BOOL)animation{
    Completion = nil;
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:BUBBLE_LAYER_NAME]) {
            [curLayer removeAllAnimations];
            curLayer.opacity = 1;
            if (animation) {
                CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                boundsAnimation.repeatCount = 1;
                boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
                boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
                boundsAnimation.delegate = self;
                boundsAnimation.removedOnCompletion = NO;
                boundsAnimation.duration = 1;
                [curLayer addAnimation:boundsAnimation forKey:@"merchantShow"];
            }
            break;
        }
    }
}


- (void)hideMerchantAnimation:(BOOL)animation{
    Completion = nil;
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:BUBBLE_LAYER_NAME]) {
            [curLayer removeAllAnimations];
            if (animation) {
                CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                boundsAnimation.repeatCount = 1;
                boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
                boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)];
                boundsAnimation.removedOnCompletion = NO;
                boundsAnimation.duration = 1;
                boundsAnimation.delegate = self;
                boundsAnimation.fillMode = kCAFillModeForwards;
                [curLayer addAnimation:boundsAnimation forKey:@"merchantHide"];
            }
            break;
        }
    }
}

- (void)hideBubble:(BOOL)animation{
    Completion = nil;
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:BUBBLE_LAYER_NAME]) {
            [curLayer removeAllAnimations];
            if (animation) {
                CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                boundsAnimation.repeatCount = 1;
                boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
                boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)];
                boundsAnimation.removedOnCompletion = NO;
                boundsAnimation.duration = 1;
                boundsAnimation.delegate = self;
                boundsAnimation.fillMode = kCAFillModeForwards;
                [curLayer addAnimation:boundsAnimation forKey:@"merchantHide"];
            }
            break;
        }
    }
}


-(void)showElevatorAnimation{
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:@"Elevator"]) {
            curLayer.opacity = 1;
            CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            boundsAnimation.repeatCount = 1;
            boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
            boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            boundsAnimation.removedOnCompletion = NO;
            boundsAnimation.duration = 1;
            [curLayer addAnimation:boundsAnimation forKey:@"scale"];
            break;
        }
    }
}

- (void)hideElevatorAnimation{
    for (CALayer *curLayer in self.sublayers) {
        if ([curLayer.name isEqualToString:@"Elevator"]) {
            
            CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            boundsAnimation.repeatCount = 1;
            boundsAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
            boundsAnimation.toValue   = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)];
            boundsAnimation.removedOnCompletion = NO;
            boundsAnimation.duration = 1;
            boundsAnimation.fillMode = kCAFillModeForwards;
            [curLayer addAnimation:boundsAnimation forKey:@"scale"];
            break;
        }
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        if(Completion != nil){
            Completion();
        }
    }
}

-(instancetype)initWithParkingLayer{
    self = [super init];
    if (self) {
        self.zPosition = 0;
        self.bounds = CGRectMake(0, 0, 0, 0);
        self.masksToBounds = NO;
        
        CALayer *respirationLamp = [CALayer layer];
        respirationLamp.backgroundColor = [UIColor redColor].CGColor;
        respirationLamp.bounds = CGRectMake(0, 0, 100, 100);
        respirationLamp.name = @"halo";
        respirationLamp.cornerRadius = CGRectGetWidth(respirationLamp.frame) / 2;
        [self addSublayer:respirationLamp];
        [self didAppear];
    }
    return self;
}
-(instancetype)initWithParkingMarkLayer{
    self = [super init];
    if (self) {
        
        self.bounds = CGRectMake(0, 0, 0, 0);
        self.masksToBounds = NO;
        self.opacity = 0.0f;
        CALayer *car = [CALayer layer];
        UIImage *carImage = [UIImage imageNamed:@"parking_img_car"];
        car.contents = (id)[carImage CGImage];
        car.contentsScale = carImage.scale;
        car.frame = CGRectMake(-(carImage.size.width / 2), -(carImage.size.height / 2), carImage.size.width, carImage.size.height);
        [self addSublayer:car];
    }
    self.zPosition = 10;
    return self;
}
-(void)showParkingMark{
    self.opacity = 1.0f;
}
-(void)hideParkingMark{
    self.opacity = 0.0f;
}
@end
