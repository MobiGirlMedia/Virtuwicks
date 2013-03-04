//
//  LabelUnderImage.h
//  Candles
//
//  Created by Sergey Kopanev on 2/11/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LabelUnderImage : UIView {
	UIImageView *imageView;
	UILabel *label;
	UIControl *c;
	NSString *imageName, *selectedImageName;
}


@property (nonatomic, retain) NSString *imageName, *selectedImageName;
@property (assign) UIImageView *selectedImage;
@property (assign) UIControl *c;
- (id)initWithPoint:(CGPoint) p
		  imageName: (NSString*) _imageName
  selectedImageName: (NSString*) _selectedImageName 
		  labelText: (NSString*) text
		  andHeight: (float) height;

@end
