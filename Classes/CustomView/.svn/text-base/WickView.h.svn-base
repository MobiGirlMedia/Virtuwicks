//
//  WickView.h
//  candles
//
//  Created by Sergey Kopanev on 2/24/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WickView : UIImageView {
	int currentFlameSprite;
	int smokeSprite;
	UIImageView *flame;
	UIImageView *smoke;
	NSTimer *smokeTimer;
}

@property (assign) int currentFlameSprite;
@property (assign) UIImageView *flame;


- (void) startSmokeTimer;
- (void) stopSmokeTimer;

@end
