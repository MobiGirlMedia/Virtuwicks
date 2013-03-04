//
//  ImageUtils.h
//  Universal
//
//  Created by Sergey Kopanev on 5/3/10.
//  Copyright 2010 milytia. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageUtils : NSObject {


}
+ (UIImage *) putImage: (UIImage*) frontImage atPoint: (CGPoint) p onImage: (UIImage*) backImage;
+ (UIImage*) loadNativeImage:(NSString*) name;
+ (UIImage*) loadImage:(NSString*)name inFolder:(NSString*)folder;
+ (NSString*) getDocumentsDirectory;
+ (UIImage*) imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (UIImage*) image: (UIImage*) img zoomedToWidth: (float) width croppedByHeight: (float) height;
+ (UIImage*) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage*) partOfImage: (UIImage*) img croppedToSize: (CGSize) size;
+ (UIImage *) convertToGreyscale:(UIImage *)i;
+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
+ (UIImage*) getImageFromView: (UIView*) v;

+ (UIImage*) generateImageWithSize: (CGSize) size;
+ (NSString*) getFodler;
@end
