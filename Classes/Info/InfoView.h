//
//  InfoView.h
//  candles
//
//  Created by Sergey Kopanev on 2/28/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"

@interface InfoView : UIView {
	UIImageView *background;
	UIImageView *music;
	UIButton *chooseMusic, *hall, *writeReview, *exit, *facebook, *site;
	SliderView *slider;
	
}
@property (assign) SliderView *slider;
@property (assign) UIButton *chooseMusic;
- (UIButton*) createButtonAtPoint: (CGPoint) p andFileName: (NSString*) imageName;

@end
