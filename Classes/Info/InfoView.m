//
//  InfoView.m
//  candles
//
//  Created by Sergey Kopanev on 2/28/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "InfoView.h"
#import "HallOfFlameView.h"

@implementation InfoView

@synthesize slider, chooseMusic;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
		self.backgroundColor = [UIColor clearColor];
		UIImage *img = [ImageUtils loadNativeImage:@"info/background.png"];
		background = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - img.size.width/2, self.frame.size.height/2 - img.size.height/2,
																												img.size.width, img.size.height)];
		[self addSubview:background];
		background.image = img;
		[background release];
		background.userInteractionEnabled = YES;
		

		img = [ImageUtils loadNativeImage:@"info/music.png"];

		exit = [UIButton buttonWithType:UIButtonTypeCustom];

		if ([Utils runningUnderiPad]) {
			music = [[UIImageView alloc] initWithFrame:CGRectMake(40, 150, img.size.width, img.size.height)];
			chooseMusic = [self createButtonAtPoint:CGPointMake(20, 210-3) andFileName:@"info/choosemusic.png"];
			hall = [self createButtonAtPoint:CGPointMake(20, 270) andFileName:@"info/hallofflame.png"];
			writeReview = [self createButtonAtPoint:CGPointMake(20, 330) andFileName:@"info/review.png"];
			facebook = [self createButtonAtPoint:CGPointMake(20, 390) andFileName:@"info/facebook.png"];
			site = [self createButtonAtPoint:CGPointMake(20, 455) andFileName:@"info/website.png"];
			slider = [[SliderView alloc] initAtPoint:CGPointMake(260, 140) andState:NO];
			exit.frame = CGRectMake(120, 120, 50, 50);
			exit.center = CGPointMake(370, 35);
		} else {
			music = [[UIImageView alloc] initWithFrame:CGRectMake(20, 85, img.size.width, img.size.height)];
			chooseMusic = [self createButtonAtPoint:CGPointMake(5, 130-10) andFileName:@"info/choosemusic.png"];
			hall = [self createButtonAtPoint:CGPointMake(5, 162) andFileName:@"info/hallofflame.png"];
			writeReview = [self createButtonAtPoint:CGPointMake(5, 204) andFileName:@"info/review.png"];
			facebook = [self createButtonAtPoint:CGPointMake(5, 246) andFileName:@"info/facebook.png"];
			site = [self createButtonAtPoint:CGPointMake(5, 288) andFileName:@"info/website.png"];
			slider = [[SliderView alloc] initAtPoint:CGPointMake(200, 80) andState:NO];
			exit.frame = CGRectMake(0, 0, 40, 40);
			exit.center = CGPointMake(260, 15);
		}

		music.image = img;

		
		[hall addTarget:self action:@selector(showHall) forControlEvents:UIControlEventTouchUpInside];
		[site addTarget:self action:@selector(goSite) forControlEvents:UIControlEventTouchUpInside];
		[facebook addTarget:self action:@selector(goFace) forControlEvents:UIControlEventTouchUpInside];
		[writeReview addTarget:self action:@selector(reviewUs) forControlEvents:UIControlEventTouchUpInside];
		[background addSubview:music];
		[music release];
		[background addSubview:slider];
		[slider release];
		
		[background addSubview:exit];
//		[exit setTitle:@"exit" forState:UIControlStateNormal];
		[exit setImage:[ImageUtils loadNativeImage:@"info/closebutton.png"] forState:UIControlStateNormal];
		[exit addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void) reviewUs {
//	NSString *url = @"http://click.linksynergy.com/fs-bin/click?id=IRnqa4K4BNk&subid=&offerid=146261.1&type=10&tmpid=3909&RD_PARM1=http%3A%2F%2Fhttp%3A%2F%2Fitunes.apple.com%2Fus%2Fapp%2Fvirtuwicks-candle-maker%2Fid428116156%3Fmt%3D8";
	NSString *url;
	if ([Utils runningUnderiPad]) {
		url = full_link;
	} else {
		url = full_link_iphone;
	}
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void) goFace {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Virtuwicks/195808137104077"]];
}

- (void) goSite {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://virtuwicks.com"]];
}

- (void) showHall {
	HallOfFlameView *h = [[HallOfFlameView alloc] initWithFrame:self.frame];
	[self addSubview:h];
	[h release];
}

- (UIButton*) createButtonAtPoint: (CGPoint) p andFileName: (NSString*) imageName {
	UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
	[background addSubview:b];
	if ([Utils runningUnderiPad]) {
		b.frame = CGRectMake(p.x, p.y, 375, 60);
	} else {
		b.frame = CGRectMake(p.x, p.y, 260, 40);
	}
//	b.backgroundColor = [UIColor redColor];
	[b setImage:[ImageUtils loadNativeImage:imageName] forState:UIControlStateNormal];
	return b;
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
