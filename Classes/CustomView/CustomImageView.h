//
//  CustomImageView.h
//  candles
//
//  Created by Sergey Kopanev on 3/1/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomImageView : UIImageView {
	NSString *name;
}

@property (nonatomic, retain) NSString *name;

@end
