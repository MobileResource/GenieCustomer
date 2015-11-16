//
//  WebClient.m
//  Koala
//
//  Created by Developer on 26/03/2014.
//  Copyright (c) 2014 Appostrophic. All rights reserved.
//

#import "WebClient.h"
#import "Constants.h"
#import "UIHelper.h"
#import "UtilitiesHelper.h"

#import <Foundation/Foundation.h>

@implementation WebClient


+ (instancetype)sharedClient {
    
    static WebClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WebClient alloc] initWithBaseURL:[NSURL URLWithString:GCWebServiceUrl]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"application/json"]];
    });
    
    return _sharedClient;
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                          onView:(UIView *)loaderOnView
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure   {
    
    
    [UIHelper showLoader:@"Loading.."
                        forView:loaderOnView
                        setMode:MBProgressHUDModeIndeterminate 
                       delegate:nil];
    
    AFHTTPRequestOperation *operation =  [self POST:URLString
                                         parameters:parameters
                                            success:success
                                            failure:failure];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([[responseObject valueForKey:@"Response"]isEqualToString:@"Success"]) {
            
            [UIHelper hideLoader:loaderOnView];
            success(operation,responseObject);
        }
        else {
            
            NSDictionary *errorDictionary = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"Message"] forKey:NSLocalizedDescriptionKey];
            
            NSError *error =[[NSError alloc] initWithDomain:@"Server Message" code:0 userInfo:errorDictionary];
            
            [UIHelper hideLoader:loaderOnView];
            failure (operation,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIHelper hideLoader:loaderOnView];
        failure (operation,error);
    }];
    
    return operation;
}


-(id)usingDocumentForTextfiles:(NSString*)filename
{
    NSError *error;
    NSString *objEntityCourse=[UtilitiesHelper readJsonFromFile:filename];
    NSData* aData = [objEntityCourse dataUsingEncoding:NSUTF8StringEncoding];;
    
    if (aData != nil) {
        
        id reponseFile = [NSJSONSerialization
                          JSONObjectWithData:aData//1
                          options:NSJSONReadingMutableContainers
                          error:&error];
        
        return reponseFile;
        
    }
    else
    {
        
        
        return nil;
        
    }
    
    
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                        filename:(NSString*)filename
                          onView:(UIView *)loaderOnView
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure   {
    
    [UIHelper showLoader:@"Loading.." forView:loaderOnView setMode:MBProgressHUDModeIndeterminate delegate:nil];
    
    AFHTTPRequestOperation *operation =  [self POST:URLString parameters:parameters success:success failure:failure];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject valueForKey:@"Response"])
        {
            if ([[responseObject valueForKey:@"Response"]isEqualToString:@"Success"])
            {
                NSError *error;
                NSLog(@"response object  reached");
                [UIHelper hideLoader:loaderOnView];
                if (![filename isEqualToString:@""]) {
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
                    
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [UtilitiesHelper writeJsonToFile:jsonString withFileName:filename];
                }
                success(operation,responseObject);
                
            }
            else
            {
                //  NSError *error;
                NSLog(@"response object not reached");
                
                [UIHelper hideLoader:loaderOnView];
                id reponseFile ;
                if (![filename isEqualToString:@""]) {
                    reponseFile = [self usingDocumentForTextfiles:filename];
                }
                if (reponseFile == nil)
                {
                    
                    
                    
                    NSError *err = [NSError errorWithDomain:[responseObject valueForKey:@"Response"]
                                                       code:100
                                                   userInfo:@{
                                                              NSLocalizedDescriptionKey:[responseObject valueForKey:@"Message"]
                                                              }];
                    
                    [UIHelper showPromptAlertforTitle:@"Message" withMessage:err.localizedDescription forDelegate:nil];
                    failure (nil,err);
                }
                else
                {
                    failure (operation,reponseFile);
                }
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIHelper hideLoader:loaderOnView];
        id reponseFile = [self usingDocumentForTextfiles:filename];
        
        if (reponseFile == nil)
        {
            [UIHelper showPromptAlertforTitle:@"message" withMessage:error.localizedDescription forDelegate:nil];
            failure (operation, error);
        }
        else
        {
            failure (operation,reponseFile);
        }
    }];
    
    return operation;
}


- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                     cachePolicy:(NSString*)fileCache
                          onView:(UIView *)loaderOnView
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure   {
    
    
    
    [UIHelper showLoader:@"Loading.." forView:loaderOnView setMode:MBProgressHUDModeIndeterminate delegate:nil];
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [operation setUserInfo:@{@"cacheResponse":fileCache}];
    [self.operationQueue addOperation:operation];
    
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject valueForKey:@"Response"]isEqualToString:@"Success"]) {
            [UIHelper hideLoader:loaderOnView];
            
            if(operation.userInfo && [[operation.userInfo objectForKey:@"cacheResponse"] isEqualToString:@"YES"])
            {
                NSString *requestBody=[[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
                NSString *requestUrl=operation.request.URL.absoluteString;
                NSString *fileName=[requestUrl stringByAppendingString:requestBody];
                fileName=[fileName stringByReplacingOccurrencesOfString:@"/"
                                                             withString:@"-"];
                NSString *savedFilePath=[AppCachePath stringByAppendingFormat:@"/%@",fileName];
                
                if(![[NSFileManager defaultManager] fileExistsAtPath:AppCachePath])
                    
                    [[NSFileManager defaultManager]createDirectoryAtPath:AppCachePath withIntermediateDirectories:YES attributes:nil error:nil];
                
                [responseObject writeToFile:savedFilePath
                                 atomically:YES];
                
            }
            
            [UIHelper hideLoader:loaderOnView];
            success(operation,responseObject);
            
        }
        else
        {
            //[UtilitiesHelper showPromptAlertforTitle:@"Message" withMessage:responseObject forDelegate:nil];
            
            
            [UIHelper hideLoader:loaderOnView];
            
            
            NSError *err = [NSError errorWithDomain:[responseObject valueForKey:@"Response"]
                                               code:100
                                           userInfo:@{
                                                      NSLocalizedDescriptionKey:[responseObject valueForKey:@"Message"]
                                                      }];
            
            
            [UIHelper showPromptAlertforTitle:@"Message" withMessage:err.localizedDescription forDelegate:nil];
            
            failure (nil,err);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        NSLog(@"RequestBody:%@",[[NSString alloc]initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
        NSLog(@"failure error no : %@", operation.error);
        NSString *requestBody=[[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
        NSString *requestUrl=operation.request.URL.absoluteString;
        NSString *fileName=[requestUrl stringByAppendingString:requestBody];
        fileName=[fileName stringByReplacingOccurrencesOfString:@"/"
                                                     withString:@"-"];
        NSString *savedFilePath=[AppCachePath stringByAppendingFormat:@"/%@",fileName];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:savedFilePath])
        {
            NSDictionary *dictionary=[[NSDictionary alloc]initWithContentsOfFile:savedFilePath];
            [UIHelper hideLoader:loaderOnView];
            success(operation,dictionary);
        }
        else
        {
            
            
            [UIHelper hideLoader:loaderOnView];
            
            [UIHelper showPromptAlertforTitle:@"Message" withMessage:error.localizedDescription forDelegate:nil];
            
            failure(operation,error);
            
            
        }
    }];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                imageDataProfile:(NSData *) imageProfile
       imageParamaterNameProfile:(NSString *) imageParamProfile

                          onView:(UIView *)loaderOnView
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure   {
    
    
    [UIHelper showLoader:@"Loading.."
                        forView:loaderOnView
                        setMode:MBProgressHUDModeIndeterminate
                       delegate:nil];
    
    
    //    AFHTTPRequestOperation *operation = [self POST:URLString
    //                                        parameters:parameters
    //                                           success:success
    //                                            failure:failure];
    
    AFHTTPRequestOperationManager *newManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:GCWebServiceUrl]];
    
    [newManager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    AFHTTPRequestOperation *operation = [newManager POST:URLString
                                              parameters:parameters
                               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                   
                                   if (imageProfile != nil) {
                                       
                                       [formData appendPartWithFileData:imageProfile
                                                                   name:imageParamProfile
                                                               fileName:@"image1.jpg"
                                                               mimeType:@"image/jpeg"];
                                   }
                                   
                                   
                               } success:success failure:failure];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject valueForKey:@"Response"] isEqualToString:@"Success"]) {
            
            
            [UIHelper hideLoader:loaderOnView];
            success(operation,responseObject);
            
        }
        else {
            
            NSDictionary *errorDictionary = [NSDictionary dictionaryWithObject:[responseObject valueForKey:@"Message"] forKey:NSLocalizedDescriptionKey];
            
            NSError *error =[[NSError alloc] initWithDomain:@"Server Message" code:0 userInfo:errorDictionary];
            
            [UIHelper hideLoader:loaderOnView];
            failure (operation,error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [UIHelper hideLoader:loaderOnView];
        
        failure (operation,error);
    }];
    
    return operation;
}


@end
