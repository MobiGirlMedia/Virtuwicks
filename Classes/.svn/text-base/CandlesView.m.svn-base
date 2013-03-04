//
//  CandlesView.m
//  Candles
//
//  Created by Sergey Kopanev on 2/1/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "CandlesView.h"

#define _flower_width 110
#define _flower_width_iphone 55


@implementation CandlesView

@synthesize mask, back, jar, waxView, wax, currentAction, jarsScrollView, waxScrollView, addinsScrollView, wickView, jetView, fontsScrollView, titlesView,
			photosView, photosScrollView, bedazzleView, bedazzleScrollView, colorsScrollView, blackMask, control, info, wicks, home, addCategoriesItemsSelector, target, categoriesItemsScrollView,
			backCategories, save, myLayer, logo, barView, background, backs, backName, changeBackSelector, jarsBack, topMask, blackMaskTop, meltView, meltAnimation, barItemsView, blackDown, noTouch,
colorBarView;


- (void) changeBackAction {
	self.backName = [backs objectAtIndex:rand()%[backs count]];
	background.image = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"backs/%@", backName]];
	[target performSelector:changeBackSelector];
}

- (NSMutableArray*) remove2x: (NSArray*) f {
    NSMutableArray *a = [NSMutableArray array];
    for (NSString *s in f) {
        if (NSNotFound == [s rangeOfString:@"@2x"].location) {
            [a addObject:s];
        }
    }
    return a;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
//		self.backgroundColor = [UIColor blackColor];
//		self.image = [ImageUtils loadNativeImage:@"background.png"];
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		
		self.backs = [NSMutableArray array];
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *path = [NSString stringWithFormat:@"%@/%@/backs", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
		NSArray *f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[backs addObject:s];
		}
		
		background = [[UIImageView alloc] initWithFrame:frame];
		[self addSubview:background];
		[background release];
//		background.image = [ImageUtils loadNativeImage:@"background.png"];
		[self changeBackAction];
		
		changeBack = [[UIControl alloc] initWithFrame:frame];
		[self addSubview:changeBack];
		changeBack.userInteractionEnabled = YES;
		[changeBack release];
		[changeBack addTarget:self action:@selector(changeBackAction) forControlEvents:UIControlEventTouchDown];
		
		myLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self addSubview:myLayer];
		[myLayer release];
		myLayer.backgroundColor = [UIColor blackColor];
		myLayer.alpha = 0;
		
/// buttons/logo layer
		imagesLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self addSubview:imagesLayer];
		[imagesLayer release];
		imagesLayer.userInteractionEnabled = NO;
		
		UIImage *img = [ImageUtils loadNativeImage:@"logo.png"];
		logo = [[UIImageView alloc] init];
		
		
		[self addSubview:logo];
		[logo release];
		logo.image = img;
		
		if ([Utils runningUnderiPad]) {
			logo.frame = CGRectMake(540, 10, img.size.width, img.size.height);
			int w = 114;
			int l = (768 - w*3)/4;
			home = [self createButtonAtPoint:CGPointMake(l, 900) imageName:@"buttons/home"];
			info = [self createButtonAtPoint:CGPointMake(l*2+w, 900) imageName:@"buttons/info"];
			wicks = [self createButtonAtPoint:CGPointMake(l*3+w*2, 900) imageName:@"buttons/wick"];
		} else {
			logo.frame = CGRectMake(320-img.size.width, 0, img.size.width, img.size.height);
//			home = [self createButtonAtPoint:CGPointMake(15, 420) imageName:@"buttons/home"];
//			info = [self createButtonAtPoint:CGPointMake(110, 420) imageName:@"buttons/info"];
//			wicks = [self createButtonAtPoint:CGPointMake(205, 420) imageName:@"buttons/wick"];

			int w = 55;
			int l = (320 - w*3)/4;

			
			home = [self createButtonAtPoint:CGPointMake(l, 420) imageName:@"buttons/home"];
			info = [self createButtonAtPoint:CGPointMake(l*2+w, 420) imageName:@"buttons/info"];
			wicks = [self createButtonAtPoint:CGPointMake(l*3+w*2, 420) imageName:@"buttons/wick"];
			
			
		}
		
		
		jarsBack = [[UIImageView alloc] init];
		jarsBack.image = nil;
		[self addSubview:jarsBack];
		[jarsBack release];
		
		
		meltView = [[UIImageView alloc] init];
		meltView.image = nil;
		[self addSubview:meltView];
		[meltView release];		
		meltView.clipsToBounds = YES;

		meltAnimation = [[UIImageView alloc] init];
		meltAnimation.image = nil;
		[self addSubview:meltAnimation];
		[meltAnimation release];		
		meltAnimation.clipsToBounds = YES;
		
		
		
		
		wax = [[UIImageView alloc] init];
		wax.image = nil;
		[self addSubview:wax];
		[wax release];		
		wax.clipsToBounds = YES;
		
		waxView = [[CustomView alloc] init];
		[self addSubview:waxView];
		[waxView release];
		waxView.clipsToBounds = YES;
		waxView.userInteractionEnabled = YES;	

//		waxView.backgroundColor = [UIColor redColor];
		
		
		blackMaskTop = [[UIImageView alloc] init];
		[self addSubview:blackMaskTop];
		[blackMaskTop release];
		topMask = [[UIImageView alloc] init];
		[self addSubview:topMask];
		[topMask release];
		
		
		wickView = [[CustomView alloc] init];
		[self addSubview:wickView];
		[wickView release];
		wickView.userInteractionEnabled = NO;	
		
		jar = [[UIImageView alloc] init];
		[self addSubview:jar];
		[jar release];
//		jar.hidden= YES;
		
		photosView = [[CustomView alloc] init];
		[self addSubview:photosView];
		[photosView release];
		photosView.userInteractionEnabled = NO;	
		photosView.clipsToBounds = YES;

		titlesView = [[UIView alloc] init];
		[self addSubview:titlesView];
		[titlesView release];
		titlesView.multipleTouchEnabled = YES;
		titlesView.userInteractionEnabled = NO;
		titlesView.clipsToBounds = YES;
		
		bedazzleView = [[CustomView alloc] init];
		[self addSubview:bedazzleView];
		[bedazzleView release];
		bedazzleView.userInteractionEnabled = NO;	
		bedazzleView.clipsToBounds = YES;

		
		
		
//		jar.hidden = YES;

		blackDown = [[UIView alloc] init];
		[self addSubview:blackDown];
		[blackDown release];
		blackDown.backgroundColor = [UIColor blackColor];
		blackDown.alpha = 0;
		
		blackMask = [[UIImageView alloc] init];
		[self addSubview:blackMask];
		[blackMask release];
		
//		blackMask.hidden = YES;
		//		topMask.multipleTouchEnabled = YES;
		
		
		mask = [[UIImageView alloc] init];
		[self addSubview:mask];
		[mask release];
//		mask.hidden = YES;
//		mask.multipleTouchEnabled = YES;

		
		jetView = [[UIImageView alloc] init];
		jetView.image = nil;
		[self addSubview:jetView];
		[jetView release];		
		
		

		
//		mask.hidden = YES;
		UIImage *i = [ImageUtils loadNativeImage:@"bar.png"];
		barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [Utils runningUnderiPad] ? 65 : 25, i.size.width, i.size.height)];
		[self addSubview:barView];
		barView.image = i;
		[barView release];
		
		colorBarView = [[UIImageView alloc] init];
		if ([Utils runningUnderiPad]) {
			colorBarView.frame = CGRectMake(210, 210, 768-210, i.size.height/2);
		} else {
			colorBarView.frame = CGRectMake(210, 105, 320-210, i.size.height/1.2);
		}
		[self addSubview:colorBarView];
		colorBarView.userInteractionEnabled = YES;
		colorBarView.image = i;
		[colorBarView release];
		colorBarView.alpha = 0;
		colorsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake([Utils runningUnderiPad] ? 10 : 3, [Utils runningUnderiPad] ? 0 : -3,
																		  colorBarView.frame.size.width-([Utils runningUnderiPad] ? 20 : 6),
																		  [Utils runningUnderiPad] ? 65 : colorBarView.frame.size.height-3)];
		[colorBarView addSubview:colorsScrollView];
		[colorsScrollView release];
		colorsScrollView.showsVerticalScrollIndicator = NO;
		colorsScrollView.showsHorizontalScrollIndicator = NO;
		colorsScrollView.userInteractionEnabled = YES;
//		colorsScrollView.backgroundColor = [UIColor redColor];
		
		
		currentAction = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:currentAction];
//		currentAction.textAlignment = UITextAlignmentCenter;
//		currentAction.backgroundColor = [UIColor clearColor];
//		currentAction.font = [UIFont boldSystemFontOfSize:30];
		
		back = [UIButton buttonWithType:UIButtonTypeCustom];
		if ([Utils runningUnderiPad]) {
			[currentAction.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
			back.frame = CGRectMake(20, 200, 40, 40);
			currentAction.frame = CGRectMake(0, 810+40, 768, 40);
		} else {
			[currentAction.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
			currentAction.frame = CGRectMake(0, 380, 320, 30);
			back.frame = CGRectMake(0, 90, 40, 30);
		}
		[self addSubview:back];
		[back setImage:[ImageUtils loadNativeImage:@"back.png"] forState:UIControlStateNormal];
		
		backCategories = [UIButton buttonWithType:UIButtonTypeCustom];
		backCategories.frame = back.frame;
		[self addSubview:backCategories];
		[backCategories setImage:[ImageUtils loadNativeImage:@"back.png"] forState:UIControlStateNormal];
		
		save = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *im = [ImageUtils loadNativeImage:@"buttons/save.png"];
		if ([Utils runningUnderiPad]) {
			save.frame = CGRectMake(665, 810, im.size.width, im.size.height);
		} else {
			save.frame = CGRectMake(265-5, 373-5, 44, 44);
		}
		[self addSubview:save];
		[save setImage:im forState:UIControlStateNormal];
		[save setImage:[ImageUtils loadNativeImage:@"buttons/save_p.png"] forState:UIControlStateHighlighted];
		
		
		barView.userInteractionEnabled = YES;
		barItemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barView.frame.size.width, [Utils runningUnderiPad] ? 130 : 65 )];
		[barView addSubview:barItemsView];
		[barItemsView release];
		barItemsView.userInteractionEnabled = YES;
		

/// set center to start flower animation		
		
		int flower = _flower_width;
		if (![Utils runningUnderiPad]) {
			flower = _flower_width_iphone;
		}
		
		barItemsView.center = CGPointMake(barItemsView.frame.size.width*1.5 - flower, barItemsView.center.y);
		flowerView = [[UIImageView alloc] initWithImage:[ImageUtils loadNativeImage:@"flower.png"]];
		[barItemsView addSubview:flowerView];
		[flowerView release];
		flowerView.frame = CGRectMake(flower/2-flowerView.image.size.width/2,
									  barItemsView.frame.size.height/2-flowerView.image.size.height/2,
									  flowerView.image.size.width, flowerView.image.size.height);
		
		
		jarsScrollView = [self createScrollView];
		waxScrollView = [self createScrollView];
		addinsScrollView = [self createScrollView];
		fontsScrollView = [self createScrollView];
		photosScrollView = [self createScrollView];
		bedazzleScrollView = [self createScrollView];
		categoriesItemsScrollView = [self createScrollView];
		control = [[UIControl alloc] initWithFrame:frame];
		[self addSubview:control];
		[control release];
		control.userInteractionEnabled = YES;
		control.exclusiveTouch = YES;
		
		noTouch = [[UIControl alloc] initWithFrame:frame];
		[self addSubview:noTouch];
		[noTouch release];
		noTouch.hidden = YES;
		noTouch.userInteractionEnabled = YES;
		[noTouch addTarget:self action:@selector(noTouchSel) forControlEvents:UIControlEventTouchDown];
	}
    return self;
}

- (void) noTouchSel {
	NSLog(@"false !");
}

- (UIButton*) createButtonAtPoint: (CGPoint) p imageName: (NSString*) imageName {
	UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
	[self addSubview:b];
	UIImage *img = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"%@.png", imageName]];
	[b setImage:img forState:UIControlStateNormal];
	[b setImage:[ImageUtils loadNativeImage:[NSString stringWithFormat:@"%@_p.png", imageName]] forState:UIControlStateHighlighted];
	b.frame = CGRectMake(p.x, p.y, img.size.width, img.size.height);
	return b;
}


- (UIScrollView*) createScrollView {
	BOOL ipad = [Utils runningUnderiPad];
	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(ipad ? _flower_width : _flower_width_iphone, 0,
																	  barItemsView.frame.size.width- (ipad ? _flower_width : _flower_width_iphone),
																	  barItemsView.frame.size.height)];
	[barItemsView addSubview:sv];
	[sv release];
	sv.showsVerticalScrollIndicator = NO;
	sv.showsHorizontalScrollIndicator = NO;
	sv.userInteractionEnabled = YES;
	return sv;
}

#pragma mark categories steps
- (void) showCategoriesItems: (int) i {
	catNeedToShowItems = i;
	barItemsView.userInteractionEnabled = NO;
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	barItemsView.center = CGPointMake(barItemsView.frame.size.width*1.5 - ([Utils runningUnderiPad] ? _flower_width : _flower_width_iphone), barItemsView.center.y);
	colorBarView.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(showCategoriesItems)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}

- (void) showCategoriesItems {
	
	/// 	NSLog(@"ll %d", (int)catNeedToShowItems);
	if (catNeedToShowItems != cat_state_default) [target performSelector:addCategoriesItemsSelector withObject:[NSNumber numberWithInt:catNeedToShowItems]];

	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelay:0.5];
	
	barItemsView.center = CGPointMake(barItemsView.frame.size.width/2, barItemsView.center.y);
	categoriesItemsScrollView.hidden = YES;
	photosScrollView.hidden = YES;
	backCategories.hidden = YES;
	switch (catNeedToShowItems) {
		case cat_state_default:
			photosScrollView.hidden = NO;
			break;
		default:
			backCategories.hidden = NO;
			categoriesItemsScrollView.hidden = NO;
			break;
	}
	
	[UIView setAnimationDidStopSelector:@selector(showNewItemsFinish)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
}


#pragma mark Main steps
- (void) showItems: (int) i {
	needToShowItems = i;
	barItemsView.userInteractionEnabled = NO;
	
	if (state_flameit == needToShowItems) {
//		meltView.alpha = 1;
		[self showNewItems];
		return;
	}
	
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	
	barItemsView.center = CGPointMake(barItemsView.frame.size.width*1.5 - ([Utils runningUnderiPad] ? _flower_width : _flower_width_iphone), barItemsView.center.y);
//	barItemsView.center = CGPointMake(390, barItemsView.center.y);

	colorBarView.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(showNewItems)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}

- (void) showNewItems {

	wickView.userInteractionEnabled = NO;
	photosView.userInteractionEnabled = NO;	
	titlesView.userInteractionEnabled = NO;
	bedazzleView.userInteractionEnabled = NO;
	
	
	if (needToShowItems == state_addwick) {
		barItemsView.userInteractionEnabled = YES;
		wickView.userInteractionEnabled = YES;
		return;
	}
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	if (state_flameit != needToShowItems) {
		barItemsView.center = CGPointMake(barItemsView.frame.size.width/2, barItemsView.center.y);
		[UIView setAnimationDelay:0.5];
	}
	categoriesItemsScrollView.hidden = YES;
	colorBarView.hidden = YES;
	photosScrollView.hidden = YES;
	waxScrollView.hidden = YES;
	addinsScrollView.hidden = YES;
	fontsScrollView.hidden = YES;
	jarsScrollView.hidden = YES;
	bedazzleScrollView.hidden = YES;
	myLayer.alpha = 0;
	barView.alpha = 1;
	mask.alpha = 1;
	topMask.alpha = 1;
	home.alpha = 1;
	info.alpha = 1;
	wicks.alpha = 1;
	control.hidden = YES;
	back.alpha = 1;
	logo.alpha = 1;
	save.alpha = 1;
	currentAction.alpha = 1;
	backCategories.hidden = YES;
//	meltView.alpha = 0;
	wax.alpha = 1;
	waxView.alpha = 1;
	blackDown.alpha = 0;

//	currentAction.alpha = 1;
//	currentAction.userInteractionEnabled = NO;
	switch (needToShowItems) {
		case state_choosejar:
			jarsScrollView.hidden = NO;
			break;
		case state_choosewax:
			waxScrollView.hidden = NO;
			break;
		case state_chooseaddins:
			addinsScrollView.hidden = NO;
			break;
		case state_decorate:
			photosScrollView.hidden = NO;
			photosView.userInteractionEnabled = YES;
			break;
		case state_addtext:
			fontsScrollView.hidden = NO;
			titlesView.userInteractionEnabled = YES;
			colorBarView.hidden = NO;
			colorBarView.alpha = 1;
			break;
		case state_addbed:
			bedazzleView.userInteractionEnabled = YES;
			bedazzleScrollView.hidden = NO;
			break;
		case state_flameit:
//			currentAction.alpha = 0;
			mask.alpha = 0;
			topMask.alpha = 0;
			barView.alpha = 0;
			myLayer.alpha = 1;
			home.alpha = 0;
			info.alpha = 0;
			wicks.alpha = 0;
			control.hidden = NO;
			back.alpha = 0;
			logo.alpha = 0;
			currentAction.alpha = 0;
			save.alpha = 0;
			meltView.alpha = 1;
			wax.alpha = 0;
			waxView.alpha = 0;
			break;
			
	}	
	[UIView setAnimationDidStopSelector:@selector(showNewItemsFinish)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];

}



- (void) showNewItemsFinish {
	barItemsView.userInteractionEnabled = YES;
//	currentAction.userInteractionEnabled = YES;
}


- (void)dealloc {
	self.backs = nil;
	self.backName = nil;
    [super dealloc];
}


@end
