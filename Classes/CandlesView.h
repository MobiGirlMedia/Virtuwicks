//
//  CandlesView.h
//  Candles
//
//  Created by Sergey Kopanev on 2/1/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomScrollView.h"
#import "CustomView.h"
#import "WaxView.h"

@interface CandlesView : UIImageView {
	NSString *backName;
	NSMutableArray *backs;
	UIControl *changeBack;
	UIView *imagesLayer;
	UIView *myLayer;
	UIImageView *logo, *background;
	UIButton *home, *info, *wicks, *pics;
	
	CustomView *waxView, *photosView, *bedazzleView;
	UIImageView *mask, *topMask, *jar, *wax, *blackMask, *blackMaskTop;
	UIView *titlesView;
	UIImageView *jarsBack, *meltView, *meltAnimation;
	UIView *blackDown;
	UIImageView *barView, *colorBarView;
	UIButton *currentAction;
	CustomView *wickView;
	UIImageView *jetView;
	UIView *barItemsView;
	UIImageView *flowerView;
	UIScrollView *jarsScrollView, *waxScrollView, *fontsScrollView, *addinsScrollView, *photosScrollView, *bedazzleScrollView, *colorsScrollView, *categoriesItemsScrollView;
	int needToShowItems, catNeedToShowItems;

	UIButton *back, *backCategories, *save;
	
//	UIButton *addPhoto;
	UIControl *control;

	UIControl *noTouch;

	
	id target;
	SEL addCategoriesItemsSelector;
	SEL changeBackSelector;
}

@property (assign) UIView *blackDown;
@property (assign) UIView *barItemsView;
@property (nonatomic, retain) NSString *backName;
@property (nonatomic, retain) NSMutableArray *backs;
@property (assign) id target;
@property (assign) SEL addCategoriesItemsSelector, changeBackSelector;
@property (assign) UIControl *control, *noTouch;
@property (assign) 	UIButton *home, *info, *wicks, *picks;
@property (assign) UIView *titlesView, *myLayer;
@property (assign) UIScrollView *jarsScrollView, *waxScrollView, *fontsScrollView, *addinsScrollView, *photosScrollView, *bedazzleScrollView, *colorsScrollView, *categoriesItemsScrollView;
@property (assign) UIButton *currentAction, *back, *backCategories, *save;
@property (assign) CustomView *waxView, *wickView, *photosView, *bedazzleView;
@property (assign) UIImageView *mask, *topMask,  *jar, *wax, *jetView, *blackMask, *blackMaskTop, *barView, *logo, *background, *jarsBack, *meltView, *meltAnimation, *colorBarView;

- (void) showItems: (int) i;
- (UIScrollView*) createScrollView;

- (UIButton*) createButtonAtPoint: (CGPoint) p imageName: (NSString*) imageName;
@end
