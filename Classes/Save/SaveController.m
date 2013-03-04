    //
//  SaveController.m
//  candles
//
//  Created by Sergey Kopanev on 2/28/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "SaveController.h"
#import "SaveView.h"
#import "SavePageView.h"

@implementation SaveController

@synthesize candleObjects, nav, facebook, logintToFaceSelector, target, fbsi;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		if ([Utils runningUnderiPad]) {
			saveView = [[SaveView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		} else {
			saveView = [[SaveView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		}
		self.view = saveView;
		[saveView.homeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
		[saveView release];
		saveView.scrollView.delegate = self;
		
		self.candleObjects = [NSMutableArray array];
		currentIndex = 0;
		views = [[NSMutableArray alloc] init];
		
    }
    
    ad = [[MGAd alloc] initForBannerWithSecret:kAdSecret origin:CGPointZero orientation:UIInterfaceOrientationPortrait];
    [ad showAdsOnViewController:self];

    
    return self;
}

- (void) addObjectToSave: (NSMutableDictionary*) d {
//	NSLog(@"state %@", d);
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}


- (void) hide {
//	NSLog(@"hide savecontroller %@", nav);
//	[nav dismissModalViewControllerAnimated:YES];
//	self.view = nil;
	[self.navigationController popViewControllerAnimated:NO];
}

- (NSMutableArray*) remove2x: (NSArray*) f {
    NSMutableArray *a = [NSMutableArray array];
    for (NSString *s in f) {
        if (NSNotFound == [s rangeOfString:@"@2x"].location) {
            [a addObject:s];
        }
    }
    return a;
}

- (void) getSavedObjects {
	/// parse, loading from disc previously saved candles
//	if (candleObjects) {
//		[candleObjects removeAllObjects];
//	} else {
		self.candleObjects = [NSMutableArray array];
//	}
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *path = [NSString stringWithFormat:@"%@/candles", [Utils documentsDirectory]];
	NSArray *f = [fm contentsOfDirectoryAtPath:path error:nil];
    f = [self remove2x:f];
	
/// checker
	BOOL isDir;
	NSMutableArray *a = [NSMutableArray array];
	
#ifdef LITE
	[a addObject:kLiteKey];
#endif
	
	for (NSString *s in f) {
		NSString *p = [NSString stringWithFormat:@"%@/%@", path, s];
		if ([fm fileExistsAtPath:p isDirectory:&isDir] && isDir) {
			if ( [fm fileExistsAtPath:[NSString stringWithFormat:@"%@/candle", p]]) {		/// if candle file exists
				[a addObject:s];
			}
		}
	}
	if (![a count]) {
		[self hide];
		return;
	};
	self.candleObjects = [self arrayOfArrays:a splitNum:9];
//	NSLog(@"candle %@", candleObjects);
	[self setToIndex:currentIndex];
}

- (void) prepareToView {
	
	int w;
	int h;
	if ([Utils runningUnderiPad]) {
		w = 768;
		h = 1024;
	} else {
		h = 480;
		w = 320;
	}
	
	
	for (int i=0; i< [views count]; i++) {
		SavePageView * v = [views objectAtIndex:i];
		v.center = CGPointMake(i * w + w/2, h * .5);
		saveView.scrollView.contentOffset = CGPointMake(w, 0);
		saveView.scrollView.contentSize = CGSizeMake(w*3, 0);
	}
	
	if ([candleObjects count] <= 1) {
		saveView.scrollView.contentOffset = CGPointMake(0, 0);
		saveView.scrollView.contentSize = CGSizeMake(w, 0);
	}
	
}

- (void) scrollLeft {
	
	currentIndex--;
	if (currentIndex < 0) {
		currentIndex = [candleObjects count]-1;
	} else if (currentIndex >= [candleObjects count]) {
		currentIndex = 0;
	}
	int li;
	if (currentIndex-1 < 0) {
		li = [candleObjects count]-1;
	} else {
		li = currentIndex-1;
	}
	
	[[views lastObject] removeFromSuperview];
	[views removeLastObject];
	[views insertObject:[self createPageWithData: [candleObjects objectAtIndex:li]] atIndex:0];
	[self prepareToView];
}

- (void) scrollRight {
	currentIndex++;
	if (currentIndex < 0) {
		currentIndex = [candleObjects count]-1;
	} else if (currentIndex >= [candleObjects count]) {
		currentIndex = 0;
	}
	int ri;
	if (currentIndex+1 >= [candleObjects count]) {
		ri = 0;
	} else {
		ri = currentIndex+1;
	}
	
	[[views objectAtIndex:0] removeFromSuperview];
	[views removeObjectAtIndex:0];
	[views addObject:[self createPageWithData:[candleObjects objectAtIndex:ri]]];
	[self prepareToView];
	
	
	
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	saveView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	saveView.userInteractionEnabled = YES;
	if ([Utils runningUnderiPad]) {
		if (saveView.scrollView.contentOffset.x > 768) {	/// shift to right
			[self scrollRight];
		} else if (saveView.scrollView.contentOffset.x < 768) {
			[self scrollLeft];
		}
	} else {
		if (saveView.scrollView.contentOffset.x > 320) {	/// shift to right
			[self scrollRight];
		} else if (saveView.scrollView.contentOffset.x < 320) {
			[self scrollLeft];
		}
	}
}

- (void) setToIndex: (int) index {
	currentIndex = index;
	for (UIView *v in views) {
		[v removeFromSuperview];
	}
	
	[views removeAllObjects];
	//	NSLog(@"plane index %d", currentIndex);
	if (currentIndex < 0) {
		currentIndex = [candleObjects count]-1;
	} else if (currentIndex >= [candleObjects count]) {
		currentIndex = 0;
	}
	
	int li, ci, ri;
	
	
	if (currentIndex-1 < 0) {
		li = [candleObjects count]-1;
	} else {
		li = currentIndex-1;
	}
	
	ci = currentIndex;
	
	if (currentIndex+1 >= [candleObjects count]) {
		ri = 0;
	} else {
		ri = currentIndex+1;
	}
	
	// load current image first!
	SavePageView * czv = [self createPageWithData: [candleObjects objectAtIndex:ci]];
	
	[views addObject:[self createPageWithData:[candleObjects objectAtIndex:li]]];
	[views addObject: czv];
	[views addObject:[self createPageWithData:[candleObjects objectAtIndex:ri]]];
	
	[self prepareToView];
}

- (void) deleteItem: (SmartImageView*) si {
	NSLog(@"delete item %@", si.name);
	
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[NSString stringWithFormat:@"%@/candles/%@", [Utils documentsDirectory], si.name] error:nil];
	[self getSavedObjects];
}


- (SavePageView*) createPageWithData: (NSMutableArray*) data {
	int w;
	int h;
	if ([Utils runningUnderiPad]) {
		w = 768;
		h = 1024;
	} else {
		h = 480;
		w = 320;
	}
	SavePageView *sp = [[SavePageView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
	[saveView.scrollView addSubview:sp];
	sp.target = self;
	sp.deleteItemSelector = @selector(deleteItem:);
	sp.sendImage = @selector(sendEmailImage:);
	sp.postToFaceBook = @selector(loginToFace:);
//	sp.postToFTP = @selector(uploadToFtp:);
	sp.sendUsImage = @selector(sendEmailToUsImage:);
	[sp release];
	[sp setContent: data];
	
//	NSLog(@"create! but %d", [views count]);
	
	return sp;
}

- (NSMutableArray *) arrayOfArrays: (NSMutableArray *) givenArray splitNum: (int) splitNum {
	NSMutableArray * arrayOfArrays = [NSMutableArray array];
	for (int i = 0; i < [givenArray count] / splitNum + 1; i++) {
		NSMutableArray *na = [NSMutableArray array];
		for (int j = 0; j < splitNum; j++) {
			int index = i * splitNum + j;
			if (index < [givenArray count]) {
				[na addObject: [givenArray objectAtIndex:index]];
			} else {
				break;
			}
		}
		if ([na count]) {
			[arrayOfArrays addObject:na];
		}
	}
	return arrayOfArrays;
}

//Don't forget to  tell us your name and city!

#pragma mark email delegate

- (void) sendEmailToUsImage: (SmartImageView*) si {
	MFMailComposeViewController * mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
	
	[mail setSubject: @"here is my virtuwicks submission!"];
	[mail setToRecipients:[NSArray arrayWithObject:@"info@appsnminded.com"]];
	
	NSMutableString *body = [NSMutableString stringWithString:@"Here is my VirtuWicks for consideration for the Hall of Flame!\n\n\n"];
	
	[body appendString:@"My Name: \n"];
	[body appendString:@"My Hometown: \n"];
	[body appendString:@"My Wicks Description: \n"];

	
	
	[mail setMessageBody:body  isHTML: NO]; 
	[mail addAttachmentData: UIImagePNGRepresentation(si.image)
				   mimeType: @"image/png"
				   fileName: @"myvirtuwick.png"];
	
	[nav presentModalViewController: mail
						   animated:YES];
	[mail release];
}

- (void) sendEmailImage: (SmartImageView*) si {
	MFMailComposeViewController * mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
	
	[mail setSubject: @"I made this VirtuWicks for you!"];
	NSMutableString *emailBody = [NSMutableString stringWithString:@"<html><body>"];
    [emailBody appendString:@"<p>I made this VirtuWicks candle for you. Enjoy!</p>"];
  //  UIImage *emailImage = [ImageUtils loadNativeImage:@"email-icon.png"];
 //   NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
//    NSString *base64String = [imageData base64EncodedString];
	[emailBody appendString:@"Look for us in the App Store!"];
 //   [emailBody appendString:[NSString stringWithFormat:@"<p><b><a href=\"http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?entity=software&media=all&page=1&restrict=true&startIndex=0&term=appsnminded\"><img src='data:image/png;base64,%@'></b></p>", base64String]];
//	NSString *link = @"http://click.linksynergy.com/fs-bin/click?id=IRnqa4K4BNk&subid=&offerid=146261.1&type=10&tmpid=3909&RD_PARM1=http%3A%2F%2Fhttp%3A%2F%2Fitunes.apple.com%2Fus%2Fapp%2Fvirtuwicks-candle-maker%2Fid428116156%3Fmt%3D8";
	
	NSString *url;
	if ([Utils runningUnderiPad]) {
		url = full_link;
	} else {
		url = full_link_iphone;
	}

	[emailBody appendString:[NSString stringWithFormat:@"<p><b><a href=\"%@\"><img src=\"http://appsnminded.com/images/email-icon.png\"></b></p>", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [emailBody appendString:@"</body></html>"];
     	
	
//	NSLog(@"lenght %d", [emailBody length]);
	
	[mail setMessageBody:emailBody  isHTML: YES]; 
	[mail addAttachmentData: UIImagePNGRepresentation(si.image)
				   mimeType: @"image/png"
				   fileName: @"myvirtuwick.png"];
	
	[nav presentModalViewController: mail
							animated:YES];
	[mail release];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	[nav dismissModalViewControllerAnimated: YES];
//	[nav popViewControllerAnimated:NO];
}

#pragma mark Facebook Delegate

- (void) loginToFace: (SmartImageView*) _si {
//	[target performSelector:logintToFaceSelector withObject:_si];
	self.fbsi = _si;
	[saveView addControl:YES];
//	saveView.scrollView.userInteractionEnabled = NO;
	[facebook authorize: kFacebookAppId
			permissions: [NSArray arrayWithObjects:@"read_stream", @"publish_stream", nil]
			   delegate: self];
	
}

- (void) fbDidLogin {
	NSLog(@"fb: did login");
	[self postImage];
}

- (void) postImage {
	
	NSLog(@"si %@", fbsi);
	
//	NSLog(@"%@ ", si, si.image, NSStringFromCGSize(si.image.size));
	
	UIImage *i = [UIImage imageWithData:UIImageJPEGRepresentation(fbsi.image, 0.8)];
	self.fbsi = nil;
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   //								   [NSURL URLWithString:path], @"source", 
								   //								   takedPhoto, @"source",
								   //								   @"http://kneesntoads.com/files/forman.png", @"picture",
								   @"This candle was created with the virtuwicks app!", @"message",
								   //								   @"description", @"description",
								   @"This candle was created with the virtuwicks app!", @"caption",
								   i, @"picture",
								   nil];
	[facebook requestWithGraphPath:@"/me/photos" andParams:params
					 andHttpMethod:@"POST" andDelegate:self];
}


- (void) fbDidNotLogin {
	NSLog(@"fb: did not login");
	self.fbsi = nil;
	[facebook logout: self];
	[self postFailed];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	NSLog(@"fb: request failed");
	[self postFailed];
}

- (void) postFailed {
	NSLog(@"post failed");
//	saveView.scrollView.userInteractionEnabled = YES;
	[saveView addControl:NO];
	UIAlertView * a = [[UIAlertView alloc] initWithTitle: @"ooops !"
												 message: @"candle post failed"
												delegate: self 
									   cancelButtonTitle: @"Ok"
									   otherButtonTitles: nil]; 
	
	[a show]; 
	[a release]; 
	
}

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([result isKindOfClass: [NSDictionary class]] && [result objectForKey: @"id"]) {
		//		[[showAppDelegate getInstance] lockWindow: NO];
		NSLog(@"post succes");
//		saveView.scrollView.userInteractionEnabled = NO;
		[saveView addControl:NO];
		UIAlertView * a = [[UIAlertView alloc] initWithTitle: @"Congratulations !"
													 message: @"candle posted successfuly"
													delegate: self 
										   cancelButtonTitle: @"Ok"
										   otherButtonTitles: nil]; 
		
		[a show]; 
		[a release]; 
		
	} else {
		NSLog(@"[Poses::request:didLoad:] show shit!");
		
	} 
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"dealloc: save controller");
	self.candleObjects = nil;
	self.fbsi = nil;
	[views release];
    [ad stopAds]; [ad release];
    [super dealloc];
}


@end
