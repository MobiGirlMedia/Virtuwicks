//
//  SavePageView.h
//  candles
//
//  Created by Sergey Kopanev on 3/2/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartImageView.h"
#import <MessageUI/MessageUI.h>


@interface SavePageView : UIImageView <UIAlertViewDelegate> {
	UIView *darkView;
	UIView *imagesView;
	UIView *controlsView;
	SmartImageView *si;
	CGRect cr;
	
	id target;
	SEL selector;
	SEL deleteItemSelector;
	SEL sendImage;
	SEL postToFaceBook;
	SEL postToFTP;
	SEL sendUsImage;
	
	BOOL isItemShowed;
	
	
	
	
}

@property (assign) id target;
@property (assign) SEL selector, deleteItemSelector, sendImage, postToFaceBook, postToFTP, sendUsImage;


- (void) setContent: (NSMutableArray*) a;


@end
