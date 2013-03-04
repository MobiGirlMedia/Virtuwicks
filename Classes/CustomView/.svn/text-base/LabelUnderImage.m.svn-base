//
//  LabelUnderImage.m
//  Candles
//
//  Created by Sergey Kopanev on 2/11/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "LabelUnderImage.h"


@implementation LabelUnderImage

@synthesize c, selectedImage, imageName, selectedImageName;

- (id)initWithPoint:(CGPoint) p
		  imageName: (NSString*) _imageName
  selectedImageName: (NSString*) _selectedImageName 
		  labelText: (NSString*) text
		  andHeight: (float) height {
	self.imageName = _imageName;
	self.selectedImageName = _selectedImageName;
	UIImage *img = [UIImage imageWithContentsOfFile:imageName];
	
//	NSLog(@"coor %@", NSStringFromCGSize(img.size));
	
	BOOL isSmall;
	int labelHeight;
	CGRect frame;
	
	if ([Utils runningUnderiPad]) {
		isSmall= height< 100;
		labelHeight = isSmall?25:35;
		frame = CGRectMake(p.x, p.y, img.size.width < 90 ? 90 : img.size.width+10, height);
	} else {
		isSmall= height< 40;
		labelHeight = isSmall?15:20;
		frame = CGRectMake(p.x, p.y-5, img.size.width < 80 ? 80 : img.size.width+10, height);
	}
	

    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = YES;
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-img.size.width/2, isSmall?5:10+(frame.size.height-labelHeight)/2-img.size.height/2, 
																  img.size.width, img.size.height)];
		[self addSubview:imageView];
		imageView.image = img;
		[imageView release];
		if (text) {
			label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-labelHeight, 9999, labelHeight)];
			label.textAlignment = UITextAlignmentCenter;
			label.text = text;
			[label sizeToFit];
			if (![Utils runningUnderiPad]) {
				label.font = [UIFont systemFontOfSize:13];
			}
			if (isSmall) label.font = [UIFont systemFontOfSize:12];
			
			if ([Utils runningUnderiPad]) {
				label.center = CGPointMake(frame.size.width/2, frame.size.height-labelHeight/2);
			} else {
				label.center = CGPointMake(frame.size.width/2, frame.size.height-labelHeight/2 + 4);
			}
			
			
			[self addSubview:label];
			[label release];
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor colorWithRed:0.61 green:0.75 blue:0.2 alpha:1];
		} else {
			
//			NSLog(@"image %@", imageView.image);
			
			if ([Utils runningUnderiPad]) {
				imageView.frame = CGRectMake(frame.size.width/2-img.size.width/2, 20+(frame.size.height-35-5)/2-img.size.height/2, 
											 img.size.width, img.size.height);
			} else {
				imageView.frame = CGRectMake(frame.size.width/2-img.size.width/2, 5+(frame.size.height-5)/2-img.size.height/2, 
											 img.size.width, img.size.height);
			}
		}
		
		c = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self addSubview:c];
//		c.backgroundColor = [UIColor redColor];
		[c release];
    }
    return self;
}

- (void) setSelected: (BOOL) s {
//	NSLog(@"sel %@", selectedImageName);
	if (!s) {
		imageView.image = [UIImage imageWithContentsOfFile:imageName];
	} else {
		if (selectedImageName) {
//			NSLog(@"sel %@", selectedImageName);
			imageView.image = [UIImage imageWithContentsOfFile:selectedImageName];
		}
	}
}


- (void)dealloc {
	NSLog(@"LabelUnderImage dealloc");
	self.imageName = nil;
	self.selectedImageName = nil;
    [super dealloc];
}


@end
