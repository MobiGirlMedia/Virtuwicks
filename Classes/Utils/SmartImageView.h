//
//  SmartImageView.h
//  Seasons
//
//  Created by Andrew Kopanev on 10/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	UIVM_Default,
	UIVM_Loading,
	UIVM_NoImage
} URLImageViewMode;

@interface SmartImageView : UIImageView {
	CGSize originalBounds;
	CGPoint originalCenter;	
	UIActivityIndicatorView * indicatorView;
	
	URLImageViewMode viewMode;
	id userPointer;
	NSString *name;
}

@property (nonatomic, retain) NSString *name;
@property (assign) UIActivityIndicatorView * indicatorView;
@property (assign) CGSize originalBounds;
@property (assign) CGPoint originalCenter;
@property (assign) URLImageViewMode viewMode;
@property (nonatomic, retain) id userPointer;

- (void) correctFrame;

@end
