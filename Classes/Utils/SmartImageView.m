//
//  SmartImageView.m
//  Seasons
//
//  Created by Andrew Kopanev on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SmartImageView.h"


@implementation SmartImageView
@synthesize viewMode, originalBounds, originalCenter, indicatorView, name;
@synthesize userPointer;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		originalBounds = CGSizeMake(frame.size.width, frame.size.height);
		originalCenter = self.center;
		indicatorView = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 20, 20)];
		indicatorView.center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);			
		indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[indicatorView startAnimating];
		[self addSubview: indicatorView];
		self.name = nil;
		self.viewMode = UIVM_Default;
		
    }
	
    return self;
}

- (void) setViewMode: (URLImageViewMode) m {
	viewMode = m;
	
	switch (viewMode) {
		case UIVM_Default:
			[indicatorView removeFromSuperview];
			break;
			
		case UIVM_Loading:
			self.image = nil;
			[self addSubview: indicatorView];
			break;
			
		case UIVM_NoImage:
			self.image = nil;
			[indicatorView removeFromSuperview];
			break;			
	}
	
	[self correctFrame];
}

- (void) correctFrame {
	CGAffineTransform t = self.transform;	
	if (self.image) {
		float wRatio = originalBounds.width / self.image.size.width;
		float hRatio = originalBounds.height / self.image.size.height;
		float ratio = hRatio > wRatio ? wRatio : hRatio;
		if (self.image.size.width < originalBounds.width && self.image.size.height < originalBounds.height) {
			ratio = 1;
		}
		float w = self.image.size.width * ratio;
		float h = self.image.size.height * ratio;
		self.transform = CGAffineTransformIdentity;
		[self setFrame: CGRectMake(originalCenter.x - w * .5,
								   originalCenter.y - h * .5,
								   w, h)];
		indicatorView.center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
	} else {
		self.transform = CGAffineTransformIdentity;
		self.frame = CGRectMake(originalCenter.x - originalBounds.width * .5,
								originalCenter.y - originalBounds.height * .5,
								originalBounds.width, originalBounds.height);
		indicatorView.center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
	}
	self.transform = t;	
}

- (void) setImage:(UIImage *) i {
	[super setImage: i];
	if (i) {
		[indicatorView removeFromSuperview];
	} 
	
	[self correctFrame];	
}

- (void)dealloc {
	self.name = nil;
	self.userPointer = nil;
	[indicatorView release];
    [super dealloc];
}

@end
