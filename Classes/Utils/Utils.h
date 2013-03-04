//
//  Utils.h
//  Universal
//
//  Created by Sergey Kopanev on 5/3/10.
//  Copyright 2010 milytia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageUtils.h"

@interface Utils : NSObject {

}

+ (BOOL) runningUnderiPad;

+ (NSString *) documentsDirectory;
+ (NSString *) imagesDirectory;
+ (NSString *) s: (NSString *) s df: (NSString *) df;
+ (void) showAlertTitle: (NSString *) t message: (NSString *) mess;
+ (UIView *) waitingView: (CGRect) fr;
+ (NSMutableArray *) arrayOfArrays: (NSMutableArray *) givenArray splitNum: (int) splitNum;

+ (NSMutableArray *) urlsArrayFromText: (NSString *) text;
+ (NSString *) getDataForCharacter: (int) c fromData: (NSString*) content;

+ (NSString *) replaceSpecialCharacters: (NSString *) str;

+ (NSString *) embedYouTube:(NSString *)urlString frame:(CGRect)frame;

@end
