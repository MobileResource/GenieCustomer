//
//  WebClient.h
//  Koala
//
//  Created by Developer on 26/03/2014.
//  Copyright (c) 2014 Appostrophic. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface WebClient : AFHTTPRequestOperationManager
+ (instancetype)sharedClient;
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                          onView:(UIView *)loaderOnView
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                        filename:(NSString*)filename
                          onView:(UIView *)loaderOnView
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                imageDataProfile:(NSData *) imageProfile
       imageParamaterNameProfile:(NSString *) imageParamProfile

                          onView:(UIView *)loaderOnView
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
