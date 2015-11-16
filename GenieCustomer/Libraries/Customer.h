//
//  Customer.h
//  GenieCustomer
//
//  Created by Goldman on 3/31/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Customer : NSObject

+(void) registerWithParametersWithImage:(NSDictionary *)params
                             imageData : (NSData*) image
                        imageDataParam : (NSString *) imageParam
                       withSuccessBlock:(void (^) (NSDictionary *response)) success
                                failure:(void (^) (NSError *error)) failure
                                   view:(UIView *) view;

+(void) registerWithParameters:(NSDictionary *)params
              withSuccessBlock:(void (^) (NSDictionary *response)) success
                       failure:(void (^) (NSError *error)) failure
                          view:(UIView *) view;

+(void) loginWithParameters:(NSDictionary *)params
           withSuccessBlock:(void (^) (NSDictionary *response)) success
                    failure:(void (^) (NSError *error)) failure
                       view:(UIView *) view;

+(void) sendRequestWithParameters:(NSDictionary *)params
           withSuccessBlock:(void (^) (NSDictionary *response)) success
                    failure:(void (^) (NSError *error)) failure
                       view:(UIView *) view;


+(void) getRequestsParameters:(NSDictionary *)params
             withSuccessBlock:(void (^) (NSArray *response)) success
                      failure:(void (^) (NSError *error)) failure
                         view:(UIView *) view;


+(void) declineRequestParameters:(NSDictionary *)params
                withSuccessBlock:(void (^) (NSDictionary *response)) success
                         failure:(void (^) (NSError *error)) failure
                            view:(UIView *) view;
+(void) sendResponseParameters:(NSDictionary *)params
              withSuccessBlock:(void (^) (NSDictionary *response)) success
                       failure:(void (^) (NSError *error)) failure
                          view:(UIView *) view;
+(void) updateProfileParameters:(NSDictionary *)params
               withSuccessBlock:(void (^) (NSDictionary *response)) success
                        failure:(void (^) (NSError *error)) failure
                           view:(UIView *) view;
+(void) updateProfileParametersWithImageData:(NSDictionary *)params
                                  imageData : (NSData*) image
                             imageDataParam : (NSString *) imageParam
                            withSuccessBlock:(void (^) (NSDictionary *response)) success
                                     failure:(void (^) (NSError *error)) failure
                                        view:(UIView *) view;
+(void) changePasswordParameters:(NSDictionary *)params
                withSuccessBlock:(void (^) (NSDictionary *response)) success
                         failure:(void (^) (NSError *error)) failure
                            view:(UIView *) view;
+(void) changeNotificationParameters:(NSDictionary *)params
                    withSuccessBlock:(void (^) (NSDictionary *response)) success
                             failure:(void (^) (NSError *error)) failure
                                view:(UIView *) view;

+(void) getMessagesParameters:(NSDictionary *)params
             withSuccessBlock:(void (^) (NSArray *response)) success
                      failure:(void (^) (NSError *error)) failure
                         view:(UIView *) view;

+(void) sendMessageWithParameters:(NSDictionary *)params
                 withSuccessBlock:(void (^) (NSDictionary *response)) success
                          failure:(void (^) (NSError *error)) failure
                             view:(UIView *) view;
+(void) uploadImageWithImageData:(NSDictionary *)params
                                  imageData : (NSData*) image
                             imageDataParam : (NSString *) imageParam
                            withSuccessBlock:(void (^) (NSDictionary *response)) success
                                     failure:(void (^) (NSError *error)) failure
                                        view:(UIView *) view;
+(void) hireProviderWithParameters:(NSDictionary *)params
               withSuccessBlock:(void (^) (NSDictionary *response)) success
                        failure:(void (^) (NSError *error)) failure
                           view:(UIView *) view;

+(void) rateProviderWithParameters:(NSDictionary *)params
                  withSuccessBlock:(void (^) (NSDictionary *response)) success
                           failure:(void (^) (NSError *error)) failure
                              view:(UIView *) view;

+(void) getRatesWithParameters:(NSDictionary *)params
                  withSuccessBlock:(void (^) (NSArray *response)) success
                           failure:(void (^) (NSError *error)) failure
                              view:(UIView *) view;

@end
