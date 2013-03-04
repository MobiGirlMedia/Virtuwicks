//
//  SaveView.m
//  candles
//
//  Created by Sergey Kopanev on 2/28/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "SaveView.h"


@implementation SaveView

@synthesize scrollView, homeButton;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
		[self addSubview:scrollView];
		[scrollView release];
		self.multipleTouchEnabled = NO;
		self.userInteractionEnabled = YES;
		scrollView.pagingEnabled = YES;
		self.backgroundColor = [UIColor blackColor];
		scrollView.userInteractionEnabled = YES;
		scrollView.multipleTouchEnabled = NO;
		scrollView.showsHorizontalScrollIndicator = NO;
		
		
		logo = [[UIImageView alloc] init];
		logo.image = [ImageUtils loadNativeImage:@"logo.png"];
		[self addSubview:logo];
		[logo release];
		
		control = [[UIControl alloc] initWithFrame:frame];
		[self addSubview:control];
		[control release];
		control.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
		control.userInteractionEnabled = NO;
		control.alpha = 0;
		
		indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		[control addSubview:indicator];
		[indicator release];
		[indicator startAnimating];
		
		progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
		[control addSubview:progressLabel];
		progressLabel.text = @"Uploading to facebook...";
		progressLabel.textAlignment = UITextAlignmentCenter;
		progressLabel.textColor = [UIColor whiteColor];
		progressLabel.backgroundColor = [UIColor clearColor];
		[progressLabel release];
		
		
		if ([Utils runningUnderiPad]) {
			indicator.center = CGPointMake(768/2, 1024/2 - 30);
			progressLabel.center = CGPointMake(768/2, 1024/2 + 20);
			logo.frame = CGRectMake(768-logo.image.size.width-20, 1024-logo.image.size.height-10, logo.image.size.width, logo.image.size.height);
			homeButton = [self createButtonAtPoint:CGPointMake(20, 1024-70-5+15) imageName:@"buttons/smallhome"];
		} else {
			homeButton = [self createButtonAtPoint:CGPointMake(5, 480-28) imageName:@"buttons/smallhome"];
			logo.frame = CGRectMake(320-logo.image.size.width-5, 480-logo.image.size.height-5, logo.image.size.width, logo.image.size.height);
			indicator.center = CGPointMake(320/2, 480/2 - 30);
			progressLabel.center = CGPointMake(320/2, 480/2 + 20);
		}
		
		
		
		
    }
    return self;
}

- (void) addControl: (BOOL) willShow {
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	control.alpha = willShow ? 1 : 0;
	control.userInteractionEnabled = willShow;
	[UIView commitAnimations];
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



- (void)dealloc {
	NSLog(@"dealloc SaveView");
    [super dealloc];
}


@end
