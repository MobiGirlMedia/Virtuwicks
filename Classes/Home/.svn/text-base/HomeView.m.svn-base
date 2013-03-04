//
//  HomeView.m
//  candles
//
//  Created by Sergey Kopanev on 3/11/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "HomeView.h"


@implementation HomeView

@synthesize c;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = YES;
		if ([Utils runningUnderiPad]) {
			self.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Default.png", [[NSBundle mainBundle] bundlePath]]];
		} else {
			self.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Default_iPhone.png", [[NSBundle mainBundle] bundlePath]]];

		}
		
		c = [[UIControl alloc] initWithFrame:frame];
		[self addSubview:c];
		[c release];
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
