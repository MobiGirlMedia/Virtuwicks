//
//  CandlesAppDelegate.h
//  Candles
//
//  Created by Sergey Kopanev on 2/16/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandlesController.h"
#import "HomeController.h"

@interface CandlesAppDelegate : NSObject <UIApplicationDelegate> {
	UINavigationController *nav;
    UIWindow *window;
	HomeController *c;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

