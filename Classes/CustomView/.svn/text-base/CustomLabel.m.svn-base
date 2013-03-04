//
//  CustomLabel.m
//  candles
//
//  Created by Sergey Kopanev on 2/21/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "CustomLabel.h"
#import <QuartzCore/QuartzCore.h>

#define _label_border 10
#define _label_height 65


#define _default_back_alpha 0.5

@implementation CustomLabel

@synthesize target, selector, colorName, scaleCoef;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.colorName = @"black";
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:_default_back_alpha];
		self.layer.cornerRadius = 5;
		self.text = @"";
		self.textColor = [UIColor blackColor];
		self.font = [UIFont systemFontOfSize:_default_point_size];
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pichAction:)];		
		if (![pinch respondsToSelector:@selector(locationInView:)]) {
			[pinch release];
			pinch = nil;
		}
		[self addGestureRecognizer:pinch];
		
		rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];		
		if (![rotation respondsToSelector:@selector(locationInView:)]) {
			[rotation release];
			rotation = nil;
		}
		[self addGestureRecognizer:rotation];
		
		
		translate = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];		
		if (![translate respondsToSelector:@selector(locationInView:)]) {
			[translate release];
			translate = nil;
		}
		[self addGestureRecognizer:translate];
		
		doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];		
		if (![doubleTap respondsToSelector:@selector(locationInView:)]) {
			[doubleTap release];
			doubleTap = nil;
		}
		doubleTap.numberOfTapsRequired = 2;
		[self addGestureRecognizer:doubleTap];
		
		scaleCoef = 1.0;
		
    }
	target = nil;
	selector = nil;
    return self;
}

- (void) setText:(NSString *) s {
	[super setText:s];
	
	int w = self.frame.size.width;
	int h = self.frame.size.height;
	CGSize ns = [s sizeWithFont:self.font];
	
	int l = (ns.width-w)/2;
	
	l += _label_border*2;
	
	CGAffineTransform f = self.transform;
	self.transform = CGAffineTransformIdentity;
	
	int height = ns.height>_label_height?ns.height:_label_height;
	
	
	if ( !s || ![s length]) {
		l = _label_border*2;
		self.frame = CGRectMake(self.frame.origin.x - (l-w)/2, self.frame.origin.y,  l, h>_label_height ? h : _label_height);
	} else {
		self.frame = CGRectMake(self.frame.origin.x - (ns.width-w)/2, self.frame.origin.y-(height-h)/2, ns.width, height);
	}
	self.transform = f;
}

- (void) removeMe {
	if (target && selector) {
		[target performSelector:selector withObject:nil];
	}
	[self removeFromSuperview];	
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (target && selector) {
		[target performSelector:selector withObject:self];
	}
}

- (void)tapPiece:(UITapGestureRecognizer *)gestureRecognizer
{	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeMe)];
	self.alpha = 0;
	self.transform = CGAffineTransformMakeScale(1.8, 1.8);
	[UIView commitAnimations];
}


- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
	[[self superview] bringSubviewToFront:self];
}


- (void) pichAction: (UIPinchGestureRecognizer*) gestureRecognizer {
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
//      [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
//      [gestureRecognizer setScale:1];
		
		if (gestureRecognizer.scale > 1) {
			scaleCoef *= 1.03;
		} else {
			scaleCoef *= 0.98;
		}
//		scaleCoef *= gestureRecognizer.scale;
		if (scaleCoef < 1.0) scaleCoef = 1.0;
		if (scaleCoef > 3.5) scaleCoef = 3.5;
		
		self.font = [UIFont fontWithName:self.font.fontName size:_default_point_size*scaleCoef];
		self.text = self.text;
    }
	[[self superview] bringSubviewToFront:self];
	
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
	return;
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
	[[self superview] bringSubviewToFront:self];
	
}

- (void) setBackground: (BOOL) b {
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
//	self.alpha = b ? 0.8 : 1.0;
	self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:b ? _default_back_alpha : 0.0];
	
	
	[UIView commitAnimations];
	
	
	[UIColor clearColor];
}



- (void)dealloc {
	NSLog(@"CustomLabel dealloc");
	self.colorName = nil;
    [super dealloc];
}


@end
