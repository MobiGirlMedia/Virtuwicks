//
//  CustomView.m
//  candles
//
//  Created by Sergey Kopanev on 2/19/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "CustomView.h"


@implementation CustomView

@synthesize target, selector;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        target = nil;
		selector = nil;
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* t = [touches anyObject];
	CGPoint p = [t locationInView: self];
	NSString *str = NSStringFromCGPoint(p);
//	NSLog(@"point %@", str);
	
//	NSLog(@"%@", NSStringFromSelector(selector));
	
	if (target && selector) [target performSelector:selector withObject:str];
	
//	[self.superview touchesBegan:touches withEvent:event];
	
}


- (void)dealloc {
	NSLog(@"CustomView dealloc");
	[super dealloc];
}


@end
