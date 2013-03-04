//
//  MovingImageView.m
//  Candles
//
//  Created by Sergey Kopanev on 2/14/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "MovingImageView.h"


@implementation MovingImageView

@synthesize isPhoto, touches1, event1;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.name = nil;
		isPhoto = NO;
		self.userInteractionEnabled = YES;
//		self.backgroundColor = [UIColor redColor];
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
//		[self addGestureRecognizer:doubleTap];
		
		oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Piece:)];		
		if (![oneTap respondsToSelector:@selector(locationInView:)]) {
			[oneTap release];
			oneTap = nil;
		}
		oneTap.numberOfTapsRequired = 1;
//		[self addGestureRecognizer:oneTap];
		
		
    }
    return self;
}

- (void) removeMe {
	[self removeFromSuperview];
}

/*
- (void)tap1Piece:(UITapGestureRecognizer *)gestureRecognizer
{	
	NSLog(@"tap %@", NSStringFromCGRect(gestureRecognizer.view.));
//	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		NSLog(@"1 tap! ");
//	}
	canAdd = YES;
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addPhoto) userInfo:nil repeats:NO];
}

- (void) addPhoto {
	if (canAdd) {
//		gestureRecognizer.
	}
}


- (void)tapPiece:(UITapGestureRecognizer *)gestureRecognizer
{	
	canAdd = NO;
	NSLog(@"cancel touches");
	
//	return;
//	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//		NSLog(@"2 tap! %@", gestureRecognizer);
//	}
	
//	NSLog(@"%d ", (int)gestureRecognizer.numberOfTouchesRequired);
	//	if ( == 2) {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeMe)];
	self.alpha = 0;
	self.transform = CGAffineTransformMakeScale(1.8, 1.8);
	[UIView commitAnimations];
	
	//	}
}
*/

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
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
		
    }
	[[self superview] bringSubviewToFront:self];

}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
	[[self superview] bringSubviewToFront:self];

}


- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self
											 selector:@selector(handleSingleTap)
											   object:nil];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self
											 selector:@selector(handleDoubleTap)
											   object:nil];
	
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event 
{
	if(touches.count == 1)
	{  
		if([[touches anyObject] tapCount] == 2)
		{
			[self performSelector:@selector(handleDoubleTap)
					   withObject:nil
					   afterDelay:0.35]; 
		}
		else if([[touches anyObject] tapCount] == 3)
		{
//			[self handleTripleTap];
		}
		else
		{
			photoPoint = [[touches anyObject] locationInView: self];
			self.touches1 = touches;
			self.event1 = event;
			[self performSelector:@selector(handleSingleTap)
					   withObject:nil
					   afterDelay:0.35]; 
		}
	}
}


- (void) handleSingleTap {
	[super touchesBegan:touches1 withEvent: event1];
	NSLog(@"handleSingleTap");
}

- (void) handleDoubleTap {
	NSLog(@"handleDoubleTap");
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeMe)];
	self.alpha = 0;
	self.transform = CGAffineTransformMakeScale(1.8, 1.8);
	[UIView commitAnimations];
	
}

/*
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch* touch = [touches anyObject];
	killMe = 0;
	if (touch.tapCount == 2) {
		killMe = 1;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(removeMe)];
		self.alpha = 0;
		self.transform = CGAffineTransformMakeScale(1.8, 1.8);
		[UIView commitAnimations];
		
		return;
	}
	
	
	
	//	point1 = [touch locationInView: self.superview];
	
	[self.superview bringSubviewToFront: self];
	//	NSLog(@"Jinkey touch began");
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (killMe) return;
	
	NSLog(@"touches %@", touches);
	
	UITouch* t = [touches anyObject];
	//	CGPoint touchedPoint = [touch locationInView: self.superview];
	//	self.center = touchedPoint;
	//	point1 = touchedPoint;
	CGPoint p = [t locationInView: self.superview];
	CGPoint p1 = [t previousLocationInView: self.superview];
	self.center = CGPointMake(self.center.x + p.x - p1.x, self.center.y + p.y - p1.y);
	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (killMe) return;
	UITouch* t = [touches anyObject];
	//	CGPoint touchedPoint = [touch locationInView: self.superview];	
	//	self.center = touchedPoint;	
	CGPoint p = [t locationInView: self.superview];
	CGPoint p1 = [t previousLocationInView: self.superview];
	self.center = CGPointMake(self.center.x + p.x - p1.x, self.center.y + p.y - p1.y);
	
}
*/
 
- (void)dealloc {
	NSLog(@"MovingImageView dealloc");
//	NSLog(@"dealloc 1");
	if (doubleTap) [doubleTap release];
	if (translate) [translate release];
	if (pinch) [pinch release];
	if (rotation) [rotation release];
	self.name = nil;
	self.image = nil;
//	NSLog(@"dealloc 3");
	self.touches1 = nil;
	self.event1 = nil;
    [super dealloc];
//	NSLog(@"dealloc 2");
}


@end
