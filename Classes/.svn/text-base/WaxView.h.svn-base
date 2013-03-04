//
//  WaxView.h
//  Candles
//
//  Created by Sergey Kopanev on 2/2/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaxView : UIView {
	int heigth;
	int startPoint;
	CGPoint currentPoint;
	CGPoint bottomPoint;
	int sprite;
	NSString *name;
	
	/// files
	int waxNumber;
	
	/// images
	UIImage *largePic, *bottomPic;
	NSMutableArray *animationImages;
	
	BOOL canDraw;
	
}

@property (assign) BOOL canDraw;
@property (nonatomic, retain) UIImage *largePic, *bottomPic;
@property (nonatomic, retain) NSMutableArray *animationImages;
@property (nonatomic, retain) NSString *name;
@property (assign) int heigth, startPoint;
@property (assign) CGPoint currentPoint, bottomPoint;
@end
