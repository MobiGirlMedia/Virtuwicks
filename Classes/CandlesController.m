    //
//  CandlesController.m
//  Candles
//
//  Created by Sergey Kopanev on 2/1/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "CandlesController.h"
#import "LabelUnderImage.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
//#import <QuartzCore/CGColor.h>


#define default_wax_shift 20

@interface UIImage (TPAdditions)
- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path;
+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path;
@end


@implementation UIImage (TPAdditions)

- (id)initWithContentsOfResolutionIndependentFile:(NSString *)path {
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
        NSString *path2x = [[path stringByDeletingLastPathComponent] 
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@", 
                                                            [[path lastPathComponent] stringByDeletingPathExtension], 
                                                            [path pathExtension]]];
		
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path2x] ) {
//            return [UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]];
			
//			NSLog(@"load 2x image with name %@", path2x);
			
			 return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];
        }
    }
	
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path {
 //   return [[UIImage alloc] initWithContentsOfResolutionIndependentFile:path];
    return [[[UIImage alloc] initWithContentsOfResolutionIndependentFile:path] autorelease];
}

@end


@implementation CandlesController

@synthesize maskCoords, waxes, mode, jars, addins, addinsViews, fonts, fontNames, photos, photosViews, bedzViews, bedz, colors, flames, wicksView, photoCategoriesItems,
			currentJarName, musicPlayer, backgroundTrack, meltImage, waxNames, meltAnimationImages, musicState;

- (NSMutableArray*) remove2x: (NSArray*) f {
    NSMutableArray *a = [NSMutableArray array];
    for (NSString *s in f) {
        if (NSNotFound == [s rangeOfString:@"@2x"].location) {
            [a addObject:s];
        }
    }
    return a;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
//		facebook = [[Facebook alloc] initWithAppId:kFacebookAppId];
		facebook = [[Facebook alloc] init];
		self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
		if ([Utils runningUnderiPad]) {
			candlesView = [[CandlesView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			_max_pouring = 40;
		} else {
			candlesView = [[CandlesView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			_max_pouring = 25;
		}
		self.view = candlesView;
		[candlesView release];
		
		[candlesView.currentAction addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
		[candlesView.back addTarget:self action:@selector(backStep) forControlEvents:UIControlEventTouchUpInside];
		[candlesView.info addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
		[candlesView.backCategories addTarget:self action:@selector(backStepCategories) forControlEvents:UIControlEventTouchUpInside];
		[candlesView.save addTarget:self action:@selector(saveState) forControlEvents:UIControlEventTouchUpInside];
		[candlesView.wicks addTarget:self action:@selector(myWicks) forControlEvents:UIControlEventTouchUpInside];
		[candlesView.home addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
		candlesView.changeBackSelector = @selector(changeMasks);
		
		timer = nil;
		flameTimer = nil;
		waxView = nil;
		
#ifdef LITE
		self.fontNames = [NSArray arrayWithObjects:@"ArialMT", @"Arial-BoldMT", nil];
#else
		self.fontNames = [NSArray arrayWithObjects: @"Ribbon131 BT",
						  @"Agent Orange",  @"Batman Beat the hell Outta Me", @"Cheri", @"Fillmore",
						  @"KidTYPERuled", @"Kinkie", @"Pharmacy", @"What time is it?", @"Copperplate",
						  @"American Typewriter", @"Andes", @"Arruba", @"BellBottom.Laser", @"Big Caslon",
						  @"maru",
						  nil ];
#endif
		self.waxNames = [NSMutableArray array];
		self.waxes = [NSMutableArray array];
		self.jars = [NSMutableArray array];
		self.addins = [NSMutableArray array];
		self.photos = [NSMutableArray array];
		self.addinsViews = [NSMutableArray array];
		self.photosViews =  [NSMutableArray array];
		self.fonts = [NSMutableArray array];
		self.bedzViews = [NSMutableArray array];
		self.bedz = [NSMutableArray array];
		self.flames = [NSMutableArray array];
		self.colors = [NSMutableArray array];
		self.wicksView = [NSMutableArray array];
		self.photoCategoriesItems = [NSMutableArray array];
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *path = [NSString stringWithFormat:@"%@/%@/waxes_add", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
		NSArray *f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[waxes addObject:[s stringByDeletingPathExtension]];
		}
		
//		NSLog(@"p1");
		
#ifdef LITE
		NSRange r; r.location = 3;
		r.length = [waxes count] - r.location;
//		[waxes removeObjectsInRange:r];
#endif
		
		[self addWaxesToScrollView];
		waxNumber = 0;
		
/// add jars		
		path = [NSString stringWithFormat:@"%@/%@/jars", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
        NSLog(@"path=%@",path);
		f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[jars addObject:[s stringByDeletingPathExtension]];
		}
//		NSLog(@"p2");

        NSLog(@"length=%d  [jars count]=%d",r.length,[jars count]);
        
#ifdef LITE
		r.location = 1;
		r.length = [jars count] - r.location;
        
//		[jars removeObjectsInRange:r];
#endif
		
//		NSLog(@"p1");
		[self addJarsToScrollView];
/// add addins		
		path = [NSString stringWithFormat:@"%@/%@/addins", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
		f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[addins addObject:[s stringByDeletingPathExtension]];
		}
#ifdef LITE
		r.location = 4;
		r.length = [addins count] - r.location;
		[addins removeObjectsInRange:r];
#endif
		[self addAddinsToScrollView];
//		NSLog(@"p3");

/// add photos
		path = [NSString stringWithFormat:@"%@/%@/categories", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
		f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[photos addObject:[s stringByDeletingPathExtension]];
		}
		
#ifndef LITE
		int i = [photos indexOfObject:@"camera"];
		[photos exchangeObjectAtIndex:i withObjectAtIndex:0];
		
		[photos exchangeObjectAtIndex:0 withObjectAtIndex:0];
//		NSLog(@"p4");
#else
		[photos removeAllObjects];
		[photos addObject:@"more"];
		[photos addObject:@"celebration"];
//		[photos addObject:@"food"];
//		[photos addObject:@"patterns"];
#endif
		
		
		[self addPhotosToScrollView];
//		NSLog(@"p5");

/// add fonts and colorz
		[self addFontsToScrollView];
		path = [NSString stringWithFormat:@"%@/%@/colors", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
		f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[colors addObject:[s stringByDeletingPathExtension]];
		}
		
#ifdef LITE
		[colors removeAllObjects];
		[colors addObject:@"black"];
		[colors addObject:@"white"];
		[colors addObject:@"red"];
#endif
		
		
		[self addColorsToScrollView];
		
/// add bedazzle
		path = [NSString stringWithFormat:@"%@/%@/bedazzle", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
		f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[bedz addObject:[s stringByDeletingPathExtension]];
		}
		
#ifdef LITE
		r.location = 3;
		r.length = [bedz count] - r.location;
//		[bedz removeObjectsInRange:r];
#endif
		
		[self addBedazzlesToScrollView];
		
/// flames		
		path = [NSString stringWithFormat:@"%@/%@/flame", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];
		f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		for (NSString *s in f) {
			[flames addObject:[s stringByDeletingPathExtension]];
		}
//		NSLog(@"p6");

		
		NSString *sP;

		sP = [NSString stringWithFormat:@"%@/sounds/pouring.wav", [[NSBundle mainBundle] bundlePath]];
		pouringSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: sP]
																error: nil];
		pouringSound.numberOfLoops = -1;
		[pouringSound prepareToPlay];

		sP = [NSString stringWithFormat:@"%@/sounds/start_lighting.wav", [[NSBundle mainBundle] bundlePath]];
		startLightingSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: sP]
															  error: nil];
		[startLightingSound prepareToPlay];

		sP = [NSString stringWithFormat:@"%@/sounds/lighting.wav", [[NSBundle mainBundle] bundlePath]];
		lightingSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: sP]
															  error: nil];
		lightingSound.numberOfLoops = -1;
		[lightingSound prepareToPlay];
		
		
		sP = [NSString stringWithFormat:@"%@/sounds/save.wav", [[NSBundle mainBundle] bundlePath]];
		saveSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: sP]
															   error: nil];
		[saveSound prepareToPlay];
		
		sP = [NSString stringWithFormat:@"%@/sounds/smoke.wav", [[NSBundle mainBundle] bundlePath]];
		smokeSound = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: sP]
														   error: nil];
		[smokeSound prepareToPlay];
		
		UInt32 category = kAudioSessionCategory_AmbientSound;
		OSStatus a = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		
		[self initWithImageName: [jars objectAtIndex:0]];
		
		[candlesView.control addTarget:self action:@selector(flameFinsh) forControlEvents:UIControlEventTouchDown];

/// add targets to view
		candlesView.target = self;
		candlesView.addCategoriesItemsSelector = @selector(addCategoriesItems:);
		
/// create text field		
		textField = [[UITextField alloc] init];
		[candlesView addSubview:textField];
		textField.keyboardType = UIKeyboardTypeAlphabet;
		textField.returnKeyType = UIReturnKeyDone;
		textField.delegate = self;
		self.mode = state_choosejar;
//		self.mode = state_decorate;
		
		[[NSNotificationCenter defaultCenter] addObserver: self
												 selector: @selector(loadCandleAtPath:)
													 name: kLoadCandleNotificationKey
												   object: nil];
		isSaving = NO;
		musicState = YES;
    }
    
    //if (!yiPad) {
        ad = [[MGAd alloc] initForInterstitialWithSecret:kAdSecret orientation:UIInterfaceOrientationPortrait];
        [ad showAdsOnViewController:self];
    //}
    
    return self;
}

#pragma mark -
- (void) backToHome {
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) killImage {
	candlesView.wax.image = nil;
	candlesView.wax.alpha = 1;
}

#pragma mark save state
- (void) saveState {
    
    ad = [[MGAd alloc] initForInterstitialWithSecret:kAdSecret orientation:UIInterfaceOrientationPortrait];
    [ad showAdsOnViewController:self];
    
	candlesView.noTouch.hidden = NO;
//	NSLog(@"_______________");
//	if (isSaving) return;
//	NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!");
//	isSaving = YES;
	
	[saveSound play];
/*		{
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	v.backgroundColor = [UIColor whiteColor];
	[candlesView addSubview:v];
	[v release];
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	v.alpha = 0;
	[UIView setAnimationDelegate:v];
	[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
	[UIView commitAnimations];
	}
*/	
//	NSLog(@"sate1");
	/// generate current state
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	[d setObject:[NSString stringWithFormat:@"%d", mode] forKey:kCurrentStepKey];
	[d setObject:currentJarName forKey:kJarNameKey];
	if (state_choosewax <= mode && candlesView.wax.image) {
		[d setObject:candlesView.wax.image forKey:kWaxImageKey];
	}
//	NSLog(@"sate2");
	if (state_chooseaddins <= mode) {	/// addins
		NSMutableArray *a = [NSMutableArray array];
		for (CustomImageView *v in candlesView.waxView.subviews) {
			if (v.tag == _custom_view_tag) {
				NSMutableDictionary *dd = [NSMutableDictionary dictionary];
				[dd setObject:v.name forKey:kNameKey];
				[dd setObject:NSStringFromCGPoint(v.center) forKey:kCoordsKey];
				[a addObject:dd];			
			}
		}
		if ([a count]) {
			[d setObject:a forKey:kAddinsKey];
		}
	}
//	NSLog(@"sate3");
	
	if (state_addwick <= mode) {	/// wicks
		NSMutableArray *a = [NSMutableArray array];
		for (WickView *v in candlesView.wickView.subviews) {
			if (v.tag == _custom_view_tag) {
				NSMutableDictionary *dd = [NSMutableDictionary dictionary];
//				[dd setObject:v.name forKey:kNameKey];
				[dd setObject:NSStringFromCGPoint(v.center) forKey:kCoordsKey];
				[a addObject:dd];			
			}
		}
		if ([a count]) {
			[d setObject:a forKey:kWicksKey];
		}
	}
//	NSLog(@"sate4");

	if (state_decorate <= mode) {	/// decorate
		NSMutableArray *a = [NSMutableArray array];
		int numkey = 0;
		for (MovingImageView *v in candlesView.photosView.subviews) {
			if (v.tag == _custom_view_tag) {
				NSMutableDictionary *dd = [NSMutableDictionary dictionary];
				if (v.isPhoto) {
					[dd setObject:@"yes" forKey:kPhotoKey];
					[dd setObject:[NSString stringWithFormat:@"%04d", numkey++] forKey:kNameKey];
				} else {
					[dd setObject:v.name forKey:kNameKey];
				}
				[dd setObject:v.image forKey:kImageKey];
				[dd setObject:NSStringFromCGAffineTransform(v.transform) forKey:kTransformKey];
				v.transform = CGAffineTransformIdentity;
				[dd setObject:NSStringFromCGRect(v.frame) forKey:kRectKey];
				v.transform = CGAffineTransformFromString([dd objectForKey:kTransformKey]);
				[a addObject:dd];
			}
		}
		if ([a count]) {
//			NSLog(@"saved photos %@", a);
			[d setObject:a forKey:kDecorateKey];
		}
	}
//	NSLog(@"sate5");

	if (state_addtext <= mode) {	/// texts
		NSMutableArray *a = [NSMutableArray array];
		for (CustomLabel *v in candlesView.titlesView.subviews) {
			if (v.tag == _custom_view_tag) {
				NSMutableDictionary *dd = [NSMutableDictionary dictionary];
				[dd setObject:v.text forKey:kTextKey];
				[dd setObject:v.font.fontName forKey:kFontNameKey];
				[dd setObject:[NSString stringWithFormat:@"%f", v.scaleCoef]  forKey:kScaleKey];
				[dd setObject:NSStringFromCGPoint(v.center) forKey:kCoordsKey];
				[dd setObject:v.colorName forKey:kFontColorKey];
				[a addObject:dd];			
			}
		}
		if ([a count]) {
			[d setObject:a forKey:kTextKey];
		}
	}
//	NSLog(@"sate6");

	if (state_addbed <= mode) {	/// bedazzles
		NSMutableArray *a = [NSMutableArray array];
		for (CustomImageView *v in candlesView.bedazzleView.subviews) {
			if (v.tag == _custom_view_tag) {
				NSMutableDictionary *dd = [NSMutableDictionary dictionary];
				[dd setObject:v.name forKey:kNameKey];
				[dd setObject:NSStringFromCGPoint(v.center) forKey:kCoordsKey];
				[a addObject:dd];			
			}
		}
		if ([a count]) {
			[d setObject:a forKey:kBedazzleKey];
		}
	}
//	NSLog(@"sate7");
//	NSLog(@"waxNames %@", waxNames);
	[d setObject:waxNames forKey:kWaxNamesKey];
//	NSLog(@"sate8");

	/// generate an image
	
	[self setViews:NO];
//	NSLog(@"sate9");
	candlesView.backgroundColor = [UIColor clearColor];
	
	float sf = 1.0;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			sf = 2.0;
		}
	}
	
	int h = 150;
	
	if (![Utils runningUnderiPad]) {
		h = 150;
	}
	
	CGRect r = CGRectMake(jarRect.origin.x*sf, (jarRect.origin.y-h)*sf, jarRect.size.width*sf, (jarRect.size.height+h)*sf);	
	
//	NSLog(@"rect %@", NSStringFromCGRect(r));
	
	candlesView.myLayer.alpha = 0;
	
	candlesView.wax.alpha = 1;
	candlesView.waxView.alpha = 1;
	candlesView.jarsBack.alpha = 1;
	candlesView.backgroundColor = [UIColor clearColor];

//	candlesView.contentScaleFactor = 2;
//	NSLog(@"frame %@, %d", NSStringFromCGRect(candlesView.frame), (int)candlesView.contentScaleFactor);
	
	UIImage *i = [ImageUtils getImageFromView:candlesView];
	
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			i = [UIImage imageWithCGImage:i.CGImage scale:1.0 orientation:i.imageOrientation];
		}
	}
	
//	NSLog(@"image size %@ %f", NSStringFromCGSize(i.size), i.scale);
	
	
	{
//		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(i)];
//		[imageData writeToFile:[NSString stringWithFormat:@"%@/topView.png", [Utils documentsDirectory]] atomically:YES];
	}
	
	UIView *vv;

		
	vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, candlesView.frame.size.width*sf, candlesView.frame.size.height*sf)];
	
//	NSLog(@"vv frame %@, scale %f", NSStringFromCGRect(vv.frame), vv.contentScaleFactor);
	
	
	vv.backgroundColor = [UIColor whiteColor];

	UIImageView *iv = [[UIImageView alloc] init];

	NSString *path_img = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];

	UIImage *ivv = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/jars_add/%@_top_maski.png", path_img, currentJarName]];
//	[ImageUtils loadNativeImage:];
	iv.image = ivv;
		

	if (sf == 2.0) {
		iv.frame = CGRectMake(jarRect.origin.x*sf, jarRect.origin.y*sf, ivv.size.width*sf, ivv.size.height*sf);
	} else {
		iv.frame = CGRectMake(jarRect.origin.x, jarRect.origin.y, ivv.size.width, ivv.size.height);
	}
//	NSLog(@"iv frame %@, scale %f", NSStringFromCGRect(iv.frame), iv.contentScaleFactor);
	

	UIImageView *iv1 = [[UIImageView alloc] init];
	UIImage *ivv1 = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/jars_add/%@_maski.png", path_img, currentJarName]];
	iv1.image = ivv1;
	iv1.frame = CGRectMake(jarRect.origin.x, jarRect.origin.y+ivv.size.height, ivv1.size.width, ivv1.size.height-ivv.size.height);;
	
	if (sf == 2.0) {
		iv1.frame = CGRectMake(jarRect.origin.x*sf, jarRect.origin.y*sf, jarRect.size.width*sf, jarRect.size.height*sf);;
	} else {
		iv1.frame = jarRect;
	}
	
//	NSLog(@"iv frame %@, scale %f", NSStringFromCGRect(iv.frame), iv.contentScaleFactor);
	
	[vv addSubview:iv1];
	[vv addSubview:iv];
	
	[iv release];
	[iv1 release];
	
//	NSLog(@"%@, %@", iv, iv1);
	
//	NSLog(@"sate10");
	
//	NSLog(@"scale %f", i.scale);
	
	{
//		NSLog(@"vv frame %@, scale %f", NSStringFromCGRect(vv.frame), vv.contentScaleFactor);

		UIImage *imag = [ImageUtils getIndependImageFromView:vv];
//		NSLog(@"imag %@, %f", NSStringFromCGSize(imag.size), imag.scale);
		
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			if ([[UIScreen mainScreen] scale] == 2.0) {
//				i = [UIImage imageWithCGImage:i.CGImage scale:1.0 orientation:i.imageOrientation];
//			}
//		}
		
		
		i = [ImageUtils maskImage:i withMask:imag];
	}

//	NSLog(@"sate101");
	
	
	candlesView.wax.alpha = 0;
	candlesView.waxView.alpha = 0;

	
	UIImage *cv = [ImageUtils getImageFromView:candlesView];
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			cv = [UIImage imageWithCGImage:cv.CGImage scale:1.0 orientation:cv.imageOrientation];
		}
	}
	
//	NSLog(@"cv frame %@, scale %f", NSStringFromCGSize(cv.size), cv.scale);
//	NSLog(@"i %@, %f", NSStringFromCGSize(i.size), i.scale);

	
	i = [ImageUtils putImage:i atPoint:CGPointMake(0, 0) onImage:cv];

	
	
	
//	NSLog(@"sate102");
	
	candlesView.jarsBack.alpha = 0;

	candlesView.wickView.alpha = 1;
	candlesView.jar.alpha = 1;

	
	cv = [ImageUtils getImageFromView:candlesView];
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			cv = [UIImage imageWithCGImage:cv.CGImage scale:1.0 orientation:cv.imageOrientation];
		}
	}
	
	i = [ImageUtils putImage:cv atPoint:CGPointMake(0, 0) onImage:i];

	
	//	NSLog(@"sate103");
	candlesView.wickView.alpha = 0;
	candlesView.jar.alpha = 0;

	candlesView.bedazzleView.alpha = 1;
	candlesView.titlesView.alpha = 1;
	candlesView.photosView.alpha = 1;

	[iv removeFromSuperview];
//	NSLog(@"sate104");
	
	cv = [ImageUtils getImageFromView:candlesView];
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			cv = [UIImage imageWithCGImage:cv.CGImage scale:1.0 orientation:cv.imageOrientation];
		}
	}
	
	UIImage *vvi = [ImageUtils getIndependImageFromView:vv];
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			vvi = [UIImage imageWithCGImage:vvi.CGImage scale:1.0 orientation:vvi.imageOrientation];
		}
	}
	
	
//	NSLog(@"heranklo");
	UIImage *topView = [ImageUtils maskImage:cv withMask:vvi];
//	NSLog(@"sate105");
	
	[iv1 removeFromSuperview];
	[vv release];
//	NSLog(@"sate106");
	
//	NSLog(@"cv %@, %f", NSStringFromCGSize(cv.size), cv.scale);


	
	
	i = [ImageUtils putImage:topView atPoint:CGPointMake(0, 0) onImage:i];
//	NSLog(@"sate107");

	
	{
//		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([ImageUtils imageByCropping:i toRect:r])];
//		[imageData writeToFile:[NSString stringWithFormat:@"%@/res.png", [Utils documentsDirectory]] atomically:YES];
//		NSLog(@"____________");
		
	}
	
	[d setObject:[ImageUtils imageByCropping:i toRect:r] forKey:kCandleImageKey];	
	
//	NSLog(@"sate11");
	
	[self setViews:YES];
//	NSLog(@"sate12");
	
	[d setObject:[NSString stringWithFormat:@"%f", height] forKey:kHeightKey];
	
/// generate folder name
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"YYYY_MM_dd_HH_mm_ss_ms"];
	NSDate *date = [NSDate date];
	NSString *folder = [df stringFromDate:date];
	[df release];
	
	NSString *path = [NSString stringWithFormat:@"%@/candles/%@", [Utils documentsDirectory], folder];
//	NSLog(@"folder %@", path);
	
	NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:path]) {
		[fm createDirectoryAtPath: path withIntermediateDirectories:YES attributes:nil error:NULL];;
	}
	
//	NSLog(@"sate13");

	
	/// save preview to disk
	NSString *imgPath;
	UIImage *img;
	{
	/// save wax image
	imgPath = [NSString stringWithFormat:@"%@/wax", path];
	img = [d objectForKey:kWaxImageKey];
	if (img) {
//		NSLog(@"sf %f", img.scale);
//		if (sf == 2.0) {
//			img = [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation:img.imageOrientation];
//		}
		
		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
		[imageData writeToFile:imgPath atomically:YES];
		[d removeObjectForKey:kWaxImageKey];
	}
	}
//	NSLog(@"sate14");
	
	{
		float sf = [[UIScreen mainScreen] scale];
		imgPath = [NSString stringWithFormat:@"%@/image", path];
		img = [d objectForKey:kCandleImageKey];
		if (img) {
			NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
//			if (sf == 2) {
//				imgPath = [NSString stringWithFormat:@"%@@2x", imgPath];
//			}
			[imageData writeToFile:imgPath atomically:YES];
			[d removeObjectForKey:kCandleImageKey];
			
			imgPath = [NSString stringWithFormat:@"%@/preview", path];
			
			if ([Utils runningUnderiPad]) {
				if (img.size.width < img.size.height) {
					imageData = [NSData dataWithData:UIImagePNGRepresentation([ImageUtils imageWithImage:img scaledToSize:CGSizeMake(230*img.size.width/img.size.height, 230)])];
				} else {
					imageData = [NSData dataWithData:UIImagePNGRepresentation([ImageUtils imageWithImage:img scaledToSize:CGSizeMake(230, 230*img.size.height/img.size.width)])];
				}
			} else {
				if (img.size.width < img.size.height) {
					imageData = [NSData dataWithData:UIImagePNGRepresentation([ImageUtils imageWithImage:img scaledToSize:CGSizeMake(sf*95*img.size.width/img.size.height, sf*95)])];
				} else {
					imageData = [NSData dataWithData:UIImagePNGRepresentation([ImageUtils imageWithImage:img scaledToSize:CGSizeMake(sf*95, sf*95*img.size.height/img.size.width)])];
				}
			}
//			if (sf == 2) {
//				imgPath = [NSString stringWithFormat:@"%@@2x", imgPath];
//			}
			[imageData writeToFile:imgPath atomically:YES];
			
		}
	}
	
	
	
	
	NSLog(@"sate15");
	/// save photos if needed
	NSMutableArray *a = [d objectForKey:kDecorateKey];
	for (NSMutableDictionary *dd in a) {
		NSLog(@"write %@", dd);
		if ([dd objectForKey:kPhotoKey]) {	/// save image
			imgPath = [NSString stringWithFormat:@"%@/%@", path, [dd objectForKey:kNameKey]];
			img = [dd objectForKey:kImageKey];
			NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
			[imageData writeToFile:imgPath atomically:YES];
		}
		[dd removeObjectForKey:kImageKey];
	}
//	NSLog(@"sate16");
	
//	NSLog(@"dict before save %@", d);
	[d writeToFile:[NSString stringWithFormat:@"%@/candle", path] atomically:YES];
	
//	NSLog(@"sate17");


//	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(canTouch) userInfo:nil repeats:NO];
	candlesView.noTouch.hidden = YES;

	//	isSaving = NO;
}

- (void) setViews: (BOOL) s {
	candlesView.mask.alpha = s ? 1 : 0;
	candlesView.topMask.alpha = s ? 1 : 0;
	candlesView.barView.alpha = s ? 1 : 0;
	candlesView.wickView.alpha = s ? 1 : 0;
	candlesView.photosView.alpha = s ? 1 : 0;
	candlesView.titlesView.alpha = s ? 1 : 0;
	candlesView.bedazzleView.alpha = s ? 1 : 0;
	candlesView.jar.alpha = s ? 1 : 0;
	candlesView.home.alpha = s ? 1 : 0;
	candlesView.info.alpha = s ? 1 : 0;
	candlesView.wicks.alpha = s ? 1 : 0;
	candlesView.control.hidden = s;
	candlesView.back.alpha = s ? 1 : 0;
	candlesView.logo.alpha = s ? 1 : 0;
	candlesView.currentAction.alpha = s ? 1 : 0;
	candlesView.save.alpha = s ? 1 : 0;
	candlesView.background.alpha = s ? 1 : 0;
	candlesView.blackMask.alpha = s ? 1 : 0;
	candlesView.blackMaskTop.alpha = s ? 1 : 0;
	candlesView.wax.alpha = s ? 1 : 0;
	candlesView.waxView.alpha = s ? 1 : 0;
	candlesView.wickView.alpha = s ? 1 : 0;
	candlesView.jarsBack.alpha = s ? 1 : 0;
	candlesView.colorBarView.alpha = s ? 1: 0;
	for (WickView *v in wicksView) {
		v.flame.alpha = s ? 0 : 1;
	}
}

- (void) myWicks {
	sc = [[SaveController alloc] init];
//	sc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//	[sc addObjectToSave:d];
	[sc getSavedObjects];
	
	
	if ([sc.candleObjects count]) {
		sc.nav = self.navigationController;
		sc.facebook = facebook;
		sc.target = self;
		sc.logintToFaceSelector = @selector(loginToFace:);
		[self.navigationController pushViewController: sc animated:NO];
//		[self.navigationController presentModalViewController:sc animated:YES];
	} else {
		UIAlertView * a = [[UIAlertView alloc] initWithTitle: @"ooops !"
													 message: @"you have not saved your virtuwick. do you want to?" 
													delegate: self 
										   cancelButtonTitle: @"OK" 
										   otherButtonTitles: nil]; 
		
		[a show]; 
		[a release]; 
	}
	[sc release];
}

- (void) loadCandleAtPath: (NSNotification*) n {
	
//	[self.navigationController popViewControllerAnimated:YES];
	
	
	/// lading candle
	NSDictionary *dd = n.object;
	NSString *p = @"";
	NSMutableDictionary *d;
	if ([dd objectForKey:@"loadFromDict"]) {
		p = [dd objectForKey:kNameKey];
		d = dd;
	} else {
		p = [dd objectForKey:kNameKey];
		d = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/candles/%@/candle", [Utils documentsDirectory], p]];

	}
	
	
//	NSLog(@"dicr %@", d);
	
	/// set jar
	if ([d objectForKey:kJarNameKey]) {
		[self initWithImageName:[d objectForKey:kJarNameKey]];
	} else {
		NSLog(@"ERRROR !");
		return;
	}
	
	if ([d objectForKey:kCurrentStepKey]) {
		mode = [[d objectForKey:kCurrentStepKey] intValue];
	} else {
		mode = state_choosejar;
	}
	
	self.waxNames = [d objectForKey:kWaxNamesKey];
	if (!waxNames) {
		self.waxNames = [NSMutableArray array];
	}
	
	categoriesMode = cat_state_default;
	currentSelectedAddins = -1;
	currentSelectedBedz = -1;
	currentSelectedPhotos = -1;
	
	if (mode >= state_choosewax) {
		candlesView.wax.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/candles/%@/wax", [Utils documentsDirectory], p]];
	} else {
		candlesView.wax.image = nil;
	}
	
/// addins
	for (UIView *v in candlesView.waxView.subviews) {
		[v removeFromSuperview];
	}

	
//	NSLog(@"addins %@", [d objectForKey:kAddinsKey]);
	if ([d objectForKey:kAddinsKey]) {
		NSMutableArray *a = [d objectForKey:kAddinsKey];
		for (NSMutableDictionary *dd in a) {
			UIImage *i = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"addins/%@.png", [dd objectForKey:kNameKey]]];
			CustomImageView *v = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 0, i.size.width, i.size.height)];
			v.image = i;
			v.name = [dd objectForKey:kNameKey];
			v.tag = _custom_view_tag;
			[candlesView.waxView addSubview:v];
			[v release];
			v.center = CGPointFromString([dd objectForKey:kCoordsKey]);
		}
	}
	
/// wicks	
	for (UIView *v in wicksView) {
		[v removeFromSuperview];
	}
	[wicksView removeAllObjects];
	NSMutableArray *a = [d objectForKey:kWicksKey];
	for (NSMutableDictionary *dd in a) {
		UIImage *i = [ImageUtils loadNativeImage:@"wick.png"];
		WickView *v = [[WickView alloc] initWithFrame:CGRectMake(0, 0, i.size.width, i.size.height)];
		v.image = i;
		v.currentFlameSprite =rand()%[flames count];
		[v showFlameImage: [NSString stringWithFormat:@"flame/%@.png", [flames objectAtIndex:v.currentFlameSprite]]];
		[candlesView.wickView addSubview:v];
		v.tag = _custom_view_tag;
		[v release];
		[wicksView addObject:v];
		CGPoint p = CGPointFromString([dd objectForKey:kCoordsKey]);
		v.center = p;
	}
	

	
/// decorate
	for (UIView *v in candlesView.photosView.subviews) {
		[v removeFromSuperview];
	}
	if ([d objectForKey:kDecorateKey]) {
		NSMutableArray *a = [d objectForKey:kDecorateKey];
		for (NSMutableDictionary *dd in a) {
//			NSLog(@"dd %@", dd);
			UIImage *i;
			if ([dd objectForKey:kPhotoKey]) {
				i = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/candles/%@/%@", [Utils documentsDirectory], p, [dd objectForKey:kNameKey]]];
			} else {
				NSString *name = [NSString stringWithFormat:@"categories_add/%@.png", [dd objectForKey:kNameKey]];
				i = [ImageUtils loadNativeImage:name];
			}
			MovingImageView *v = [[MovingImageView alloc] initWithFrame: CGRectFromString([dd objectForKey:kRectKey])];
			v.image = i;
			v.name = [dd objectForKey:kNameKey];
			v.isPhoto = [dd objectForKey:kPhotoKey] ? YES : NO;
			v.tag = _custom_view_tag;
			[candlesView.photosView addSubview:v];
			v.transform = CGAffineTransformFromString([dd objectForKey:kTransformKey]);
			
			[v release];
		}		
	}
	for (UIView *v in candlesView.titlesView.subviews) {
		[v removeFromSuperview];
	}
	if ([d objectForKey:kTextKey]) {
		NSMutableArray *a = [d objectForKey:kTextKey];
		for (NSMutableDictionary *dd in a) {
			CustomLabel *cl = [[CustomLabel alloc] initWithFrame:CGRectZero];
			[candlesView.titlesView addSubview:cl];
			textField.text = @"";
			[cl release];
			cl.font = [UIFont fontWithName:[dd objectForKey:kFontNameKey] size:_default_point_size*[[dd objectForKey:kScaleKey] floatValue]];
			cl.tag = _custom_view_tag;
			cl.target = self;
			cl.text = [dd objectForKey:kTextKey];
			currentLabel = cl;
			UIControl *c = [[UIControl alloc] init];
			c.tag = [colors indexOfObject:[dd objectForKey:kFontColorKey]]+1;
			[self chooseTextColor:c];
			[c release];
			cl.selector = @selector(setCurrentLabel:);
			cl.center = CGPointFromString([dd objectForKey:kCoordsKey]);
			currentLabel = nil;
		}
	}
	

	/// bedazzles
	for (UIView *v in candlesView.bedazzleView.subviews) {
		[v removeFromSuperview];
	}
	
//	NSLog(@"bedan");

	if ([d objectForKey:kBedazzleKey]) {
		NSMutableArray *a = [d objectForKey:kBedazzleKey];
		for (NSMutableDictionary *dd in a) {
			UIImage *i = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"bedazzle/%@.png", [dd objectForKey:kNameKey]]];
			MovingImageView *v = [[MovingImageView alloc] initWithFrame:CGRectMake(0, 0, i.size.width, i.size.height)];
			v.image = i;
			v.name = [dd objectForKey:kNameKey];
			v.tag = _custom_view_tag;
			v.isPhoto = NO;
			[candlesView.bedazzleView addSubview:v];
			[v release];
			v.center = CGPointFromString([dd objectForKey:kCoordsKey]);
		}
	}
//	NSLog(@"bedan2");
	
	
	self.mode = mode;
	height = [[d objectForKey:kHeightKey] floatValue];

//	[sc hide];

	
	
//	NSLog(@"%d %d %d", (BOOL)[dd objectForKey:kBurnKey], (BOOL)mode >= state_addwick, (BOOL)[wicksView count]);
	
	if ([dd objectForKey:kBurnKey] && mode >= state_addwick && [wicksView count]) {
		self.mode = state_flameit;
	}
	
    //if (!yiPad) {
        ad = [[MGAd alloc] initForInterstitialWithSecret:kAdSecret orientation:UIInterfaceOrientationPortrait];
        [ad showAdsOnViewController:self];
    //}
}

#pragma mark image picker delegate
- (void)setupImagePicker {
	UIImagePickerController* picker = [[UIImagePickerController alloc] init]; 
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
	picker.delegate = self; 
	
	popover = [[UIPopoverController alloc] initWithContentViewController:picker];
//	self.popoverController = popover;          
	popover.delegate = self;
	CGRect f = cameraView.frame;
	CGRect r = CGRectMake(f.origin.x-20, f.origin.y-75
						  , f.size.width, f.size.height);
//	((UIView*)[photosViews objectAtIndex:0]).backgroundColor = [UIColor redColor];
//	popover.popoverContentSize = CGSizeMake(400, 800);
	[popover presentPopoverFromRect:r
							 inView:cameraView
		   permittedArrowDirections:UIPopoverArrowDirectionAny
						   animated:YES];
	[picker release];
	picker.allowsEditing = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//	NSLog(@"info %@", info);
	
	MovingImageView *v = [[MovingImageView alloc] initWithFrame:[Utils runningUnderiPad]?CGRectMake(0, 0, 250, 250):CGRectMake(0, 0, 150, 150) ];
	v.image = [info valueForKey:UIImagePickerControllerEditedImage];
	[candlesView.photosView addSubview:v];
	v.isPhoto = YES;
	[v release];
	v.tag = _custom_view_tag;
	v.center = CGPointMake(candlesView.jar.center.x - jarRect.origin.x, candlesView.jar.center.y - jarRect.origin.y);
	
	if ([Utils runningUnderiPad] ) {
		[popover dismissPopoverAnimated:YES];
	} else {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	if ([Utils runningUnderiPad] ) {
		[popover dismissPopoverAnimated:YES];
	} else {
		[self.navigationController dismissModalViewControllerAnimated:YES];
	}
	
//	[popover dismissPopoverAnimated:YES];
	NSLog(@"cancel");
//	[self dissapear];
}

#pragma mark Music managment
- (void) playOrPause: (BOOL) state {
#ifdef _developer_version
	return;
#endif
	NSLog(@"back %@", backgroundTrack);
	
	musicState = state;
	if (state) {
		if (backgroundTrack) {
			[backgroundTrack play];
		} else {
			[musicPlayer play];
		}
	} else {
		if (backgroundTrack) {
			[backgroundTrack pause];
		} else {
			[musicPlayer pause];
		}
	};
}

- (void) showMediaPicker {
	MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = NO; // this is the default   
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}

// Media picker delegate methods
- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	// We need to dismiss the picker
	[self dismissModalViewControllerAnimated:YES];
	
	// Assign the selected item(s) to the music player and start playback.
	[backgroundTrack stop];
	self.backgroundTrack = nil;
	
	NSLog(@"STOP MUSIC ! NIL !");
	
	[self.musicPlayer stop];
	[self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
	[self.musicPlayer play];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    // User did not select anything
    // We need to dismiss the picker
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Buttonsactions

- (void) showInfo {
	if ([Utils runningUnderiPad]) {
		infoView = [[InfoView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	} else {
		infoView = [[InfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	}
	[candlesView addSubview:infoView];
#ifndef _developer_version
	if (backgroundTrack) {
		infoView.slider.isStateOn = backgroundTrack.playing;
	} else {
		infoView.slider.isStateOn = musicPlayer.playbackState == MPMoviePlaybackStatePlaying;
	}
#endif
	
	[infoView.slider switchState:nil];
	infoView.slider.target = self;
	infoView.slider.selector = @selector(playOrPause:);
	[infoView.chooseMusic addTarget:self action:@selector(showMediaPicker) forControlEvents:UIControlEventTouchUpInside];
	
	
	infoView.alpha = 0;
	[infoView release];
	[UIView beginAnimations:nil context:0];
	[UIView setAnimationDuration:0.5];
	infoView.alpha = 1;
	[UIView commitAnimations];
}


#pragma mark steps navigation
- (void) backStep {
	float h;
	switch (mode) {
		case state_choosewax:
			self.mode = state_choosejar;
			[UIView beginAnimations:nil context:0];
			[UIView setAnimationDuration:0.5];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(killImage)];
			candlesView.wax.alpha = 0;
			[UIView commitAnimations];
			break;
		case state_chooseaddins:
			for (UIView *v in candlesView.waxView.subviews) {
				[UIView beginAnimations:nil context:0];
				[UIView setAnimationDuration:0.5];
				v.alpha = 0;
				[UIView setAnimationDelegate:v];
				[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
				[UIView commitAnimations];
			}
			h = height;
			self.mode = state_choosewax;
			height = h;
			break;
		case state_addwick:
			for (UIView *v in wicksView) {
				[UIView beginAnimations:nil context:0];
				[UIView setAnimationDuration:0.5];
				v.alpha = 0;
				[UIView setAnimationDelegate:v];
				[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
				[UIView commitAnimations];
			}
			[wicksView removeAllObjects];
			self.mode = state_chooseaddins;
			break;
		case state_decorate:
			for (UIView *v in candlesView.photosView.subviews) {
				[UIView beginAnimations:nil context:0];
				[UIView setAnimationDuration:0.5];
				v.alpha = 0;
				[UIView setAnimationDelegate:v];
				[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
				[UIView commitAnimations];
			}
			self.mode = state_addwick;
			break;
		case state_addtext:
			for (UIView *v in candlesView.titlesView.subviews) {
				[UIView beginAnimations:nil context:0];
				[UIView setAnimationDuration:0.5];
				v.alpha = 0;
				[UIView setAnimationDelegate:v];
				[UIView setAnimationDidStopSelector:@selector(removeMe)];
				[UIView commitAnimations];
			}
			self.mode = state_decorate;
		break;
		case state_addbed:
			for (UIView *v in candlesView.bedazzleView.subviews) {
				[UIView beginAnimations:nil context:0];
				[UIView setAnimationDuration:0.5];
				v.alpha = 0;
				[UIView setAnimationDelegate:v];
				[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
				[UIView commitAnimations];
			}
			self.mode = state_addtext;
			break;
		case state_flameit:
			for (WickView *v in wicksView) {
				[UIView beginAnimations:nil context:0];
				[UIView setAnimationDuration:0.5];
				v.flame.alpha = 0;
				[UIView commitAnimations];
			}
			self.mode = state_addbed;
			break;
			
	}
}

- (void) nextStep {
	if (!candlesView.barItemsView.userInteractionEnabled) return;
	switch (mode) {
		case state_choosejar:
			self.mode = state_choosewax;
			break;
		case state_choosewax:
			self.mode = state_chooseaddins;
			break;
		case state_chooseaddins:
			self.mode = state_addwick;
			break;
		case state_addwick:
			self.mode = state_decorate;
			break;
		case state_decorate:
			self.mode = state_addtext;
			break;
		case state_addtext:
			self.mode = state_addbed;
			break;
		case state_addbed:
			self.mode = state_flameit;
			break;
	}
}


- (void) setMode:(int) m {
	if (m == state_decorate && !candlesView.wickView.subviews.count) {
		UIAlertView * a = [[UIAlertView alloc] initWithTitle: nil
													 message: @"Whoops! You forgot to add a wick!" 
													delegate: self 
										   cancelButtonTitle: @"OK"
										   otherButtonTitles: nil]; 
		
		[a show]; 
		[a release]; 
		return;
	}
	
	mode = m;
	[candlesView.currentAction setTitleColor:[UIColor colorWithRed:0.85 green:0.945 blue:0.506 alpha:1] forState:UIControlStateHighlighted];
	[candlesView.currentAction setTitleColor:[UIColor colorWithRed:0.702 green:0.031 blue:0.725 alpha:1] forState:UIControlStateNormal];
	
	if (state_addtext != mode) {	///hide keyboard
		[textField resignFirstResponder];
	}
	currentLabel = nil;
//	candlesView.currentAction.hidden = mode==state_choosejar;
	
	switch (mode) {
		case state_choosejar:
			[waxNames removeAllObjects];
			[candlesView showItems:state_choosejar];
			[candlesView.currentAction setTitle:kChooseJar forState:UIControlStateNormal];
			break;
		case state_choosewax:
			[candlesView showItems:state_choosewax];
			[candlesView.currentAction setTitle:kChooseWax forState:UIControlStateNormal];
			height = default_wax_shift;
			currentSelectedAddins = -1;
			break;
		case state_chooseaddins:
			[candlesView showItems:state_chooseaddins];
			[candlesView.currentAction setTitle:kChooseAddins forState:UIControlStateNormal];
			break;
		case state_addwick:
		{
			static BOOL isShowAlert = NO;
			
			if (!isShowAlert) {
				UIAlertView * a = [[UIAlertView alloc] initWithTitle: @"tap to add my wick"
															 message: nil 
															delegate: self 
												   cancelButtonTitle: @"OK"
												   otherButtonTitles:  nil]; 
				[a show]; 
				[a release];
				isShowAlert = YES;
			}
			
		}
			[candlesView showItems:state_addwick];
			[candlesView.currentAction setTitle:kChooseWick forState:UIControlStateNormal];
			currentSelectedPhotos = -1;
			break;
		case state_decorate:
			categoriesMode = cat_state_default;
			[candlesView showItems:state_decorate];
			[candlesView.currentAction setTitle:kChooseDecorate forState:UIControlStateNormal];
			break;
		case state_addtext:
			[textField becomeFirstResponder];
			[candlesView showItems:state_addtext];
			[candlesView.currentAction setTitle:kChooseText forState:UIControlStateNormal];
		{
			CustomLabel *cl = [[CustomLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
			[candlesView.titlesView addSubview:cl];
//			[self.view addSubview:cl];
			cl.font = [UIFont fontWithName:[fontNames objectAtIndex:0] size:cl.font.pointSize];

			textField.text = @"";
			[cl release];
			cl.tag = _custom_view_tag;
			cl.target = self;
			cl.selector = @selector(setCurrentLabel:);
			cl.center = CGPointMake(candlesView.titlesView.frame.size.width/2, candlesView.titlesView.frame.size.height/2);
			currentLabel = cl;
		}
			currentSelectedBedz = -1;
			break;
		case state_addbed:
			for (CustomLabel *v in candlesView.titlesView.subviews) {
				[v setBackground:NO];
			}			
			[candlesView showItems:state_addbed];
			[candlesView.currentAction setTitle:kChooseBedazzle forState:UIControlStateNormal];
			break;
		case state_flameit:
		{
			BOOL s = musicState;
			[self playOrPause:NO];
			musicState = s;
		}
			
//			NSLog(@"waxView %@ %f", NSStringFromCGSize([ImageUtils getImageFromView:candlesView.waxView].size), [ImageUtils getImageFromView:candlesView.waxView].scale);
//			NSLog(@"wax %@ %f", NSStringFromCGSize(candlesView.wax.image.size), candlesView.wax.image.scale);
			for (CustomLabel *v in candlesView.titlesView.subviews) {
				[v setBackground:NO];
			}			
			
			UIImage *wv = [UIImage imageWithCGImage:[ImageUtils getImageFromView:candlesView.waxView].CGImage scale:1.0 orientation:UIImageOrientationUp];
			UIImage *waxx = [UIImage imageWithCGImage:candlesView.wax.image.CGImage scale:1.0 orientation:UIImageOrientationUp];
			self.meltImage = [ImageUtils putImage:wv atPoint:CGPointMake(0, 0) onImage:waxx];
			
//			self.meltImage = [ImageUtils putImage:[ImageUtils getImageFromView:candlesView.waxView] atPoint:CGPointMake(0, 0) onImage:candlesView.wax.image];
//			NSLog(@"%@", candlesView.waxView);
			
//			NSLog(@"%@ %f", NSStringFromCGSize(meltImage.size), meltImage.scale);
			if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
				if ([[UIScreen mainScreen] scale] == 2.0) {
					self.meltImage = [UIImage imageWithCGImage:meltImage.CGImage scale:2.0 orientation:meltImage.imageOrientation];
				}
			}
//			NSLog(@"%@ %f", NSStringFromCGSize(meltImage.size), meltImage.scale);
			
			
//			NSString *imgPath = [NSString stringWithFormat:@"%@/img", [Utils documentsDirectory]];
//			NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([ImageUtils getImageFromView:candlesView.waxView])];
//			[imageData writeToFile:imgPath atomically:YES];

//			[self startFlameTimer];
			[self startFlameTimer];
//			NSLog(@"____");
			
			isFinishing = YES;
			
			[candlesView showItems:state_flameit];
			[candlesView.currentAction setTitle:@"" forState:UIControlStateNormal];

			
			[UIView beginAnimations:nil context:0];
			[UIView setAnimationDuration:1.0];
			for (WickView *v in wicksView) {
				v.flame.alpha = 1;
			}
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(canFinishFlame)];
			[UIView commitAnimations];
			
//			[self canFinishFlame];
			
			break;
	};
}

- (void) canFinishFlame {
	flameTimer = [NSTimer scheduledTimerWithTimeInterval:1/24.0 target:self selector:@selector(flameRender) userInfo:nil repeats:YES];

	isFinishing = NO;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 1:
			[self backToHome];
			return;
	}
	

}

- (void) playTrackNow {
	NSLog(@"playnow %d", (int) musicState);
	[self playOrPause:musicState];
}

- (void) flameFinsh {
	
//	NSLog(@"flame finish");
	
	if (isFinishing) return;
	
	[lightingSound stop];
	[smokeSound play];
	isFinishing = YES;
	
/*	if ([waxNames count]) {
		UIImage *i = [ImageUtils generateImageWithSize:CGSizeMake(jarRect.size.width, jarRect.size.height)];
		UIImage *wax = candlesView.meltView.image;//[ImageUtils imageByCropping:candlesView.meltView.image toRect:CGRectMake(0, jarRect.size.height-(int)height, jarRect.size.width, (int)height)];
		UIImage *newwax = [ImageUtils putImage:wax atPoint:CGPointMake(0, 0) onImage:i];
		int index = jarRect.size.height-height;
		CGPoint p = CGPointFromString( [maskCoords objectAtIndex:index]);
		
		UIImageView *v = [[UIImageView alloc] initWithImage:[meltAnimationImages lastObject]];
		v.frame = CGRectMake(0, 0, p.y, v.image.size.height);
		i = [ImageUtils getImageFromView:v];
		[v release];
		
		newwax = [ImageUtils putImage:i atPoint:CGPointMake(p.x, (int)height - i.size.height/2) onImage:newwax];
		candlesView.wax.image = newwax;
	}
*/	
	candlesView.wax.alpha = 1;
	candlesView.meltView.image = nil;
	meltImage = nil;
	candlesView.meltAnimation.image = nil;
	
	[self stopFlameTimer];

	height = keepHeight;

	for (WickView *v in wicksView) {
		v.center = CGPointMake(v.center.x, jarRect.size.height - height - v.image.size.height/2);
		[v showSmoke];
		v.image = [ImageUtils loadNativeImage:@"burn_wick.png"];
	}
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backStep) userInfo:nil repeats:NO];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playTrackNow) userInfo:nil repeats:NO];
	
	UIAlertView * a = [[UIAlertView alloc] initWithTitle: @"What do you want to do?"
												 message: nil 
												delegate: self 
									   cancelButtonTitle: @"Update candle"
									   otherButtonTitles: @"New candle", nil]; 
	
	[a show]; 
	[a release];
	
//	

	
	
//	NSString *imgPath = [NSString stringWithFormat:@"%@/img", [Utils documentsDirectory]];
//	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(wax)];
//	NSLog(@"path %@", imgPath);
//	[imageData writeToFile:imgPath atomically:YES];
	
	
	

//	NSLog(@"frame %@, %@", NSStringFromCGSize(i.size), NSStringFromCGSize(wax.size));
	
/*	
	NSString *imgPath = [NSString stringWithFormat:@"%@/img", [Utils documentsDirectory]];
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(candlesView.wax.image)];
	NSLog(@"path %@", imgPath);
	[imageData writeToFile:imgPath atomically:YES];

	if (1) {
		NSString *imgPath = [NSString stringWithFormat:@"%@/imgi", [Utils documentsDirectory]];
		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(wax)];
		NSLog(@"path %@", imgPath);
		[imageData writeToFile:imgPath atomically:YES];
		
	}
*/

	
///	candlesView.meltAnimation.frame = CGRectMake(jarRect.origin.x+p.x, jarRect.origin.y+i.size.height-(int)height-i.meltAnimation.image.size.height/2, p.y, candlesView.meltAnimation.image.size.height);
	
	
	
	
//	waxNumber = c.tag - 1;
//	waxView = [[WaxView alloc] initWithFrame:CGRectMake(0, 0, jarRect.size.width, jarRect.size.height) andName: [waxes objectAtIndex:waxNumber]];
//	[candlesView.wax addSubview:waxView];
//	[waxView release];
	
	
	
//	NSLog(@"waxview %@", waxView);
	
	
	
	
	

}

#pragma mark init all scroll views
- (void) addJarsToScrollView {
	int shift = 20;
	int x = shift;
	int i = 1;
	for  (NSString *s in jars) {
		LabelUnderImage *lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
															imageName:[NSString stringWithFormat:@"%@/%@/jars_add/small_%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
													selectedImageName:nil
															labelText:nil
															andHeight:candlesView.jarsScrollView.frame.size.height];
		x += shift + lui.frame.size.width;
		[candlesView.jarsScrollView addSubview:lui];
		lui.c.tag = i++;
		[lui.c addTarget:self action:@selector(setNewJar:) forControlEvents:UIControlEventTouchDown];
		[lui release];
	}
	candlesView.jarsScrollView.contentSize = CGSizeMake(x, candlesView.jarsScrollView.frame.size.height);
}
- (void) addWaxesToScrollView {
	int shift = 20;
	int x = shift;
	int i = 1;
	for  (NSString *s in waxes) {
		LabelUnderImage *lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
															imageName:[NSString stringWithFormat:@"%@/%@/waxes_add/%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
													selectedImageName:nil
															labelText:s
															andHeight:candlesView.waxScrollView.frame.size.height];
		x += shift + lui.frame.size.width;
		[candlesView.waxScrollView addSubview:lui];
		lui.c.tag = i++;
		[lui.c addTarget:self action:@selector(startPouringWithNewWax:) forControlEvents:UIControlEventTouchDown];
		[lui.c addTarget:self action:@selector(endPouring) forControlEvents:UIControlEventTouchUpInside];
		[lui.c addTarget:self action:@selector(endPouring) forControlEvents:UIControlEventTouchUpOutside];
		[lui release];
	}
	candlesView.waxScrollView.contentSize = CGSizeMake(x, candlesView.waxScrollView.frame.size.height);
}
- (void) addAddinsToScrollView {
	int shift = 20;
	int x = shift;
	int i = 1;
	for  (NSString *s in addins) {
		LabelUnderImage *lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
															imageName:[NSString stringWithFormat:@"%@/%@/addins_add/%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
													selectedImageName:[NSString stringWithFormat:@"%@/%@/addins_add/h_%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
															labelText:s
															andHeight:candlesView.addinsScrollView.frame.size.height];
		x += shift + lui.frame.size.width;
		[candlesView.addinsScrollView addSubview:lui];
		lui.c.tag = i++;
		[lui.c addTarget:self action:@selector(selectAddins:) forControlEvents:UIControlEventTouchDown];
		[lui release];
		
		[addinsViews addObject:lui];
		
	}
	candlesView.waxView.selector = @selector(addAddins:);
	candlesView.waxView.target = self;
	candlesView.wickView.selector = @selector(addWick:);
	candlesView.wickView.target = self;
	candlesView.addinsScrollView.contentSize = CGSizeMake(x, candlesView.addinsScrollView.frame.size.height);
}
- (void) addColorsToScrollView {
	
	int shift = [Utils runningUnderiPad] ? 20 : 0;
	int x = shift;
	int i = 1;
	for  (NSString *s in colors) {
		LabelUnderImage *lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
															imageName:[NSString stringWithFormat:@"%@/%@/colors/%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
													selectedImageName:nil
															labelText:s
															andHeight:candlesView.colorsScrollView.frame.size.height];
		x += shift + lui.frame.size.width;
		[candlesView.colorsScrollView addSubview:lui];
		lui.c.tag = i++;
		[lui.c addTarget:self action:@selector(chooseTextColor:) forControlEvents:UIControlEventTouchDown];
		[lui release];
		lui.selectedImage = nil;
		[bedzViews addObject:lui];
		
	}
	candlesView.colorsScrollView.contentSize = CGSizeMake(x, candlesView.colorsScrollView.frame.size.height);
}
- (void) addFontsToScrollView {
	int shift = 20;
	int x = shift;
	int i = 1;
	for  (NSString *s in fontNames) {
		UILabel *l = [self generateLabelWithFont:s];
		[candlesView.fontsScrollView addSubview:l];
		l.frame = CGRectMake(x, 0, l.frame.size.width, l.frame.size.height);
		l.frame = CGRectMake(x, 20, l.frame.size.width, l.frame.size.height);
		l.center = CGPointMake(l.center.x, candlesView.fontsScrollView.frame.size.height/2);
		x += shift + l.frame.size.width;
		UIControl *c = [[UIControl alloc] initWithFrame:l.frame];
		[candlesView.fontsScrollView addSubview:c];
		c.tag = i++;
		[ c addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchDown];
		
	}
	candlesView.fontsScrollView.contentSize = CGSizeMake(x, candlesView.fontsScrollView.frame.size.height);
	
}
- (UILabel*) generateLabelWithFont: (NSString*) fontName {
	UILabel *l = [[[UILabel alloc] init] autorelease];
	l.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:0.0];
	l.layer.cornerRadius = 5;
	if ([Utils runningUnderiPad]) {
		l.font = [UIFont fontWithName:fontName size:60];
	} else {
		l.font = [UIFont fontWithName:fontName size:40];
	}
	
//	NSLog(@"font %@", l.font.fontName);
	
	l.textColor = [UIColor blackColor];
	l.text = @"Aa";
	CGSize s = [l.text sizeWithFont:l.font];
	l.frame = CGRectMake(0, 0, s.width, s.height);
	return l;
}
- (void) addPhotosToScrollView {
	int shift = 20;
	int x = shift;
	int i = 1;
	for  (NSString *s in photos) {
		LabelUnderImage *lui;
		if ([s isEqualToString:@"more"]) {
			lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
																imageName:[NSString stringWithFormat:@"%@/%@/lite/%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
														selectedImageName:nil
																labelText:s
																andHeight:candlesView.photosScrollView.frame.size.height];
		} else {
			lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
																imageName:[NSString stringWithFormat:@"%@/%@/categories/%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
														selectedImageName:nil
																labelText:s
																andHeight:candlesView.photosScrollView.frame.size.height];
		}
		
		x += shift + lui.frame.size.width;
		[candlesView.photosScrollView addSubview:lui];
		if ([s isEqualToString:@"camera"]) {
			cameraView = lui;
		}
		lui.c.tag = i++;
		[lui.c addTarget:self action:@selector(selectPhotoCategory:) forControlEvents:UIControlEventTouchDown];
		[lui release];
		
		[photosViews addObject:lui];
		
	}
	candlesView.photosView.selector = @selector(addPhotos:);
	candlesView.photosView.target = self;
	candlesView.photosScrollView.contentSize = CGSizeMake(x, candlesView.photosScrollView.frame.size.height);
}
- (void) addCategoriesItems: (NSNumber*) catNumber {
	int num = [catNumber intValue];
	NSLog(@"next %d", num);
	
	int shift = 20;
	int x = shift;
	int i = 1;
	
	[photosViews removeAllObjects];
	[photoCategoriesItems removeAllObjects];
	for (UIView *v in candlesView.categoriesItemsScrollView.subviews) {
		[v removeFromSuperview];
	}
/// get items from categories type	
	NSString *catName = [photos objectAtIndex:num];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *path = [NSString stringWithFormat:@"%@/%@/categories_add/%@", [[NSBundle mainBundle] bundlePath],[ImageUtils getFodler], catName];
	NSArray *f = [fm contentsOfDirectoryAtPath:path error:nil];
//	NSLog(@"f %@", f);
    f = [self remove2x:f];
//	NSLog(@"f %@", f);
	
	for (NSString *s in f) {
		[photoCategoriesItems addObject:[s stringByDeletingPathExtension]];
	}
	
	
	for  (NSString *s in photoCategoriesItems) {
//		NSLog(@"add %@", [NSString stringWithFormat:@"%@/%@_add/%@.png", path, catName, s]);
		LabelUnderImage *lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
															imageName:[NSString stringWithFormat:@"%@/%@/categories_add/%@_add/%@.png",[[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], catName, s]
													selectedImageName:[NSString stringWithFormat:@"%@/%@/categories_add/%@_h/%@.png",[[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], catName, s]
															labelText:nil
															andHeight:candlesView.categoriesItemsScrollView.frame.size.height];
		x += shift + lui.frame.size.width;
		[candlesView.categoriesItemsScrollView addSubview:lui];
		lui.c.tag = i++;
		[lui.c addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchDown];
		[lui release];
		
		[photosViews addObject:lui];
		
	}
	candlesView.photosView.selector = @selector(addPhotos:);
	candlesView.photosView.target = self;
	candlesView.categoriesItemsScrollView.contentOffset = CGPointMake(0, 0);
	candlesView.categoriesItemsScrollView.contentSize = CGSizeMake(x, candlesView.categoriesItemsScrollView.frame.size.height);
	
}
- (void) addBedazzlesToScrollView {
	int shift = 20;
	int x = shift;
	int i = 1;
	for  (NSString *s in bedz) {
		LabelUnderImage *lui = [[LabelUnderImage alloc] initWithPoint:CGPointMake(x, 0)
															imageName:[NSString stringWithFormat:@"%@/%@/bedazzle/%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
													selectedImageName:[NSString stringWithFormat:@"%@/%@/bedazzle_add/h_%@.png", [[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], s]
															labelText:nil
															andHeight:candlesView.bedazzleScrollView.frame.size.height];
		x += shift + lui.frame.size.width;
		[candlesView.bedazzleScrollView addSubview:lui];
		lui.c.tag = i++;
		[lui.c addTarget:self action:@selector(selectBedazzle:) forControlEvents:UIControlEventTouchDown];
		[lui release];
		
		[bedzViews addObject:lui];
		
	}
	candlesView.bedazzleView.selector = @selector(addBedazzles:);
	candlesView.bedazzleView.target = self;    
	candlesView.bedazzleScrollView.contentSize = CGSizeMake(x, candlesView.bedazzleScrollView.frame.size.height);
}

#pragma mark Actions

- (void) setNewJar: (UIControl*) c {
	[candlesView.currentAction setTitle:kChooseWax forState:UIControlStateNormal];
	[self initWithImageName:[jars objectAtIndex:c.tag-1]];
}

- (void) startPouringWithNewWax: (UIControl*) c {
	[candlesView.currentAction setTitle:kChooseAddins forState:UIControlStateNormal];
	waxNumber = c.tag - 1;
	[self startPouring];
}

- (void) selectAddins: (UIControl*) c {
	for (LabelUnderImage * lui in addinsViews) {
		[lui setSelected:lui.c.tag == c.tag];
	}
	currentSelectedAddins = c.tag-1;
	[candlesView.currentAction setTitle:kChooseWick forState:UIControlStateNormal];
}
- (void) addAddins: (NSString*) p {
//	NSLog(@"adding %@", addins);
	
	if (mode == state_chooseaddins && currentSelectedAddins >= 0) {
//		NSLog(@"image %@", [NSString stringWithFormat:@"addins/%@.png", [addins objectAtIndex:currentSelectedAddins]]);
		UIImage *i = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"addins/%@.png", [addins objectAtIndex:currentSelectedAddins]]];
		CustomImageView *v = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 0, i.size.width, i.size.height)];
		v.image = i;
		v.name = [addins objectAtIndex:currentSelectedAddins];
		v.tag = _custom_view_tag;
		[candlesView.waxView addSubview:v];
		[v release];
		v.center = CGPointFromString(p);
	}
}

- (void) addWick: (NSString*) point {
	if (mode == state_addwick && [wicksView count] < 5) {
		[candlesView.currentAction setTitle:kChooseDecorate forState:UIControlStateNormal];
		UIImage *i = [ImageUtils loadNativeImage:@"wick.png"];
		WickView *v = [[WickView alloc] initWithFrame:CGRectMake(0, 0, i.size.width, i.size.height)];
		v.image = i;
		v.currentFlameSprite =rand()%[flames count];
		[v showFlameImage: [NSString stringWithFormat:@"flame/%@.png", [flames objectAtIndex:v.currentFlameSprite]]];
		[candlesView.wickView addSubview:v];
		v.tag = _custom_view_tag;
		[v release];
		[wicksView addObject:v];
		CGPoint p = CGPointFromString(point);
		
//		NSLog(@"%@", waxView);
//		NSLog(@"x %d, maxx %d", (int)currentWaxPoint.x, (int)currentWaxPoint.y);
		
		int x = p.x;
/*		if (p.x < currentWaxPoint.x + i.size.width/2) {
			x = currentWaxPoint.x + i.size.width/2;
		}

		if (p.x > currentWaxPoint.x + currentWaxPoint.y - i.size.width/2) {
			x = currentWaxPoint.x + currentWaxPoint.y - i.size.width/2;
		}
*/		
		
		int l;
		
		if ([Utils runningUnderiPad]) {
			if ([currentJarName isEqualToString:@"3-wick"]) {
				l = 410;
			}
			if ([currentJarName isEqualToString:@"cone"]) {
				l = 330;
			}
			if ([currentJarName isEqualToString:@"cup"]) {
				l = 320;
			}
			if ([currentJarName isEqualToString:@"fancy"]) {
				l = 430;
			}
			if ([currentJarName isEqualToString:@"jam"]) {
				l = 240;
			}
			if ([currentJarName isEqualToString:@"oval"]) {
				l = 370;
			}
			if ([currentJarName isEqualToString:@"pillar"]) {
				l = 170;
			}
			if ([currentJarName isEqualToString:@"rectangle"]) {
				l = 540;
			}
			if ([currentJarName isEqualToString:@"round"]) {
				l = 290;
			}
			if ([currentJarName isEqualToString:@"square"]) {
				l = 330;
			}
			
			l -= 180;
		} else {
			if ([currentJarName isEqualToString:@"3-wick"]) {
				l = 190;
			}
			if ([currentJarName isEqualToString:@"cone"]) {
				l = 160;
			}
			if ([currentJarName isEqualToString:@"cup"]) {
				l = 130;
			}
			if ([currentJarName isEqualToString:@"fancy"]) {
				l = 175;
			}
			if ([currentJarName isEqualToString:@"jam"]) {
				l = 120;
			}
			if ([currentJarName isEqualToString:@"oval"]) {
				l = 175;
			}
			if ([currentJarName isEqualToString:@"pillar"]) {
				l = 80;
			}
			if ([currentJarName isEqualToString:@"rectangle"]) {
				l = 220;
			}
			if ([currentJarName isEqualToString:@"round"]) {
				l = 135;
			}
			if ([currentJarName isEqualToString:@"square"]) {
				l = 160;
			}
			l -= 30;
		}
		l /=2;
		
		
		
		if (l < 0) l = 0;
		
		if (jarRect.size.width/2 - l > x) x = jarRect.size.width/2 - l;
		if (jarRect.size.width/2 + l < x) x = jarRect.size.width/2 + l;
		
//		NSLog(@"p.x %d , l  %d, x %d, jarRect.size.width/2+l %d", (int)p.x, l, x, (int)jarRect.size.width/2 + l);
		
		
		
		v.center = CGPointMake(x, jarRect.size.height - height - i.size.height/2);
	}
}

- (void) backStepCategories {
	currentSelectedPhotos = -1;
	categoriesMode = cat_state_default;
	[candlesView showCategoriesItems: categoriesMode];
}

- (void) buyTheGame {
	NSString *url;
	if ([Utils runningUnderiPad]) {
		url = full_link;
	} else {
		url = full_link_iphone;
	}
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void) selectPhotoCategory: (UIControl*) c {
	currentSelectedPhotos = -1;
	int si = c.tag-1;
	categoriesMode = si;

	NSString *name = [photos objectAtIndex:si];

#ifdef LITE
	if ([name isEqualToString:@"more"]) {
		NSLog(@"show more");
		
		UIControl *c = [[UIControl alloc] initWithFrame:[candlesView bounds]];
		[candlesView addSubview:c];
		[c release];
		c.userInteractionEnabled = YES;
		
		UIImageView *i = [[UIImageView alloc] initWithImage:[ImageUtils loadNativeImage:@"lite/background.png"]];
		i.frame = CGRectMake(310, 170, i.image.size.width, i.image.size.height);
		[c addSubview:i];
		[i release];
		i.alpha  =0;
		i.userInteractionEnabled = YES;
		UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b setImage:[ImageUtils loadNativeImage:@"lite/getitnowbutton.png"] forState:UIControlStateNormal];
		b.frame = CGRectMake(25+3, 490, 348, 80);
		[i addSubview:b];
		[b addTarget:self action:@selector(buyTheGame) forControlEvents:UIControlEventTouchUpInside];
		[b addTarget:c action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
		
		UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
		[b1 setImage:[ImageUtils loadNativeImage:@"lite/closebutton.png"] forState:UIControlStateNormal];
		b1.frame = CGRectMake(360, 10, 32, 32);
		[i addSubview:b1];
		[b1 addTarget:c action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
		
		if (![Utils runningUnderiPad]) {
			//		b.frame = CGRectMake(320/2-174/2, 360, 174, 40);
			i.frame = CGRectMake(320/2-i.image.size.width/2, 480/2-i.image.size.height/2, i.image.size.width, i.image.size.height);
			b.center = CGPointMake(i.frame.size.width/2, 360);
			b1.center = CGPointMake(i.frame.size.width-15, 15);
		}
		
		
		[UIView beginAnimations:nil context:0];
		[UIView setAnimationDuration:0.5];
		i.alpha = 1;
		[UIView commitAnimations];
		
		return;
	}
#endif

//	NSLog(@"tap %@, %d", name, c.tag);
	if ([name isEqualToString:@"camera"]) {
		NSLog(@"show camera");
		
		if ([Utils runningUnderiPad]) {
			[self setupImagePicker];
		} else {
			UIImagePickerController* picker = [[UIImagePickerController alloc] init]; 
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
			picker.delegate = self; 
			picker.allowsEditing = YES;
			[self presentModalViewController: picker animated:YES];
			[picker release];
//			[self picker];
//			imagePickerController.sourceType = sourceType;
//			imagePickerController.showsCameraControls = NO;
		}
		
	} else {
		[candlesView showCategoriesItems:si];
	}
	[candlesView.currentAction setTitle:kChooseText forState:UIControlStateNormal];
}

- (void) selectPhoto: (UIControl*) c {
	for (LabelUnderImage * lui in photosViews) {
		[lui setSelected:lui.c.tag == c.tag];
	}
	currentSelectedPhotos = c.tag-1;
}

- (void) addPhotos: (NSString*) p {
//	NSLog(@"mode %d", mode);
	if (mode == state_decorate && currentSelectedPhotos >= 0 && categoriesMode >= 0) {
		NSString *name = [NSString stringWithFormat:@"categories_add/%@/%@.png", [photos objectAtIndex:categoriesMode], [photoCategoriesItems objectAtIndex:currentSelectedPhotos]];
		UIImage *i = [ImageUtils loadNativeImage:name];
		MovingImageView *v = [[MovingImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250) ];
		v.image = i;
		v.name = [NSString stringWithFormat:@"%@/%@", [photos objectAtIndex:categoriesMode], [photoCategoriesItems objectAtIndex:currentSelectedPhotos]];
		v.isPhoto = NO;
		v.tag = _custom_view_tag;
		[candlesView.photosView addSubview:v];
		[v release];
		v.center = CGPointFromString(p);
	}
}

- (void) chooseTextColor: (UIControl*) c {
	NSString *color = [colors objectAtIndex:c.tag - 1];
	if (currentLabel) {
		currentLabel.colorName = color;
		if ([color isEqualToString:@"black"]) currentLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.000];
		if ([color isEqualToString:@"blue"]) currentLabel.textColor = [UIColor colorWithRed:0.063 green:0.686 blue:0.878 alpha:1.000];
		if ([color isEqualToString:@"green"]) currentLabel.textColor = [UIColor colorWithRed:0.090 green:0.737 blue:0.137 alpha:1.000];
		if ([color isEqualToString:@"orange"]) currentLabel.textColor = [UIColor colorWithRed:0.957 green:0.416 blue:0.047 alpha:1.000];
		if ([color isEqualToString:@"purple"]) currentLabel.textColor = [UIColor colorWithRed:0.737 green:0.039 blue:0.757 alpha:1.000];
		if ([color isEqualToString:@"red"]) currentLabel.textColor = [UIColor colorWithRed:0.937 green:0.047 blue:0.047 alpha:1.000];
		if ([color isEqualToString:@"white"]) currentLabel.textColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.969 alpha:1.000];
		if ([color isEqualToString:@"yellow"]) currentLabel.textColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.031 alpha:1.000];
		if ([color isEqualToString:@"pink"]) currentLabel.textColor = [UIColor colorWithRed:0.957 green:0.478 blue:0.957 alpha:1.000];
	}
	
	
}
- (void) changeFont: (UIControl*) c {
	currentLabel.font = [UIFont fontWithName:[fontNames objectAtIndex:c.tag-1] size:currentLabel.font.pointSize];
	currentLabel.text = currentLabel.text;
}
- (void) setCurrentLabel: (CustomLabel*) l {
	if (currentLabel) {	/// set back off ion old label
		[currentLabel setBackground:NO];
	}
	currentLabel = l;
	if (l) {
		[candlesView.currentAction setTitle:kChooseBedazzle forState:UIControlStateNormal];
		[textField becomeFirstResponder];
		[currentLabel setBackground:YES];
		textField.text = currentLabel.text;
	}
}
- (BOOL)textFieldShouldReturn:(UITextField *) _textField {
	[candlesView.currentAction setTitle:kChooseBedazzle forState:UIControlStateNormal];
	currentLabel.text = _textField.text;
	[_textField resignFirstResponder];
	
	[currentLabel setBackground:NO];
	return YES;
}
- (BOOL) textField:(UITextField *) _textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[candlesView.currentAction setTitle:kChooseBedazzle forState:UIControlStateNormal];
	if ([string length]) {
		textField.text = [NSString stringWithFormat:@"%@%@", textField.text, string];
	} else {
		textField.text = [textField.text substringToIndex:[textField.text length] -1];
	}
	currentLabel.text = _textField.text;
	return NO;
}
- (void) selectBedazzle: (UIControl*) c {
	for (LabelUnderImage * lui in bedzViews) {
		[lui setSelected:lui.c.tag == c.tag];
	}
	currentSelectedBedz = c.tag-1;
	[candlesView.currentAction setTitle:kChooseFire forState:UIControlStateNormal];
}
- (void) addBedazzles: (NSString*) p {
	if (mode == state_addbed && currentSelectedBedz >= 0) {
		UIImage *i = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"bedazzle/%@.png", [bedz objectAtIndex:currentSelectedBedz]]];
		MovingImageView *v = [[MovingImageView alloc] initWithFrame:CGRectMake(0, 0, i.size.width, i.size.height)];
		v.image = i;
		v.isPhoto = NO;
		v.name = [bedz objectAtIndex:currentSelectedBedz];
		v.tag = _custom_view_tag;
		[candlesView.bedazzleView addSubview:v];
		[v release];
		v.center = CGPointFromString(p);
	}
}


#pragma mark WAX Pouring
- (void) initWithImageName: (NSString*) name {
//	candlesView.background.alpha = 0.0;
//	candlesView.backgroundColor = [UIColor greenColor];
	self.currentJarName = name;			/// set jar name for saving state
	UIImage *img = [self createMaskForImageFromCenterToImage:[NSString stringWithFormat:@"backs/%@", candlesView.backName]
													withMask:[NSString stringWithFormat:@"jars_add/%@_mask.png",name]];
	candlesView.mask.image = img;
//	candlesView.mask.backgroundColor = [UIColor redColor];

//	candlesView.jarsBack.image = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"jars_add/%@_top.png",name]];
//	candlesView.jarsBack.frame = CGRectMake(jarRect.origin.x, jarRect.origin.y, candlesView.jarsBack.image.size.width, candlesView.jarsBack.image.size.height);
//	candlesView.jarsBack.backgroundColor = [UIColor redColor];
	
	
	
//	candlesView.mask.frame = jarRect;
//	candlesView.blackMask.frame = jarRect;
	
}

- (void) startPouring {
	if (height > jarRect.size.height - _max_pouring) return;	

	waxView = [[WaxView alloc] initWithFrame:CGRectMake(0, 0, jarRect.size.width, jarRect.size.height) andName: [waxes objectAtIndex:waxNumber]];
	[candlesView.wax addSubview:waxView];
	[waxView release];

//	jetView.backgroundColor = [UIColor greenColor];
//	jetView.hidden = YES;
	//	jetView.image = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"wax/%@/jet.png", [waxes objectAtIndex:waxNumber]] ];
	candlesView.jetView.image = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"wax/%@/jet.png", [waxes objectAtIndex:waxNumber]] ];
	candlesView.jetView.frame = CGRectZero;//CGRectMake(0, 0, jetView.image.size.width, jetView.image.size.height);
//	jetView.center = CGPointMake(jarRect.size.width/2, jarRect.size.height-height-jetView.frame.size.height/2 + 10);
	int index = jarRect.size.height-height-1;
	waxView.bottomPoint = CGPointFromString( [maskCoords objectAtIndex:index]);
	
	[candlesView insertSubview:candlesView.jetView aboveSubview:candlesView.jar];

	
	waxView.startPoint = height-1;
	waxView.heigth = height;
	[self startTimer];
	candlesView.jetView.hidden = NO;
	val = 0;
	[pouringSound play];
	
}
- (void) endPouring {
	if (!waxView) return;
	candlesView.jetView.hidden = YES;
	[self stopTimer];
	
	/// generate an image from contexts
	UIImage *image = [ImageUtils getImageFromView:waxView];
	if (candlesView.wax.image) {
		
//		NSLog(@"i1 %@ %f", NSStringFromCGSize(image.size), image.scale);
//		NSLog(@"i2 %@ %f", NSStringFromCGSize(candlesView.wax.image.size), candlesView.wax.image.scale);
		
		float sf = 1.0;
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			if ([[UIScreen mainScreen] scale] == 2.0) {
				image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
				candlesView.wax.image = [UIImage imageWithCGImage:candlesView.wax.image.CGImage scale:1.0 orientation:UIImageOrientationUp];
//				sf = 2.0;
			} 
		}
		
//		NSLog(@"i1 %@ %f", NSStringFromCGSize(image.size), image.scale);
//		NSLog(@"i2 %@ %f", NSStringFromCGSize(candlesView.wax.image.size), candlesView.wax.image.scale);

		
		image = [ImageUtils putImage:image atPoint:CGPointMake(0, 0) onImage:candlesView.wax.image];

//		NSLog(@"res %@ %f", NSStringFromCGSize(image.size), image.scale);

	}
	candlesView.wax.image = image;
	[waxView removeFromSuperview];
	waxView = nil;
	[pouringSound stop];
	
}

#define _height_wax_increment 4

- (void) renderer {
	waxView.canDraw = YES;
//	NSLog(@"render %f", height);
	if (height > jarRect.size.height-_max_pouring) {
		return;
	}
	int h;
	if ([Utils runningUnderiPad]) {
		h = _height_wax_increment;
	} else {
		h = _height_wax_increment/2;
	}
	
	height += h;
	for (int i=0; i < h; i++) {
		[waxNames addObject:[NSString stringWithFormat:@"%d", waxNumber]];
	}
	
//	NSLog(@"%d %d", (int) height, [waxNames count]);
	
	val += 0.2;
	
	float shift = 20*sin(val);
	
	float s = 5 + 5*cos(10*val);
	
	candlesView.jetView.frame = CGRectMake(candlesView.frame.size.width/2+shift, 0, s, jarRect.size.height+jarRect.origin.y - height);
	
	int index = jarRect.size.height-height;
	waxView.currentPoint = CGPointFromString( [maskCoords objectAtIndex:index]);
	waxView.heigth = height;
	[waxView setNeedsDisplay];
	
	currentWaxPoint = waxView.currentPoint;
	
}
- (void) stopTimer {
	if (timer) {
		[timer invalidate];
		timer = nil;
	}
}
- (void) startTimer {
	[self stopTimer];
	timer = [NSTimer scheduledTimerWithTimeInterval:1/12.0 target:self selector:@selector(renderer) userInfo:nil repeats:YES];
}


- (void) stopFlameTimer {
	if (flameTimer) {
		[flameTimer invalidate];
		flameTimer = nil;
	}
}
- (void) startFlameTimer {
	[self stopFlameTimer];
	
//	for (WickView *v in wicksView) {
//		v.center = CGPointMake(v.center.x, jarRect.size.height - height - v.image.size.height/2);
//		[v showSmoke];
//		v.image = nil;//[ImageUtils loadNativeImage:@"burn_wick.png"];
//	}
	
	keepHeight = height;
	animationCounter = 0;
	waxNumberForAnimation = -1;
//	[self setAnimationImages];
	
	canGoDown = 0;
	[startLightingSound play];
	[lightingSound play];
	
	[self flameRender];		/// set animations presets
	
//	flameTimer = [NSTimer scheduledTimerWithTimeInterval:1/24.0 target:self selector:@selector(flameRender) userInfo:nil repeats:YES];
}

- (void) setAnimationImages {
	
//	NSLog(@"get index %d count %d", (int)height -1  - default_wax_shift, [waxNames count]);
	if ([waxNames count]) {
		int wn = [[waxNames objectAtIndex:(int)height - 1 - default_wax_shift] intValue];
//		NSLog(@"wn %d", wn);
		if (wn != waxNumberForAnimation) {
			waxNumberForAnimation = wn;
			NSFileManager *fm = [NSFileManager defaultManager];
			NSString *path = [NSString stringWithFormat:@"%@/%@/wax/%@/ell", [[NSBundle mainBundle ]bundlePath], [ImageUtils getFodler], [waxes objectAtIndex: wn]];
//			NSLog(@"path %@", path);
			NSArray *f = [fm contentsOfDirectoryAtPath:path error:nil];
            f = [self remove2x:f];
			self.meltAnimationImages = [NSMutableArray array];
			
			for (NSString *s in f) {
				[meltAnimationImages addObject:[ImageUtils loadNativeImage:[NSString stringWithFormat:@"wax/%@/ell/%@", [waxes objectAtIndex: wn], s]]];
			}
			
		}
	}
}

- (void) flameRender {
	
	
//	NSLog(@"wax %@", candlesView.waxView);
	
	if (height > ([Utils runningUnderiPad] ? 50 : 30) && !canGoDown) height -= 0.025;
	
	if (canGoDown > 0) {
		canGoDown--;
	} else {
		canGoDown = 0;
	}
	
	if (!canGoDown && [waxNames count]) {
		[self setAnimationImages];
		
		float sf = 1.0;
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			if ([[UIScreen mainScreen] scale] == 2.0) {
				sf = 2.0;
			} 
		}
		if (sf == 2.0) {
			
//			NSLog(@"meltImage %@ %f", NSStringFromCGSize(meltImage.size), meltImage.scale);
			UIImage *mi = [UIImage imageWithCGImage:meltImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
//			NSLog(@"mi %@ %f", NSStringFromCGSize(mi.size), mi.scale);
			
			candlesView.meltView.image = [ImageUtils imageByCropping:mi
															  toRect:CGRectMake(0, (meltImage.size.height-(int)height)*sf, meltImage.size.width*sf, (int)height*sf)];

//			NSLog(@"view.image %@ %f", NSStringFromCGSize(candlesView.meltView.image.size), candlesView.meltView.image.scale);

			
			candlesView.meltView.frame = CGRectMake(jarRect.origin.x, jarRect.origin.y+meltImage.size.height-(int)height, meltImage.size.width, (int)height);
			
			
			int index = jarRect.size.height-height;
			CGPoint p = CGPointFromString( [maskCoords objectAtIndex:index]);
			candlesView.meltAnimation.image = [meltAnimationImages objectAtIndex:animationCounter/2];
			animationCounter++;
			if (animationCounter >= [meltAnimationImages count]*2) animationCounter = 0;
			candlesView.meltAnimation.frame = CGRectMake(jarRect.origin.x+p.x, jarRect.origin.y+meltImage.size.height-(int)height-candlesView.meltAnimation.image.size.height/2, p.y, candlesView.meltAnimation.image.size.height);
			
//			NSLog(@"meltAnimation %@", NSStringFromCGRect(candlesView.meltAnimation.frame));
		} else {
			candlesView.meltView.image = [ImageUtils imageByCropping:meltImage toRect:CGRectMake(0, meltImage.size.height-(int)height, meltImage.size.width, (int)height)];
			candlesView.meltView.frame = CGRectMake(jarRect.origin.x, jarRect.origin.y+meltImage.size.height-(int)height, meltImage.size.width, (int)height);
			int index = jarRect.size.height-height;
			CGPoint p = CGPointFromString( [maskCoords objectAtIndex:index]);
			candlesView.meltAnimation.image = [meltAnimationImages objectAtIndex:animationCounter/2];
			animationCounter++;
			if (animationCounter >= [meltAnimationImages count]*2) animationCounter = 0;
			candlesView.meltAnimation.frame = CGRectMake(jarRect.origin.x+p.x, jarRect.origin.y+meltImage.size.height-(int)height-candlesView.meltAnimation.image.size.height/2, p.y, candlesView.meltAnimation.image.size.height);
		}
		
		
		
	}
	
	for (WickView *v in wicksView) {
		v.center = CGPointMake(v.center.x, jarRect.size.height - height - v.image.size.height/2);
		v.currentFlameSprite++;
		if (v.currentFlameSprite >= [flames count]) {
			v.currentFlameSprite = 0;
		}
		[v showFlameImage: [NSString stringWithFormat:@"flame/%@.png", [flames objectAtIndex:v.currentFlameSprite]]];
	}
}



#pragma mark MASK Generation

- (void) changeMasks {
//	candlesView.noTouch.hidden = NO;

	UIImage *img = [self createMaskForImageFromCenterToImage:[NSString stringWithFormat:@"backs/%@", candlesView.backName]
													withMask:[NSString stringWithFormat:@"jars_add/%@_mask.png", currentJarName]];
	candlesView.mask.image = img;
	
}

- (UIImage*) createMaskForImageFromCenterToImage: (NSString*) backImage withMask: (NSString*) maskName {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    float sf = [[UIScreen mainScreen] scale];
//	candlesView.contentScaleFactor = 2;
//    NSLog(@"scale %f %f", sf, candlesView.jar.contentScaleFactor);
	
	
//	if (inProcess) return;
	
//	[candlesView addSubview: candlesView.noTouch];
//	candlesView.noTouch.hidden = YES;
//	candlesView.barItemsView.userInteractionEnabled = NO;

//	UIImage *maskImage = [ImageUtils loadNativeImage:maskName];
//	UIImage *oimage = [ImageUtils loadNativeImage: backImage];
	
	NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], [ImageUtils getFodler]];

	
	UIImage *maskImage = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/%@", path, maskName]];
	UIImage *oimage = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/%@", path, backImage]];
	
//	NSLog(@"maskImage %@, path %@", maskImage, [NSString stringWithFormat:@"%@/%@", path, maskName]);
	
	
	
//	maskImage = [UIImage imageWithCGImage:maskImage.CGImage scale:sf orientation:maskImage.imageOrientation];	
//	oimage = [UIImage imageWithCGImage:oimage.CGImage scale:sf orientation:oimage.imageOrientation];	
	
//	NSLog(@"generate mask");
//	NSLog(@"maskImage %@ - %@", maskName, NSStringFromCGSize(maskImage.size));
//	NSLog(@"oimage %@ - %@", oimage, NSStringFromCGSize(oimage.size));
	
	/// crop from center rect of mask
	
//	sf = 1;
	
//	jarRect = CGRectMake((int)oimage.size.width*sf/2-(int)maskImage.size.width*sf/2,
//						 (int)oimage.size.height*sf-(int)maskImage.size.height*sf-([Utils runningUnderiPad]?(200):(100*sf)),		/// на 100 пиксов надо ниже центра
//							 (int)maskImage.size.width*sf, (int)maskImage.size.height*sf);

	jarRect = CGRectMake((int)oimage.size.width/2-(int)maskImage.size.width/2,
						 (int)oimage.size.height-(int)maskImage.size.height-([Utils runningUnderiPad]?(200):(100)),		/// на 100 пиксов надо ниже центра
						 (int)maskImage.size.width, (int)maskImage.size.height);
	
	
//	jarRect = CGRectMake(0,
//						 200,		/// на 100 пиксов надо ниже центра
//						 (int)maskImage.size.width, (int)maskImage.size.height);
	//	oimage = [UIImage imageWithCGImage:oimage.CGImage scale:1/sf orientation:oimage.imageOrientation];
	
	
//	NSLog(@"jarrect %@", NSStringFromCGRect(jarRect));
	
//	UIImage *topImage = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"jars_add/%@_top.png", currentJarName]];
	UIImage *topImage = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/jars_add/%@_top.png", path, currentJarName]];

//	return topImage;
	
//	NSLog(@"topImage %@ %@", topImage, NSStringFromCGSize(topImage.size));
	
	candlesView.jarsBack.image = topImage;
//	candlesView.jarsBack.contentScaleFactor = 1;
	candlesView.jarsBack.frame = CGRectMake(jarRect.origin.x, jarRect.origin.y, candlesView.jarsBack.image.size.width, candlesView.jarsBack.image.size.height);
//	candlesView.jarsBack.backgroundColor = [UIColor redColor];
//	NSLog(@"jarrect %@", NSStringFromCGRect(jarRect));
	
	
	candlesView.waxView.frame = jarRect;
	candlesView.wickView.frame = jarRect;
	candlesView.jar.frame = jarRect;
//	candlesView.jar.image = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"jars/%@.png", currentJarName]];
	candlesView.jar.image = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/jars/%@.png", path, currentJarName]];
	candlesView.wax.frame = jarRect;
	candlesView.meltView.frame = jarRect;

//	candlesView.jar.backgroundColor = [UIColor blueColor];
//	NSLog(@"hehe");
	candlesView.topMask.frame = candlesView.jarsBack.frame;
	candlesView.blackMaskTop.frame = candlesView.jarsBack.frame;
	CGRect jr = CGRectMake(jarRect.origin.x, jarRect.origin.y+topImage.size.height, jarRect.size.width, jarRect.size.height-topImage.size.height);
	candlesView.mask.frame = jr;
	candlesView.titlesView.frame = jr;	
	candlesView.photosView.frame = jr;
	candlesView.bedazzleView.frame = jr;
	candlesView.titlesView.clipsToBounds = YES;
	candlesView.photosView.clipsToBounds = YES;
	candlesView.bedazzleView.clipsToBounds = YES;
	
	candlesView.blackDown.frame = CGRectMake(jarRect.origin.x, jarRect.origin.y+jarRect.size.height, jarRect.size.width, 100);
//	NSLog(@"hehe11");
//	NSLog(@"hehe11 oimage %@, rect %@", NSStringFromCGSize(oimage.size), NSStringFromCGRect(jarRect));
//	NSLog(@"hehe11 %@", oimage);
	UIImage *originalImage;
	if (sf > 1) {
		CGRect jr = CGRectMake(jarRect.origin.x*sf, jarRect.origin.y*sf, jarRect.size.width*sf, jarRect.size.height*sf);
		originalImage = [ImageUtils imageByCropping:oimage toRect: jr];
	} else {
		originalImage = [ImageUtils imageByCropping:oimage toRect: jarRect];
	}
	
//	NSLog(@"hehe12 %@", oimage);
	
//	maskImage = [ImageUtils loadNativeImage:maskName];
//	return originalImage;
	
//	NSLog(@"hehe12 originalImage %@, mask maskImage %@", NSStringFromCGSize(originalImage.size), NSStringFromCGSize(maskImage.size));
	UIImage *img = [ImageUtils maskImage:originalImage withMask:maskImage];
//	img = [UIImage imageWithCGImage:img.CGImage scale:1/sf orientation:img.imageOrientation];	

	
//	NSLog(@"hehe13");
//	UIImage *jar = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"jars/%@.png", currentJarName]];
//	UIImage *jarMask = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"jars_add/%@_mask.png", currentJarName]];
	
	UIImage *jar = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/jars/%@.png", path, currentJarName]];
	UIImage *jarMask = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/jars_add/%@_mask.png", path, currentJarName]];
	
//	NSLog(@"%@ %@", NSStringFromCGSize(jar.size), NSStringFromCGSize(jarMask.size) );
	UIImage *inv = [ImageUtils maskImage:jar withMask:jarMask];
// 	inv = [UIImage imageWithCGImage:inv.CGImage scale: sf orientation:inv.imageOrientation];

//	NSLog(@"hehe2 inv %@", NSStringFromCGSize(inv.size));
	
//	return img;
	
	{
	
///		NSLog(@"hehe1 img %@", NSStringFromCGSize(img.size));
		img = [ImageUtils putImage:inv atPoint:CGPointMake(0, 0) onImage:img];
		
//		NSLog(@"hehe2 img %@", NSStringFromCGSize(img.size));
		
		
		img = [ImageUtils putImage:topImage atPoint:CGPointMake(0, img.size.height+topImage.size.height) onImage:img];
//		NSLog(@"hehe22 img %@", NSStringFromCGSize(img.size));
		
		
		if (sf > 1) {
			img = [ImageUtils imageByCropping:img toRect:CGRectMake(0, topImage.size.height*sf, img.size.width*sf, (img.size.height-topImage.size.height)*sf)];
		} else {
			img = [ImageUtils imageByCropping:img toRect:CGRectMake(0, topImage.size.height, img.size.width, img.size.height-topImage.size.height)];
		}
		
		
//		NSLog(@"hehe222 img %@", NSStringFromCGSize(img.size));
	}
	{
		if (sf > 1) {
			CGRect jr = CGRectMake(candlesView.topMask.frame.origin.x*sf, candlesView.topMask.frame.origin.y*sf, candlesView.topMask.frame.size.width*sf, candlesView.topMask.frame.size.height*sf);
			originalImage = [ImageUtils imageByCropping:oimage toRect: jr];
		} else {
			originalImage = [ImageUtils imageByCropping:oimage toRect: candlesView.topMask.frame];
		}
		
//		NSLog(@"originalImage img %@", NSStringFromCGSize(originalImage.size));
		
//		UIImage *mask_topImage = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"jars_add/%@_top_mask.png", currentJarName]];
		UIImage *mask_topImage = [UIImage imageWithContentsOfResolutionIndependentFile:[NSString stringWithFormat:@"%@/jars_add/%@_top_mask.png", path, currentJarName]];
		
		topImage = [ImageUtils maskImage:originalImage withMask: mask_topImage];
//		NSLog(@"topImage img %@", NSStringFromCGSize(topImage.size));
//		NSLog(@"candlesView.jar.image %@", candlesView.jar.image);
		
		UIImage *untopImage;
		if (sf > 1) {
			CGRect jr = CGRectMake(0, 0, candlesView.topMask.frame.size.width*sf, candlesView.topMask.frame.size.height*sf);
			untopImage = [ImageUtils imageByCropping:candlesView.jar.image toRect: jr];
		} else {
			untopImage = [ImageUtils imageByCropping:candlesView.jar.image toRect: candlesView.topMask.bounds];
		}
		
		topImage = [ImageUtils putImage:untopImage atPoint:CGPointMake(0, 0) onImage:topImage];
//		NSLog(@"topImage img %@", NSStringFromCGSize(topImage.size));
	}

//	NSLog(@"hehe3");
	
	candlesView.topMask.image = topImage;
	
//	return img;

/// generate array
	
    int m_width = jarRect.size.width;
    int m_height = jarRect.size.height;
    unsigned char *rgbImage = (unsigned char *) malloc(m_width * m_height * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
//    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//    CGContextSetShouldAntialias(context, NO);
	memset(rgbImage, 0, m_width * m_height * 4);

    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [maskImage CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

	self.maskCoords = nil;
	self.maskCoords = [NSMutableArray array];
		
	for(int y = 0; y < m_height; y++) {
		int b = 0;
		for(int x = 0; x < m_width; x++) {
			unsigned char r=rgbImage[y*m_width*4+x*4];
			if (r == 255) break;
			b++;
        }
		int w = 0;
       for(int x = b; x < m_width; x++) {
			unsigned char rgbPixel=rgbImage[y*m_width*4+x*4];
			if (rgbPixel < 0xf0) break;
			w++;
        }
		[maskCoords addObject:NSStringFromCGPoint(CGPointMake(b, w))];
    }
 
	currentWaxPoint = CGPointFromString([maskCoords objectAtIndex:jarRect.size.height-default_wax_shift]);
	
	free(rgbImage);
	
//	candlesView.jar.image.scale = 2;
//	[candlesView.jar setNeedsDisplay];
	
//	NSLog(@"candlesView.jar.image size %@", NSStringFromCGSize(candlesView.jar.image.size));
	
//	candlesView.jar.image = [UIImage imageWithCGImage:candlesView.jar.image.CGImage scale:0.5 orientation:candlesView.jar.image.imageOrientation];	
//	candlesView.jar.image = nil;
//	return img;
////////////////////	
	UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_width*sf, m_height*sf)];
	myView.backgroundColor = [UIColor blackColor];
	UIGraphicsBeginImageContext(myView.bounds.size);
	[myView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImage *imgblack = [ImageUtils maskImage:viewImage withMask:maskImage];
	
//	imgblack = [ImageUtils putImage:i atPoint:CGPointMake(0, imgblack.size.height-i.size.height) onImage:imgblack];
	
	CGRect topRect;
	if (sf > 1) {
		topRect = CGRectMake(candlesView.blackMaskTop.frame.origin.x*sf, candlesView.blackMaskTop.frame.origin.y*sf,
							 candlesView.blackMaskTop.frame.size.width*sf, candlesView.blackMaskTop.frame.size.height*sf);
		imgblack = [ImageUtils imageByCropping:imgblack toRect:CGRectMake(0, topImage.size.height*sf, imgblack.size.width*sf, (imgblack.size.height-topImage.size.height)*sf)];
	} else {
		topRect = candlesView.blackMaskTop.bounds;
		imgblack = [ImageUtils imageByCropping:imgblack toRect:CGRectMake(0, topImage.size.height, imgblack.size.width, imgblack.size.height-topImage.size.height)];
	}
	
	
	UIView *bw = [[UIView alloc] initWithFrame: topRect ];
	bw.backgroundColor = [UIColor blackColor];
	topImage = [ImageUtils maskImage:[ImageUtils getImageFromView:bw] withMask:[ImageUtils loadNativeImage:[NSString stringWithFormat:@"jars_add/%@_top_mask.png", currentJarName]]];
	[bw release];
	
	
	UIImage *untopImage;
	if (sf > 1) {
		CGRect jr = CGRectMake(0, 0, candlesView.topMask.frame.size.width*sf, candlesView.topMask.frame.size.height*sf);
		untopImage = [ImageUtils imageByCropping:candlesView.jar.image toRect: jr];
	} else {
		untopImage = [ImageUtils imageByCropping:candlesView.jar.image toRect: candlesView.topMask.bounds];
	}
	
	
	topImage = [ImageUtils putImage:untopImage atPoint:CGPointMake(0, 0) onImage:topImage];

	
	
//	candlesView.blackMaskTop.image = topImage;
//	candlesView.blackMaskTop.hidden = YES;
//	candlesView.blackMaskTop.backgroundColor = [UIColor redColor];
	

	imgblack = [ImageUtils putImage:inv atPoint:CGPointMake(0, 0) onImage:imgblack];
	
	candlesView.blackMask.image = imgblack;
//	NSLog(@"candlesView.mask.frame %@", NSStringFromCGRect(candlesView.mask.frame));
	
	candlesView.blackMask.frame = candlesView.mask.frame;
//	candlesView.blackMask.hidden = YES;
	[myView release];

	
//	candlesView.barItemsView.userInteractionEnabled = YES;
//	candlesView.noTouch.hidden = YES;
//	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(canTouch) userInfo:nil repeats:NO];

	[[UIApplication sharedApplication] endIgnoringInteractionEvents];

	
	NSLog(@"generate mask finished");

	return img;
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	NSLog(@"candles controller dealloc");
	self.backgroundTrack = nil;
	[pouringSound release];
	[saveSound release];
	[startLightingSound release];
	[lightingSound release];
	[smokeSound release];
	self.meltAnimationImages = nil;
	self.waxNames = nil;
	self.meltImage = nil;
	self.addinsViews = nil;
	self.photosViews = nil;
	self.waxes = nil;
	self.jars = nil;
	self.addins = nil;
	self.maskCoords = nil;
	self.fonts = nil;
	self.fontNames = nil;
	self.photos = nil;
	self.bedzViews = nil;
	self.bedz = nil;
	self.colors = nil;
	self.flames = nil;
	self.wicksView = nil;
	self.photoCategoriesItems = nil;
	[textField release];
	self.musicPlayer = nil;
/// save
	self.currentJarName = nil;
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[facebook release];
    [super dealloc];
}


@end
