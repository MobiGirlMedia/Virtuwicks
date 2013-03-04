//
//  Utils.m
//  Universal
//
//  Created by Sergey Kopanev on 5/3/10.
//  Copyright 2010 milytia. All rights reserved.
//

#import "Utils.h"


@implementation Utils

+ (BOOL) runningUnderiPad {
	NSString *modelName = [[UIDevice currentDevice] model];
	return [modelName rangeOfString: @"iPad"].location != NSNotFound;
}

+ (NSString *) documentsDirectory {
	static NSString* dPath = nil;
	if (!dPath) {
		dPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
		[dPath retain];
	}
	return dPath;	
}

+ (NSString *) imagesDirectory {
	static NSString* dPath = nil;
	if (!dPath) {
		dPath = [NSString stringWithFormat: @"%@/images", [Utils documentsDirectory]];
		if (![[NSFileManager defaultManager] fileExistsAtPath: dPath]) {
			[[NSFileManager defaultManager] createDirectoryAtPath: dPath
									  withIntermediateDirectories: NO
													   attributes: nil
															error: nil];
		}
		[dPath retain];
	}
	return dPath;	
}

+ (NSString *) s: (NSString *) s df: (NSString *) df {
	return s ? s : df;
}

+ (void) showAlertTitle: (NSString *) t message: (NSString *) mess {
	UIAlertView * a = [[UIAlertView alloc] initWithTitle: t
												 message: mess
												delegate: nil
									   cancelButtonTitle: @"OK"
									   otherButtonTitles: nil];
	[a show];
	[a release];
}

+ (UIView *) waitingView: (CGRect) fr {
	UIView * v = [[UIView alloc] initWithFrame: fr];
	v.userInteractionEnabled = YES;
	v.backgroundColor = [UIColor colorWithRed: 0
										green: 0
										 blue: 0
										alpha: 0.6];
	
	float is = 35;
	UIActivityIndicatorView * iv = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(fr.size.width * .5 - is * .5, fr.size.height * .5 - is * .5, is, is)];
	[iv startAnimating];
	iv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[v addSubview: iv];
	[iv release];
	
	UILabel * lbl = [[UILabel alloc] initWithFrame: CGRectMake(0, fr.size.height * .5 + is * 1.1, fr.size.width, 20)];
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textColor = [UIColor whiteColor];
	lbl.font = [UIFont boldSystemFontOfSize: 12];
	lbl.text = @"please wait...";
	lbl.textAlignment = UITextAlignmentCenter;
	[v addSubview: lbl];
	[lbl release];
	
	return v;
}

#pragma mark arrays && dicts

+ (NSMutableArray *) arrayOfArrays: (NSMutableArray *) givenArray splitNum: (int) splitNum {
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

+ (NSMutableArray *) urlsArrayFromText: (NSString *) text {
	NSMutableArray *a = [NSMutableArray array];
	//	NSLog(@"text %@", text);
	NSString *t = [text lowercaseString];
	NSString *s = @"www.";
	NSRange r, nr;
	r.location = 0;
	r.length = [t length];
	
	nr = [t rangeOfString:s options:0 range:r];
	while (nr.location != NSNotFound) {
		r.location = nr.location+nr.length;
		r.length = [t length] - r.location;
		NSString *res = [Utils getDataForCharacter:nr.location fromData:text];
		
		
		NSRange range = [res rangeOfString:@"http://"];
		if (range.location == NSNotFound) {
			res = [NSString stringWithFormat:@"http://%@", res];
		}
		[a addObject:res];
		nr = [t rangeOfString:s options:0 range:r];
		
	}
	
	r.location = 0;
	r.length = [t length];
	s = @"http://";
	nr = [t rangeOfString:s options:0 range:r];
	while (nr.location != NSNotFound) {
		r.location = nr.location+nr.length;
		r.length = [t length] - r.location;
		NSString *res = [Utils getDataForCharacter:nr.location fromData:text];
		[a addObject:res];
		nr = [t rangeOfString:s options:0 range:r];
	}
	return a;
}

#pragma mark Strings

/* 
 Name	Character	Unicode code point (decimal)	Standard	Description
 quot	"			U+0022	(34)	XML 1.0			(double) quotation mark
 amp		&			U+0026	(38)	XML 1.0			ampersand
 apos	'			U+0027	(39)	XML 1.0			apostrophe (= apostrophe-quote)
 lt		<			U+003C	(60)	XML 1.0			less-than sign
 gt		>			U+003E	(62)	XML 1.0			greater-than sign
 */
+ (NSString *) replaceSpecialCharacters: (NSString *) str {
	static NSArray * charsArray = nil;
	if (!charsArray) {
		charsArray = [[NSArray alloc] initWithObjects:
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"&#034;", @"sc", // spec char
					   @"\"", @"rs", // replace symbol
					   nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"&#038;", @"sc", // spec char
					   @"&", @"rs", // replace symbol
					   nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"&#039;", @"sc", // spec char
					   @"'", @"rs", // replace symbol
					   nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"&#060;", @"sc", // spec char
					   @"<", @"rs", // replace symbol
					   nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"&#062;", @"sc", // spec char
					   @">", @"rs", // replace symbol
					   nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:
					   @"&amp;", @"sc", // spec char
					   @"&", @"rs", // replace symbol
					   nil],
					  nil];
	}
	for (NSDictionary * d in charsArray) {
		str = [str stringByReplacingOccurrencesOfString: [d objectForKey: @"sc"]
											 withString: [d objectForKey: @"rs"]];
	}
	return str;
}

+ (NSString *) getDataForCharacter: (int) c fromData: (NSString*) content {
	NSMutableString *thumb = [NSMutableString string];
	int shift = c;
	while (shift < [content length] &&
		   [content characterAtIndex:shift] != ' ' &&
		   [content characterAtIndex:shift] != '\n') {
		[thumb appendFormat:@"%C", [content characterAtIndex:shift]];
		shift++;
	}
	return thumb;	
}

+ (NSString *) embedYouTube:(NSString *)urlString frame:(CGRect)frame {
	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	
	NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
	return html;	
}

@end
