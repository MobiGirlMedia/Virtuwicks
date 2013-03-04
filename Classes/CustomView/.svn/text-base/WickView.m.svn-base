//
//  WickView.m
//  candles
//
//  Created by Sergey Kopanev on 2/24/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "WickView.h"

#define _max_smoke_sprites 17

@implementation WickView

@synthesize currentFlameSprite, flame;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		if ([Utils runningUnderiPad]) {
			flame = [[UIImageView alloc] initWithFrame:CGRectMake(-70+3, -155, 155, 276)];
			smoke = [[UIImageView alloc] initWithFrame:CGRectMake(-90, -210, 174, 252)];
		} else {
			float sf = 1;
			if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
				if ([[UIScreen mainScreen] scale] == 2.0) {
					sf = 2.0;
				}
			}
			flame = [[UIImageView alloc] initWithFrame:CGRectMake(-35+4, -74+1, 74, 131)];
			smoke = [[UIImageView alloc] initWithFrame:CGRectMake(-50, -210, 83, 120)];
			
		}
		[self addSubview:flame];
		[flame release];
		flame.alpha = 0;

		[self addSubview:smoke];
		[smoke release];
		smoke.alpha = 0;
		smokeTimer = nil;
	}
    return self;
}

- (void) showFlameImage: (NSString*) newImage {
	flame.image = [ImageUtils loadNativeImage:newImage];
}

- (void) showSmoke {
	smokeSprite = 1;
	[self startSmokeTimer];
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:_max_smoke_sprites*1.0/12.0];
	flame.alpha = 0;
	[UIView commitAnimations];
}

- (void) smokeRenderer {
	if (smokeSprite <= _max_smoke_sprites) {
		smoke.alpha = 1;
		smoke.image = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"smoke/smoke%04d.png", smokeSprite++]];
	} else {
		smoke.alpha = 0;
		[self stopSmokeTimer];
	}
}

- (void) startSmokeTimer {
	[self stopSmokeTimer];
	smokeTimer = [NSTimer scheduledTimerWithTimeInterval:1/12.0 target:self selector:@selector(smokeRenderer) userInfo:nil repeats:YES];
}

- (void) stopSmokeTimer {
	if (smokeTimer) {
		[smokeTimer invalidate];
	}
	smokeTimer = nil;
}

	 
- (void)dealloc {
	NSLog(@"WickView dealloc");
    [super dealloc];
}


@end
