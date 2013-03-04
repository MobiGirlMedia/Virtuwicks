//
//  HomeController.h
//  candles
//
//  Created by Sergey Kopanev on 3/11/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeView.h"
#import <AVFoundation/AVFoundation.h>
#import "CandlesController.h"

#import <MobiGirl/MGAd.h>

@interface HomeController : UIViewController {
	HomeView *homeView;
	AVAudioPlayer *backgroundTrack;
	CandlesController *c;
	
	BOOL firstRun;
	UIActivityIndicatorView *indikator;
	UIControl *control;
    
    MGAd *ad;
}

@end
