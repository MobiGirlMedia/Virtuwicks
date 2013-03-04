//
//  SavePageView.m
//  candles
//
//  Created by Sergey Kopanev on 3/2/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "SavePageView.h"

@implementation SavePageView

@synthesize target, selector, deleteItemSelector, sendImage, postToFaceBook, postToFTP, sendUsImage;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [ImageUtils loadNativeImage:@"save/back.jpg"];
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = NO;
		imagesView = [[UIView alloc] initWithFrame:frame];
		[self addSubview:imagesView];
		[imagesView release];

		controlsView = [[UIView alloc] initWithFrame:frame];
		[self addSubview:controlsView];
		[controlsView release];
		controlsView.userInteractionEnabled = YES;
		
		darkView = [[UIView alloc] initWithFrame:frame];
		darkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
		darkView.alpha = 0;
		[self addSubview:darkView];
		darkView.userInteractionEnabled = YES;
		[darkView release];
		isItemShowed = NO;
    }
    return self;
}
-
(void) setContent: (NSMutableArray*) a {
	
	int x = 0;
	int y = 0;
	int tagz = 1;
	
	int aa = 10;
	int l;
	
	int size;
	if ([Utils runningUnderiPad]) {
		l = (768-2*aa)/3;
		size = 230;
	} else {
		l = (320-2*aa)/3;
		size = 95;
	}
	
	
	for (NSString *f in a) {
		
		
		SmartImageView *s = [[SmartImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
//		s.backgroundColor = [UIColor blueColor];
		
#ifdef LITE		
		if ([f isEqualToString:kLiteKey]) {
			
			s.image = [ImageUtils loadNativeImage:@"lite/virtuwicskicon.png"];
			
		} else {
#endif

			s.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/candles/%@/preview", [Utils documentsDirectory], f]];

#ifdef LITE
		}
#endif
		
		
//		NSLog(@"path %@, image %@", [NSString stringWithFormat:@"%@/candles/%@/preview", [Utils documentsDirectory], f], s.image);
		
		
//		NSLog(@"s.frame %@, image %@", NSStringFromCGRect(s.frame), NSStringFromCGSize(s.image.size));

		
		s.tag = tagz;
		s.name = f;
	//	s.backgroundColor = [UIColor redColor];
		int h; 
		if ([Utils runningUnderiPad]) {
			switch (y) {
				case 0:
					h = 265-s.frame.size.height/2;
					break;
				case 1:
					h = 575-s.frame.size.height/2;
					break;
				case 2:
					h = 900-s.frame.size.height/2;
					break;
			}
		} else {
			switch (y) {
				case 0:
					h = 123-s.frame.size.height/2;
					break;
				case 1:
					h = 270-s.frame.size.height/2;
					break;
				case 2:
					h = 430-s.frame.size.height/2;
					break;
			}
		}
		s.center = CGPointMake(aa + l/2 + x*l, h);
		[imagesView addSubview:s];
		[s release];
		
		UIControl *c = [[UIControl alloc] initWithFrame:s.frame];
		[controlsView addSubview:c];
//		c.backgroundColor = [UIColor blueColor];
		[c release];
		c.tag = tagz++;
		[c addTarget:self action:@selector(showItem:) forControlEvents:UIControlEventTouchDown];
		x++;
		if (x >= 3) {
			x = 0;
			y++;
		}
	}
}


- (void) showItem: (UIControl*) c {
	if (isItemShowed) return;
	isItemShowed = YES;
//	NSLog(@"show item %d", c.tag);
	
	float sf = 1.0;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			sf = 2.0;
		}
	}
	
	for (SmartImageView *s in imagesView.subviews) {
		if (s.tag == c.tag) {
			
#ifdef LITE			
			if ([s.name isEqualToString:kLiteKey]) {
				NSLog(@"show lite");
				isItemShowed = NO;
				[self showBuyButton];
				return;
			}
				
#endif 
			
			
//			NSLog(@"s.name %@", s.name);
			si = s;
			[self addSubview:s];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			cr = s.frame;
			s.frame = CGRectMake(self.frame.size.width/2-s.image.size.width/sf, self.frame.size.height/2-s.image.size.height/sf, s.image.size.width*2/sf, s.image.size.height*2/sf);
			if (![Utils runningUnderiPad]) {
				s.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
			}
//			NSLog(@"s.frame %@, image %@", NSStringFromCGRect(s.frame), NSStringFromCGSize(s.image.size));
			darkView.alpha = 1;
			[UIView setAnimationDidStopSelector:@selector(showAlertView)];
			[UIView setAnimationDelegate:self];
			[UIView commitAnimations];
		}
	}
}

- (void) showBuyButton {
	UIControl *c = [[UIControl alloc] initWithFrame:[self bounds]];
	[self addSubview:c];
	[c release];
	c.userInteractionEnabled = YES;
	
	UIImageView *i = [[UIImageView alloc] initWithImage:[ImageUtils loadNativeImage:@"lite/background.png"]];
	i.frame = CGRectMake(310, 170, i.image.size.width, i.image.size.height);
	[c addSubview:i];
	[i release];
	i.alpha  =0;
	i.userInteractionEnabled = YES;
	UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
	[b setImage:[ImageUtils loadNativeImage:@"lite/getitnowbutton.png"] forState:UIControlStateNormal];
	b.frame = CGRectMake(25+3, 490, 348, 80);
	[i addSubview:b];
	[b addTarget:self action:@selector(buyTheGame) forControlEvents:UIControlEventTouchUpInside];
	[b addTarget:c action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
	[b1 setImage:[ImageUtils loadNativeImage:@"lite/closebutton.png"] forState:UIControlStateNormal];
	b1.frame = CGRectMake(360, 10, 32, 32);
	[i addSubview:b1];
	[b1 addTarget:c action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
	
	if (![Utils runningUnderiPad]) {
//		b.frame = CGRectMake(320/2-174/2, 360, 174, 40);
		i.frame = CGRectMake(320/2-i.image.size.width/2, 480/2-i.image.size.height/2, i.image.size.width, i.image.size.height);
		b.center = CGPointMake(i.frame.size.width/2, 360);
		b1.center = CGPointMake(i.frame.size.width-15, 15);
	}
	
	
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	i.alpha = 1;
	[UIView commitAnimations];
	
}

- (void) buyTheGame {
	NSString *url;
	if ([Utils runningUnderiPad]) {
		url = full_link;
	} else {
		url = full_link_iphone;
	}
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void) showAlertView {
	isItemShowed = NO;
	UIAlertView * a = [[UIAlertView alloc] initWithTitle: nil
												 message: nil 
												delegate: self 
									   cancelButtonTitle: @"Close window"
#ifdef LITE
									   otherButtonTitles: @"Burn now", @"Update", @"Delete", nil]; 
#else
									   otherButtonTitles: @"Burn now", @"Email", @"Facebook", @"Share with us", @"Update", @"Delete", nil]; 
#endif
//	a.frame  = CGRectMake(a.frame.origin.x, a.frame.origin.y, , <#CGFloat height#>)
	
//	[a setNumberOfRows:2];

	[a show]; 
	
	NSMutableArray *buttonArray = [a valueForKey:@"_buttons"];
//	NSLog(@"alert %@", buttonArray);
	
#ifndef LITE			
	for (UIButton *b in buttonArray) {
		b.center = CGPointMake(b.center.x, b.center.y + 25);
	}
	
	CGRect frame = a.frame;
	frame.size.height += 30.0f;
	frame.origin.y -= 15;
	a.frame = frame;
#endif
	[a release]; 
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//	NSLog(@"bi %d", buttonIndex);
	
	SmartImageView *smi = [[SmartImageView alloc] initWithFrame:si.frame];
	smi.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/candles/%@/image", [Utils documentsDirectory], si.name]];
	smi.tag = si.tag;
	smi.name = si.name;

	switch (buttonIndex) {
		case 0:	/// close window
			[self hideJar];
			break;
#ifdef LITE
		case 3:	//Delete
#else
		case 6:	//Delete
#endif
			si = nil;
//			[target performSelector:deleteItemSelector withObject:[smi autorelease]];
			[target performSelector:deleteItemSelector withObject:smi];
//			[self hideJar];
			
			break;
		case 1:	// burn now
			[self burnCandle];
			break;
#ifndef LITE
		case 2:	//Email
			[target performSelector:sendImage withObject: smi];
			[self hideJar];
			break;
		case 3:	/// facebook
			NSLog(@"smi %@", smi);
			
			[target performSelector:postToFaceBook withObject: smi];
			[self hideJar];
			break;
		case 4:	/// share with us
			[target performSelector:sendUsImage withObject: smi];
			[self hideJar];
			break;
#endif

#ifdef LITE
		case 2:	// Update
#else
		case 5:	// Update
#endif
			[self loadingCandle];
			break;
	}
	[smi release];
//	NSLog(@"END!!!!!!");
}

- (void) burnCandle {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification
															notificationWithName: kLoadCandleNotificationKey
															object:[NSDictionary dictionaryWithObjectsAndKeys:
																							   si.name, kNameKey,
																							   @"ya", kBurnKey,
																							   nil]]];
	[target performSelector:@selector(hide)];
}

- (void) loadingCandle {
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification
															notificationWithName: kLoadCandleNotificationKey
															object:[NSDictionary dictionaryWithObjectsAndKeys:
																							   si.name, kNameKey,
																							   nil]]];
	[target performSelector:@selector(hide)];
}



- (void) hideJar {
	if (si) [self addSubview:si];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	if (si) si.frame = cr;
	darkView.alpha = 0;
	[UIView setAnimationDidStopSelector:@selector(hideDarkView)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
}
- (void) hideDarkView {
	if (si) [imagesView addSubview:si];
}


- (void)dealloc {
	NSLog(@"dealloc SavePageView");
    [super dealloc];
}


@end
