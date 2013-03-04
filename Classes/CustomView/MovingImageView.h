//
//  MovingImageView.h
//  Candles
//
//  Created by Sergey Kopanev on 2/14/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartImageView.h"

@interface MovingImageView : SmartImageView {
	int killMe;
	UIGestureRecognizer *pinch, *rotation, *translate;
	UITapGestureRecognizer *doubleTap, *oneTap;
	BOOL isPhoto;
	BOOL canAdd;
	CGPoint photoPoint;
	NSSet *touches1;
	UIEvent *event1;
}

@property (assign) BOOL isPhoto;

@property (nonatomic, retain) NSSet *touches1;
@property (nonatomic, retain) UIEvent *event1;

@end
