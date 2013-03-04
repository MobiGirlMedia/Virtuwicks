//
//  ImageUtils.m
//  Universal
//
//  Created by Sergey Kopanev on 5/3/10.
//  Copyright 2010 milytia. All rights reserved.
//

#import "ImageUtils.h"


@implementation ImageUtils

+ (UIImage*) loadImage:(NSString*)name inFolder:(NSString*)folder {
	NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[[NSBundle mainBundle] bundlePath], folder, name];
//	NSLog(@"loading image %@", name);
	UIImage *img = [UIImage imageWithContentsOfFile:path];
	if (!img) NSLog(@"File not loaded ! %@", path);
	return img;
}

+ (NSString*) getFodler {
	if (![Utils runningUnderiPad]) {
#ifdef LITE
		return @"iphoneImagesmini";
#else
		return @"iphoneImages";
#endif
	}
	return @"images";
}

+ (UIImage*) loadNativeImage:(NSString*) name {
	
	
	
	NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[[NSBundle mainBundle] bundlePath], [ImageUtils getFodler], name];
//    NSLog(@"loading image %@", name);
	UIImage *img = [UIImage imageWithContentsOfFile:path];
	if (!img) NSLog(@"File not loaded ! %@", path);
	return img;
}




+ (NSString*) getDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex: 0];	
}

+ (UIImage *) putImage: (UIImage*) frontImage atPoint: (CGPoint) p onImage: (UIImage*) backImage {
	
//	NSLog(@"put %@ %@", NSStringFromCGSize(frontImage.size), NSStringFromCGSize(backImage.size));
	
	CGImageRef fIm = frontImage.CGImage;
	CGImageRef bIm = backImage.CGImage;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef cgctx = CGBitmapContextCreate(NULL, 
											   backImage.size.width, 
											   backImage.size.height, 
											   8, 0, 
											   colorSpace, kCGImageAlphaPremultipliedLast); 
	if (cgctx == NULL) { 
		printf("cgtx error \n");
		return nil;
	}
	
	size_t w = backImage.size.width; 
	size_t h = backImage.size.height;
	CGRect rect = {{0,0},{w,h}}; 
	CGContextDrawImage(cgctx, rect, bIm);
	CGRect rect2 = {{p.x, p.y}, {frontImage.size.width, frontImage.size.height}};
	CGContextDrawImage(cgctx, rect2, fIm);
	CGImageRef imageRef = CGBitmapContextCreateImage (cgctx);
	UIImage * newImage = [UIImage imageWithCGImage: imageRef];
	CGImageRelease(imageRef);
	CGContextRelease(cgctx);
	CGColorSpaceRelease( colorSpace );
	return newImage;
}



+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {
	
//	NSLog(@"reci %@", imageToCrop);
//	NSLog(@"rec %@, %d", imageToCrop.CGImage, CGImageGetWidth(imageToCrop.CGImage));
	
	CGImageRef cropped = CGImageCreateWithImageInRect(imageToCrop.CGImage, rect);
//	NSLog(@"rec %@", cropped);
	UIImage *retImage = [UIImage imageWithCGImage: cropped];
	CGImageRelease(cropped);
	return retImage;
}

+ (UIImage*) image: (UIImage*) img zoomedToWidth: (float) width croppedByHeight: (float) height {
	float newImageHeight = width * img.size.height / img.size.width;
	UIImage *timg = [ImageUtils imageWithImage: img scaledToSize: CGSizeMake(width, newImageHeight)];
	UIImage *rImg = [ImageUtils imageByCropping: timg toRect: CGRectMake(0, 0, width, height)];
	return rImg;
}

+ (UIImage*) generateImageWithSize: (CGSize) size {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	size_t m_width = size.width; // CGImageGetWidth(inImage);
	size_t m_height = size.height; // CGImageGetHeight(inImage);

	uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));

	memset(rgbImage, 0x00, m_width * m_height * sizeof(uint32_t));
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
	
	if (context == NULL) { 
		printf("generateImageWithSize cgtx error \n");
		free(rgbImage);
		CGColorSpaceRelease( colorSpace );
		return nil;
	}
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *newImage = [[[UIImage imageWithCGImage: imageRef] retain] autorelease];
	CGImageRelease(imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease( colorSpace );
	free(rgbImage);
	return newImage;
}


// temprary here =)
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	CGImageRef inImage = image.CGImage;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef cgctx = CGBitmapContextCreate(NULL, newSize.width, newSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast); 
	if (cgctx == NULL) { 
		printf("imageWithImage cgtx error \n");
		return nil;
	}
	
	size_t w = newSize.width; // CGImageGetWidth(inImage);
	size_t h = newSize.height; // CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	CGContextDrawImage(cgctx, rect, inImage); 
	CGImageRef imageRef = CGBitmapContextCreateImage (cgctx);
	UIImage *newImage = [UIImage imageWithCGImage: imageRef];
	CGImageRelease(imageRef);
	CGContextRelease(cgctx);
	CGColorSpaceRelease( colorSpace );
	return newImage;
}

+ (UIImage*) partOfImage: (UIImage*) img croppedToSize: (CGSize) size {
	BOOL cropByWidth = img.size.width < img.size.height;
	
	float wRatio = size.width / img.size.width;
	float hRatio = size.height / img.size.height;
	float ratio = cropByWidth ? wRatio : hRatio;
	
	UIImage *croppedImg = [ImageUtils imageWithImage: img 
									scaledToSize: CGSizeMake(img.size.width * ratio, img.size.height * ratio)];
	croppedImg = [ImageUtils imageByCropping: croppedImg toRect: CGRectMake(0, 0, size.width, size.height)];
	return croppedImg;
}

+ (UIImage *) convertToGreyscale:(UIImage *)i {
	
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
	
    int colors = kGreen;
    int m_width = i.size.width;
    int m_height = i.size.height;
	
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
			uint32_t rgbPixel=rgbImage[y*m_width+x];
			uint32_t sum=0,count=0;
			if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
			if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
			if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
			m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
	
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
	
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
	
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
	
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
	
    return resultUIImage;
}

/*
CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
	CGImageRef retVal = NULL;
	
	size_t width = CGImageGetWidth(sourceImage);
	size_t height = CGImageGetHeight(sourceImage);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char *m = malloc(width*height*4);
	memset(m, 255, width*height*4);
	
	CGContextRef offscreenContext = CGBitmapContextCreate(m, width, height, 
														  8, width*4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	if (offscreenContext != NULL) {
		CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
		
		retVal = CGBitmapContextCreateImage(offscreenContext);
		CGContextRelease(offscreenContext); -------------- NO RELEASE !!!!!!
	}
	
	for (int i=0; i< height/2; i++) {
		NSMutableString *s = [NSMutableString string];
		for (int j=0; j< width; j++) {
//			[s appendFormat:@"%02x", m[i*width + j * 4 + 0x00]];
//			[s appendFormat:@"%02x", m[i*width + j * 4 + 0x01]];
//			[s appendFormat:@"%02x", m[i*width + j * 4 + 0x02]];
			[s appendFormat:@"%02x", m[i*width + j * 4 + 0x03]];
		}
//		printf("%s", [s UTF8String]);
		NSLog(@"%@", s);
	}

	free(m);
	
	CGColorSpaceRelease(colorSpace);
	
	return retVal;
}
*/
/*
+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
	UIGraphicsBeginImageContext(image.size);
	
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // Draw some vectorial data
    // ...
    // Apply an image mask 
    CGImageRef maskRef = maskImage.CGImage; 
    CGImageRef cgmask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                          CGImageGetHeight(maskRef),
                                          CGImageGetBitsPerComponent(maskRef),
                                          CGImageGetBitsPerPixel(maskRef),
                                          CGImageGetBytesPerRow(maskRef),
                                          CGImageGetDataProvider(maskRef), NULL, false);
	NSLog(@"%@", cgmask);
    CGImageRef masked = CGImageCreateWithMask([UIGraphicsGetImageFromCurrentImageContext() CGImage], cgmask);
    CGImageRelease(cgmask);
	
    image = [UIImage imageWithCGImage:masked];

	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithCGImage:masked])];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/img.png", [Utils documentsDirectory]] atomically:YES];
//	imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithCGImage:masked])];
//	[imageData writeToFile:[NSString stringWithFormat:@"%@/masked.png", [Utils documentsDirectory]] atomically:YES];

	
	CGImageRelease(masked);
	
    UIGraphicsEndImageContext();
	return image;
}
*/
/*
+ (UIImage*)maskImage:(UIImage*)image withMask:(UIImage*)maskImage {

	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/i.png", [Utils documentsDirectory]] atomically:YES];
	imageData = [NSData dataWithData:UIImagePNGRepresentation(maskImage)];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/m.png", [Utils documentsDirectory]] atomically:YES];
	
	UIGraphicsBeginImageContext(image.size);
	CGImageRef maskRef = maskImage.CGImage;
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), NULL, false);
	CGImageRef masked = CGImageCreateWithMask(image.CGImage, mask);
	imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithCGImage:masked])];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/img.png", [Utils documentsDirectory]] atomically:YES];

	UIImage* result = [UIImage imageWithData:UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext())];
	UIGraphicsEndImageContext();
	CGImageRelease(mask);
	CGImageRelease(masked);
	return result;
}
*/

/*
CGImageRef createMaskWithImage(CGImageRef image)
{
    int maskWidth               = CGImageGetWidth(image);
    int maskHeight              = CGImageGetHeight(image);
    //  round bytesPerRow to the nearest 16 bytes, for performance's sake
    int bytesPerRow             = (maskWidth + 15) & 0xfffffff0;
    int bufferSize              = bytesPerRow * maskHeight;
	
    //  allocate memory for the bits 
    CFMutableDataRef dataBuffer = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CFDataSetLength(dataBuffer, bufferSize);
	
    //  the data will be 8 bits per pixel, no alpha
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef ctx            = CGBitmapContextCreate(CFDataGetMutableBytePtr(dataBuffer),
                                                        maskWidth, maskHeight,
                                                        8, bytesPerRow, colourSpace, kCGImageAlphaNone);
    //  drawing into this context will draw into the dataBuffer.
    CGContextDrawImage(ctx, CGRectMake(0, 0, maskWidth, maskHeight), image);
    CGContextRelease(ctx);
	
    //  now make a mask from the data.
    CGDataProviderRef dataProvider  = CGDataProviderCreateWithCFData(dataBuffer);
    CGImageRef mask                 = CGImageMaskCreate(maskWidth, maskHeight, 8, 8, bytesPerRow,
                                                        dataProvider, NULL, FALSE);
	
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colourSpace);
    CFRelease(dataBuffer);
	
    return mask;
}
*/
+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
	
	
//	NSLog(@"sizes %@, %@", NSStringFromCGSize(image.size), NSStringFromCGSize(maskImage.size));
	
	CGImageRef sourceImage = image.CGImage;
	CGImageRef mask = maskImage.CGImage;
	CGImageRef retVal = NULL;
	size_t width = CGImageGetWidth(sourceImage);
	size_t height = CGImageGetHeight(sourceImage);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char *m = malloc(width*height*4);
	memset(m, 0, width*height*4);
	
	CGContextRef offscreenContext = CGBitmapContextCreate(m, width, height, 
														  8, width*4, colorSpace, kCGImageAlphaPremultipliedLast);
	
	CGColorSpaceRef mcolorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char *mm = malloc(width*height*4);
	memset(mm, 0, width*height*4);
	
	CGContextRef moffscreenContext = CGBitmapContextCreate(mm, width, height, 
														  8, width*4, mcolorSpace, kCGImageAlphaPremultipliedLast);
	CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
	CGContextDrawImage(moffscreenContext, CGRectMake(0, 0, width, height), mask);
	for (int i=0; i< height; i++) {
		int shift = i * width*4;
		for (int j=0; j< width; j++) {
			if ( mm[shift + j*4 + 0x00]) {	/// checking R component in mask	- if white - then clear alpha
				m[shift + j*4 + 0x00] = 0x00;
				m[shift + j*4 + 0x01] = 0x00;
				m[shift + j*4 + 0x02] = 0x00;
				m[shift + j*4 + 0x03] = 0;
			} else {
//				m[shift + j*4 + 0x03] = 0xff;
			}
		}
	}
	retVal = CGBitmapContextCreateImage(offscreenContext);

	CGContextRelease(offscreenContext);
	CGContextRelease(moffscreenContext);
	
	
	free(m);
	free(mm);
	
	CGColorSpaceRelease(colorSpace);
	CGColorSpaceRelease(mcolorSpace);
	
//	imageData = [NSData dataWithData: UIImagePNGRepresentation([UIImage imageWithCGImage:retVal])];
//	[imageData writeToFile:[NSString stringWithFormat:@"%@/retVal.png", [Utils documentsDirectory]] atomically:YES];
	UIImage *i = [UIImage imageWithCGImage:retVal];
	CGImageRelease(retVal);
	return i;
	
}

/*
+ (UIImage*)mask1Image:(UIImage *)image withMask:(UIImage *)maskImage {
	CGImageRef maskRef = maskImage.CGImage;
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);
 
//	CGImageRef mask = createMaskWithImage(maskImage.CGImage);
	
	CGImageRef sourceImage = [image CGImage];
	CGImageRef imageWithAlpha = sourceImage;
	
	//add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
	//this however has a computational cost
	if ((CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone)
		|| (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipFirst)
		|| (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipLast)) {
		imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
	}
	
	imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
//	mask = CopyImageAndAddAlphaChannel(mask);


//	imageWithAlpha = [[UIImage imageWithData:UIImagePNGRepresentation(image)] CGImage];
//	mask = [[UIImage imageWithData:UIImagePNGRepresentation([UIImage imageWithCGImage:mask])] CGImage];
	
	
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithCGImage:imageWithAlpha])];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/img.png", [Utils documentsDirectory]] atomically:YES];
	
	CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
	CGImageRelease(mask);


	
	//release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
	if (sourceImage != imageWithAlpha) {
		CGImageRelease(imageWithAlpha);
	}
	
	UIImage* retImage = [UIImage imageWithCGImage:masked];
	CGImageRelease(masked);

	imageData = [NSData dataWithData:UIImagePNGRepresentation(retImage)];
	[imageData writeToFile:[NSString stringWithFormat:@"%@/masked.png", [Utils documentsDirectory]] atomically:YES];

	
	return retImage;
}
*/

+ (UIImage*) getIndependImageFromView: (UIView*) v {
	UIGraphicsBeginImageContext(v.bounds.size);
	[v.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;	 
}


+ (UIImage*) getImageFromView: (UIView*) v {
	CGSize size = [v bounds].size;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		if ([[UIScreen mainScreen] scale] == 2.0) {
			UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
//			UIGraphicsBeginImageContextWithOptions(CGSizeMake(v.frame.size.width*2.0, v.frame.size.height*2.0), YES, 1.0);
		} else {
			UIGraphicsBeginImageContext(size);
		}
	} else {
		UIGraphicsBeginImageContext(size);
	}
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	

    return img;
	
}

@end
