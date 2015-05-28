//
//  GrayStyleView.m
//  ITSCalc
//
//  Created by Sychov Intencom on 29.08.14.
//  Copyright (c) 2014 Sergey Sychov. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 /To take advantage of CIFilters, you have to import the Core Image framework
 #import <CoreImage/CoreImage.h>
 
 //Get a UIImage from the UIView
 UIGraphicsBeginImageContext(myView.bounds.size);
 [myView.layer renderInContext:UIGraphicsGetCurrentContext()];
 UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 //Blur the UIImage with a CIFilter
 CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
 CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
 [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
 [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 10] forKey: @"inputRadius"];
 CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
 UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
 
 //Place the UIImage in a UIImageView
 UIImageView *newView = [[UIImageView alloc] initWithFrame:self.view.bounds];
 newView.image = endImage;
 [self.view addSubview:newView];
 
 
- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}
*/