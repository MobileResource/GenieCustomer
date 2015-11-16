//
//  UtilitiesHelper.m
//  GameStaker
//
//  Created by Goldman on 2/5/15.
//  Copyright (c) 2015 TS Application Ltd. All rights reserved.
//

#import "UtilitiesHelper.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>
#import "Constants.h"

@implementation UtilitiesHelper


+(void)writeJsonToFile:(id)responseString withFileName:(NSString*)fileName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSLog(@"filePath %@", filePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) { // if file is not exist, create it.
        NSError *error;
        [responseString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
    }
    else
    {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath: filePath error: &error];
        
        [responseString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
    
}
+(id)readJsonFromFile:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        //        NSString *myPathInfo = [[NSBundle mainBundle] pathForResource:@"myfile" ofType:@"txt"];
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //        [fileManager copyItemAtPath:myPathInfo toPath:myPathDocs error:NULL];
        return NULL;
    }
    
    //Load from File
    NSString *myString = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"string ===> %@",myString);
    return myString;
}

+(BOOL)checkInternetConnection{
    Reachability    *curReach   =   [Reachability reachabilityForInternetConnection];
    NetworkStatus   netStatus   =   [curReach currentReachabilityStatus];
    switch (netStatus){
        case NotReachable:{
            return NO;
        }
        case ReachableViaWWAN:{
            return YES;
        }
        case ReachableViaWiFi:{
            return YES;
        }
    }
}

+(void)openURL:(NSString*)url{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+(BOOL)IsNullOrEmptyString:(NSString*)str{
    if (str == nil || [str isEqualToString:@""]) {
        return TRUE;
    }
    return FALSE;
}

+(NSDate*)convert2Date:(NSString*)datetime{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss'"];
    NSDate * date = [formatter dateFromString:datetime];
    return date;
}

+(NSString*)convert2DateString:(NSDate*)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd'/'MM'/'yyyy"];
    NSString * string = [formatter stringFromDate:date];
    return string;
}

+(NSString*)convert2TimeString:(NSDate*)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH':'mm"];
    NSString * string = [formatter stringFromDate:date];
    return string;
}

+(NSString*)reviseDateString:(NSString*)datetime{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss'"];
    NSDate * date = [formatter dateFromString:datetime];
    
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterMediumStyle];
    NSString * result = [formatter1 stringFromDate:date];
    
    return result;
}

+(NSString*)getFullImageURL:(NSString*)image{
    NSString * fullImage = @"";
    if ([image hasPrefix:@"http"] || [image hasPrefix:@"https"]) {
        //Facebook profile image
        fullImage = [NSString stringWithFormat:@"%@", image];
    } else {
        //Changed profile image
        fullImage = [NSString stringWithFormat:@"%@%@", GCWebServiceDomain, image];
    }
    return fullImage;
}

+(UIImage*)imageWithImage:(UIImage*)src scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newSize.width / [UIScreen mainScreen].scale, newSize.height / [UIScreen mainScreen].scale), NO, 0.0);
    [src drawInRect:CGRectMake(0, 0, newSize.width / [UIScreen mainScreen].scale, newSize.height / [UIScreen mainScreen].scale)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSDictionary*)convert2Dictionary:(NSString*)jsonString{
    NSData * data = [[NSData alloc] init];
    data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

@end
