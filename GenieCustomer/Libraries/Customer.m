//
//  Customer.m
//  GenieCustomer
//
//  Created by Goldman on 3/31/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import "Customer.h"
#import "Constants.h"
#import "WebClient.h"

@implementation Customer


+(void) registerWithParametersWithImage:(NSDictionary *)params
                             imageData : (NSData*) image
                        imageDataParam : (NSString *) imageParam
                       withSuccessBlock:(void (^) (NSDictionary *response)) success
                                failure:(void (^) (NSError *error)) failure
                                   view:(UIView *) view{
    
    [[WebClient sharedClient] POST:GCWebServiceRegister
                        parameters:params
                  imageDataProfile:image
         imageParamaterNameProfile:imageParam
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Register Response:%@", responseObject);
                                
                                success([responseObject objectForKey:@"result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) registerWithParameters:(NSDictionary *)params
              withSuccessBlock:(void (^) (NSDictionary *response)) success
                       failure:(void (^) (NSError *error)) failure
                          view:(UIView *) view{
    
    [[WebClient sharedClient] POST:GCWebServiceRegister
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Register Response:%@", responseObject);
                                
                                success([responseObject objectForKey:@"result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) loginWithParameters:(NSDictionary *)params
           withSuccessBlock:(void (^) (NSDictionary *response)) success
                    failure:(void (^) (NSError *error)) failure
                       view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceLogin
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Login Response:%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) sendRequestWithParameters:(NSDictionary *)params
                 withSuccessBlock:(void (^) (NSDictionary *response)) success
                          failure:(void (^) (NSError *error)) failure
                             view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceSendRequest
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Send Request Response:%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}


+(void) getRequestsParameters:(NSDictionary *)params
             withSuccessBlock:(void (^) (NSArray *response)) success
                      failure:(void (^) (NSError *error)) failure
                         view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceGetRequests
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Get Requests Response:%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
    
}

+(void) declineRequestParameters:(NSDictionary *)params
                withSuccessBlock:(void (^) (NSDictionary *response)) success
                         failure:(void (^) (NSError *error)) failure
                            view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceDeclineRequest
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Decline Request Response:%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) sendResponseParameters:(NSDictionary *)params
              withSuccessBlock:(void (^) (NSDictionary *response)) success
                       failure:(void (^) (NSError *error)) failure
                          view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceSendResponse
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Send Response Result:%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) updateProfileParameters:(NSDictionary *)params
               withSuccessBlock:(void (^) (NSDictionary *response)) success
                        failure:(void (^) (NSError *error)) failure
                           view:(UIView *) view{
    
    [[WebClient sharedClient] POST:GCWebServiceUpdateProfile
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Update Profile Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) updateProfileParametersWithImageData:(NSDictionary *)params
                                  imageData : (NSData*) image
                             imageDataParam : (NSString *) imageParam
                            withSuccessBlock:(void (^) (NSDictionary *response)) success
                                     failure:(void (^) (NSError *error)) failure
                                        view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceUpdateProfile
                        parameters:params
                  imageDataProfile:image
         imageParamaterNameProfile:imageParam
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Update Profile Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
    
}

+(void) changePasswordParameters:(NSDictionary *)params
                withSuccessBlock:(void (^) (NSDictionary *response)) success
                         failure:(void (^) (NSError *error)) failure
                            view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceChangePassword
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Change Password Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) changeNotificationParameters:(NSDictionary *)params
                    withSuccessBlock:(void (^) (NSDictionary *response)) success
                             failure:(void (^) (NSError *error)) failure
                                view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceChangeNotification
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Change Notification Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) getMessagesParameters:(NSDictionary *)params
             withSuccessBlock:(void (^) (NSArray *response)) success
                      failure:(void (^) (NSError *error)) failure
                         view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceGetMessages
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Get Messages Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) sendMessageWithParameters:(NSDictionary *)params
                 withSuccessBlock:(void (^) (NSDictionary *response)) success
                          failure:(void (^) (NSError *error)) failure
                             view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceSendMessage
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Send Message Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) uploadImageWithImageData:(NSDictionary *)params
                      imageData : (NSData*) image
                 imageDataParam : (NSString *) imageParam
                withSuccessBlock:(void (^) (NSDictionary *response)) success
                         failure:(void (^) (NSError *error)) failure
                            view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceUploadImage
                        parameters:params
                  imageDataProfile:image
         imageParamaterNameProfile:imageParam
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Upload Image Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) hireProviderWithParameters:(NSDictionary *)params
                  withSuccessBlock:(void (^) (NSDictionary *response)) success
                           failure:(void (^) (NSError *error)) failure
                              view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceHireProvider
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Hire Provider Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) rateProviderWithParameters:(NSDictionary *)params
                  withSuccessBlock:(void (^) (NSDictionary *response)) success
                           failure:(void (^) (NSError *error)) failure
                              view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceRateProvider
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Rate Provider Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];
}

+(void) getRatesWithParameters:(NSDictionary *)params
              withSuccessBlock:(void (^) (NSArray *response)) success
                       failure:(void (^) (NSError *error)) failure
                          view:(UIView *) view{
    [[WebClient sharedClient] POST:GCWebServiceGetRates
                        parameters:params
                            onView:view success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"Get Rates Response :%@", responseObject);
                                
                                success([responseObject objectForKey:@"Result"]);
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                failure(error);
                            }];

}

@end
