//
//  CandlesController.h
//  Candles
//
//  Created by Sergey Kopanev on 2/1/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandlesView.h"
#import "WaxView.h"
#import <AVFoundation/AVFoundation.h>
#import "MovingImageView.h"
#import "CustomLabel.h"
#import "WickView.h"
#import "InfoView.h"
#import "SaveController.h"
#import "CustomImageView.h"
#import "FBConnect.h"
#import <MediaPlayer/MediaPlayer.h>

#import <MobiGirl/MGAd.h>

@interface CandlesController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, MPMediaPickerControllerDelegate, UIAlertViewDelegate> {

	MPMusicPlayerController *musicPlayer;
	Facebook *facebook;
	UIView *cameraView;
	CandlesView *candlesView;
	CGRect jarRect;
	float height;
	NSMutableArray *maskCoords;
	NSMutableArray *waxNames;
	WaxView *waxView;
	
	NSTimer *timer, *flameTimer;
	int waxNumber;
	
/// files	
	NSMutableArray *waxes, *jars, *addins, *fonts, *photos, *bedz, *colors, *flames, *photoCategoriesItems;
	NSMutableArray *addinsViews, *photosViews, *bedzViews, *wicksView;
	int currentSelectedAddins, currentSelectedPhotos, currentSelectedBedz;
	AVAudioPlayer *backgroundTrack, *pouringSound, *startLightingSound, *lightingSound, *saveSound, *smokeSound;
	
/// choose text	
	UITextField *textField;
	CustomLabel *currentLabel;
	NSArray *fontNames;
	
	int mode, categoriesMode;
	float val;

/// info
	InfoView *infoView;
	
/// image picker
	UIImagePickerController *imagePickerController;
	UIPopoverController *popover;
	
/// save state
	NSString *currentJarName;
	SaveController *sc;
								
	CGPoint currentWaxPoint;
	UIImage *meltImage;
	NSMutableArray *meltAnimationImages;
	int animationCounter, waxNumberForAnimation;
	int canGoDown;
	
	UIAlertView *backCandle;
	
	BOOL isFinishing, isSaving;
	float keepHeight;
	
	BOOL musicState;
	
	int _max_pouring;
    
    MGAd *ad;

}

@property (assign) BOOL musicState;
@property (nonatomic, retain) UIImage *meltImage;
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, retain) NSString *currentJarName;
@property (nonatomic, retain) NSArray *fontNames;
@property (assign) int mode;
@property (assign) AVAudioPlayer *backgroundTrack;
@property (nonatomic, retain) NSMutableArray *maskCoords, *photoCategoriesItems, *waxNames;
@property (nonatomic, retain) NSMutableArray *waxes, *jars, *addins, *addinsViews, *fonts, *photos, *photosViews, *bedz, *bedzViews, *colors, *flames, *wicksView, *meltAnimationImages;;

- (void) initWithImageName: (NSString*) name;
- (UIImage*) createMaskForImageFromCenterToImage: (NSString*) backImage withMask: (NSString*) maskName;
- (UILabel*) generateLabelWithFont: (NSString*) fontName;
@end
