//
//  WaxView.m
//  Candles
//
//  Created by Sergey Kopanev on 2/2/11.
//  Copyright 2011 Knees & Toads. All rights reserved.
//

#import "WaxView.h"


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
			
			return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:1.0 orientation:UIImageOrientationUp];
        }
    }
	
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path {
	//   return [[UIImage alloc] initWithContentsOfResolutionIndependentFile:path];
    return [[[UIImage alloc] initWithContentsOfResolutionIndependentFile:path] autorelease];
}

@end

@implementation WaxView

@synthesize heigth, currentPoint, startPoint, bottomPoint, name, largePic, bottomPic, animationImages, canDraw;

- (NSMutableArray*) remove2x: (NSArray*) f {
    NSMutableArray *a = [NSMutableArray array];
    for (NSString *s in f) {
        if (NSNotFound == [s rangeOfString:@"@2x"].location) {
            [a addObject:s];
        }
    }
    return a;
}

- (id)initWithFrame:(CGRect)frame andName: (NSString*) _name {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.name = [NSString stringWithFormat:@"wax/%@", _name];
        self.backgroundColor = [UIColor clearColor];
		
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *path = [NSString stringWithFormat:@"%@/%@/%@/ell", [[NSBundle mainBundle ]bundlePath], [ImageUtils getFodler], name];
		NSArray *f = [fm contentsOfDirectoryAtPath:path error:nil];
        f = [self remove2x:f];
		self.animationImages = [NSMutableArray array];
		for (NSString *s in f) {
			[animationImages addObject:[ImageUtils loadNativeImage:[NSString stringWithFormat:@"%@/ell/%@", name, s]]];
		}
		waxNumber = 0;
//		NSLog(name);
//		NSString *path1 = [NSString stringWithFormat:@"%@/iphoneImages/%@/wax.png", [[NSBundle mainBundle] bundlePath], name];
//		NSLog(path1);
//		self.largePic = [UIImage imageWithContentsOfResolutionIndependentFile: path1];
		
		self.largePic = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"%@/wax.png", name]];
		
		NSLog(@"wax %@ %f", NSStringFromCGSize(largePic.size), largePic.scale);
		
		self.bottomPic = [ImageUtils loadNativeImage:[NSString stringWithFormat:@"%@/bottom.png", name]];
		canDraw = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	if (!canDraw) return;
//	NSLog(@"draw %@ %@", name, NSStringFromCGSize(largePic.size));
	CGContextRef _context = UIGraphicsGetCurrentContext();
	CGRect rectOfPicToLoad = CGRectMake(0, largePic.size.height, largePic.size.width, -heigth+startPoint);
//	CGRect rectOfPicToLoad = CGRectMake(0, largePic.size.height-heigth, largePic.size.width, startPoint);
//	CGRect rectOfPicToLoad = CGRectMake(0, 0, 100, 100);
	
//	NSLog(@"h %d, rect %@", (int) heigth, NSStringFromCGRect(rectOfPicToLoad));
	
	_context = UIGraphicsGetCurrentContext();
	int hh = self.frame.size.height;
	int ww = self.frame.size.width;
	CGContextTranslateCTM(_context, ww/2, hh/2);
	CGContextScaleCTM(_context, 1, -1);
	
	CGContextTranslateCTM(_context, -ww/2, -hh/2);
	
	CGImageRef _imageRef = CGImageCreateWithImageInRect(largePic.CGImage, rectOfPicToLoad);
	
	
//	NSLog(@"_imageRef %@", _imageRef);
	CGContextDrawImage(_context, CGRectMake(0.0, startPoint, self.frame.size.width,  heigth-startPoint), _imageRef);
	CGImageRelease(_imageRef);

	int w = bottomPoint.y;
	int x = bottomPoint.x;

	/// bottom
	rectOfPicToLoad = CGRectMake(0, 0, bottomPic.size.width, bottomPic.size.height);
	_imageRef = CGImageCreateWithImageInRect(bottomPic.CGImage, rectOfPicToLoad);
	CGRect rectBottom = CGRectMake(x, startPoint-rectOfPicToLoad.size.height, w, rectOfPicToLoad.size.height);
	CGContextDrawImage(_context, rectBottom, _imageRef);
	CGImageRelease(_imageRef);	
	
	
/// animation	
	waxNumber++;
	if (waxNumber >= [animationImages count]) waxNumber = 0;
	UIImage *image = [animationImages objectAtIndex:waxNumber];
	rectOfPicToLoad = CGRectMake(0, 0, image.size.width, image.size.height);
	_imageRef = CGImageCreateWithImageInRect(image.CGImage, rectOfPicToLoad);
	w = currentPoint.y;
	x = currentPoint.x;
	CGContextDrawImage(_context, CGRectMake(x, heigth - rectOfPicToLoad.size.height/2, w, rectOfPicToLoad.size.height), _imageRef);
	CGImageRelease(_imageRef);



}


- (void)dealloc {
	NSLog(@"WaxView dealoc");
	self.animationImages = nil;
	self.largePic = nil;
	self.bottomPic = nil;
	self.name = nil;
    [super dealloc];
}


@end
