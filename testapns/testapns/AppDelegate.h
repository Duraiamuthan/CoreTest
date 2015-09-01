//
//  AppDelegate.h
//  Karthik
//
//  Created by Duraiamuthan on 16/12/14.
//  Copyright (c) 2014 Calsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *DeviceToken,*latestPushMessage,*removalPassword,*mobileConfigURL,*Notification;
    BOOL profileLock;
    
}

@property (strong, nonatomic) UIWindow *window;

-(void)ShowMessage:(NSString*)message;

-(void)GetMeTheLastPushMessage:(id)sender;

-(void)ShowDeviceTokenValue:(id)sender;
@end

