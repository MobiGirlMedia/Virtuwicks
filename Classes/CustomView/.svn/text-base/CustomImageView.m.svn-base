//
//  CustomImageView.m
//  candles
//
//  Created by Sergey Kopanev on 3/1/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "CustomImageView.h"


@implementation CustomImageView

@synthesize name;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.name = nil;
		self.tag = _custom_view_tag;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	NSLog(@"CustomImageView dealloc");
	self.name = nil;
    [super dealloc];
}


@end
