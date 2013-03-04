//
//  CustomScrollView.m
//  candles
//
//  Created by Sergey Kopanev on 2/18/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "CustomScrollView.h"


@implementation CustomScrollView

@synthesize selectedImage;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        selectedImage = nil;
    }
    return self;
}


- (void)dealloc {
	NSLog(@"CustomScrollView dealloc");
    [super dealloc];
}


@end
