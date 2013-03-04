//
//  CustomLabel.h
//  candles
//
//  Created by Sergey Kopanev on 2/21/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomLabel : UILabel {
	id target;
	SEL selector;
	int killMe;
	UIGestureRecognizer *pinch, *rotation, *translate;
	UITapGestureRecognizer *doubleTap;
	float scaleCoef;
	NSString *colorName;
}

@property (assign) float scaleCoef;
@property (nonatomic, retain) NSString *colorName;
@property (assign) id target;
@property (assign) SEL selector;

@end
