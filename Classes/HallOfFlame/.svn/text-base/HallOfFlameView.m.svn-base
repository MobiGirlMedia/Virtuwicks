//
//  HallOfFlameView.m
//  candles
//
//  Created by Sergey Kopanev on 3/11/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "HallOfFlameView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HallOfFlameView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
/*		UIImage *img = [ImageUtils loadNativeImage:@"hall/hall.png"];
		background = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - img.size.width/2, self.frame.size.height/2 - img.size.height/2,
																   img.size.width, img.size.height)];
		[self addSubview:background];
		background.image = img;
		[background release];
		background.userInteractionEnabled = YES;
*/
		
		UIImage *img = [ImageUtils loadNativeImage:@"hall/hall_top.png"];

		CGRect r  = CGRectMake(self.frame.size.width/2 - img.size.width/2, self.frame.size.height/2 - img.size.height/2,
							   img.size.width, img.size.height);
		

		self.userInteractionEnabled = YES;
		
		
		
		
		webView = [[UIWebView alloc] initWithFrame:CGRectMake(15+r.origin.x, 90+r.origin.y, 375, 490)];
		webView.backgroundColor = [UIColor whiteColor];
//		webView.layer.cornerRadius = 150;
		[self addSubview:webView];
		[webView release];
		
		if ([Utils runningUnderiPad]) {
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://appsnminded.com/wicks/hall-of-flame-123456789.html"]]];
		} else {
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://appsnminded.com/wicks/hall-of-flame-3456789.html"]]];
			
		}
		

		UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - img.size.width/2, self.frame.size.height/2 - img.size.height/2,
																	   img.size.width, img.size.height)];
		[self addSubview:i];
		i.image = img;
		[i release];
		i.userInteractionEnabled = NO;
		
		exit = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:exit];
		exit.frame = CGRectMake(0, 0, 50, 50);
		exit.center = CGPointMake(370+r.origin.x, 35+r.origin.y);
		[exit setImage:[ImageUtils loadNativeImage:@"info/closebutton.png"] forState:UIControlStateNormal];
		[exit addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];

		
		if (![Utils runningUnderiPad]) {
			webView.frame = CGRectMake(5+r.origin.x, 40+r.origin.y, 265, 310);
			exit.frame = CGRectMake(0, 0, 40, 40);
			exit.center = CGPointMake(260+r.origin.x, 15+r.origin.y);
		}
		
		
    }
    return self;
}


- (void) exitAction {
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	self. alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}

- (void)dealloc {
    [super dealloc];
}


@end
