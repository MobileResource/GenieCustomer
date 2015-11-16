//
//  Constants.h
//  GenieProvider
//
//  Created by Goldman on 3/21/15.
//  Copyright (c) 2015 genie. All rights reserved.
//

#ifndef GenieProvider_Constants_h
#define GenieProvider_Constants_h

#define AppCachePath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"AppCache"]

//#define GCWebServiceUrl                  @"http://192.168.1.130/genie/customer_api/"
//#define GCWebServiceDomain               @"http://192.168.1.130/genie/"

#define GCWebServiceUrl                  @"http://genieapp.co/customer_api/"
#define GCWebServiceDomain               @"http://genieapp.co/"

#define GCWebServiceRegister             @"register"
#define GCWebServiceLogin                @"login"
#define GCWebServiceLogin                @"login"
#define GCWebServiceSendRequest          @"send_request"
#define GCWebServiceGetRequests          @"get_request"

#define GCWebServiceDeclineRequest       @"decline_request"
#define GCWebServiceSendResponse         @"send_response"
#define GCWebServiceUpdateProfile        @"update_profile"
#define GCWebServiceChangePassword       @"change_password"
#define GCWebServiceChangeNotification   @"change_notification"
#define GCWebServiceGetMessages          @"get_messages"
#define GCWebServiceSendMessage          @"send_message"
#define GCWebServiceUploadImage          @"upload_image"
#define GCWebServiceHireProvider         @"hire_provider"
#define GCWebServiceRateProvider         @"rate_provider"
#define GCWebServiceGetRates             @"get_rates"

/*****  Notifications *****/
#define GCNotificationAvatarChanged @"notificationAvatarChanged"
#endif
