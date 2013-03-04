//
//  SliderView.m
//  candles
//
//  Created by Sergey Kopanev on 2/28/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "SliderView.h"


@implementation SliderView

@synthesize isStateOn, target, selector;

- (id)initAtPoint:(CGPoint) p andState: (BOOL) state {
   
    self = [super init];
    if (self) {
		isStateOn = state;
        self.image = [ImageUtils loadNativeImage:@"info/onoff.png"];
		self.frame = CGRectMake(p.x, p.y, self.image.size.width, self.image.size.height);
		toggleView = [[UIImageView alloc] init];
		toggleView.image = [ImageUtils loadNativeImage:@"info/onofftoggle.png"];
		[self addSubview:toggleView];
		self.userInteractionEnabled = YES;
		
		/// toggle view control
		UIControl *c = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
		[self addSubview:c];
		[c release];
		[c addTarget:self action:@selector(switchState:) forControlEvents:UIControlEventTouchDown];
		[self switchState:nil];
		target = nil;
		selector = nil;
    }
    return self;
}

- (void) switchState: (UIControl*) c {
	if (c) {
		isStateOn = !isStateOn;
		[UIView beginAnimations:nil context:0];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
	}
	if ([Utils runningUnderiPad]) {
		if (!isStateOn) {
			toggleView.frame = CGRectMake(0, 2, toggleView.image.size.width, toggleView.image.size.height);
		} else {
			toggleView.frame = CGRectMake(toggleView.image.size.width, 2, toggleView.image.size.width, toggleView.image.size.height);
		}
	} else {
		if (!isStateOn) {
			toggleView.frame = CGRectMake(0, 1, toggleView.image.size.width, toggleView.image.size.height);
		} else {
			toggleView.frame = CGRectMake(toggleView.image.size.width, 1, toggleView.image.size.width, toggleView.image.size.height);
		}
	}
	if (c) [UIView commitAnimations];
	
	if (target && selector) {
		[target performSelector:selector withObject:isStateOn];
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
