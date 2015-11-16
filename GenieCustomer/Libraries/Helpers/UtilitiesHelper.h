//
//  UtilitiesHelper.h
//  GameStaker
//
//  Created by Goldman on 2/5/15.
//  Copyright (c) 2015 TS Application Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilitiesHelper : NSObject

+(void)writeJsonToFile:(id)responseString withFileName:(NSString*)fileName;
//+(id)writeJsonToFile:(NSString*)fileName;
+(id)readJsonFromFile:(NSString*)fileName;
+(BOOL)checkInternetConnection;
+(void)openURL:(NSString*)url;
+(BOOL)IsNullOrEmptyString:(NSString*)str;
+(NSDate*)convert2Date:(NSString*)datetime;
+(NSString*)convert2DateString:(NSDate*)date;
+(NSString*)convert2TimeString:(NSDate*)date;
+(NSString*)reviseDateString:(NSString*)datetime;
+(NSString*)getFullImageURL:(NSString*)image;
+(UIImage*)imageWithImage:(UIImage*)src scaledToSize:(CGSize)newSize;
+(NSDictionary*)convert2Dictionary:(NSString*)jsonString;
@end
