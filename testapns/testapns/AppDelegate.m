//
//  AppDelegate.m
//  Karthik
//
//  Created by Duraiamuthan on 16/12/14.
//  Copyright (c) 2014 Calsoft. All rights reserved.
//

#import "AppDelegate.h"

@class ViewController;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
 //   if (localNotif) {
        //NSLog(@"%@",localNotif);
        // NSString *itemName = [localNotif.userInfo objectForKey:ToDoItemKey];
//        [self ShowNotification:userInfo];
//        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
  //  }
    
    // Let the device know we want to receive push notifications
    
    
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }

    
    self.window = [ [ UIWindow alloc ] initWithFrame:[ [ UIScreen mainScreen ] bounds ] ];
    
    UIButton *btn1,*btn2,*btn3;
    
    UIWebView *webVu;
    
    btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    
    btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [btn1 setFrame:CGRectMake(30,30,300,30)];
    
    [btn2 setFrame:CGRectMake(30,130,300,30)];
    
    [btn3 setFrame:CGRectMake(30,230,300,30)];
    
    [btn1 setTitle:@"IsPushNotificationAvailable" forState:UIControlStateNormal];
    
    [btn2 setTitle:@"ShowDeviceTokenValue" forState:UIControlStateNormal];
    
    [btn3 setTitle:@"ShowLatestMessage" forState:UIControlStateNormal];
    
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn1 addTarget:self action:@selector(CheckIfPushNotificationisEnabled:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn2 addTarget:self action:@selector(ShowDeviceTokenValue:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn3 addTarget:self action:@selector(GetMeTheLastPushMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.window addSubview:btn1];
    
    [self.window addSubview:btn2];
    
    [self.window addSubview:btn3];
    
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;

}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    DeviceToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
 
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    NSLog(@"handleActionWithIdentifier:%@",userInfo);
    [self ShowNotification:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    [self ShowNotification:userInfo];
    
}

-(void)ShowNotification:(NSDictionary *)dictpayload
{
    NSDictionary *dict=[dictpayload objectForKey:@"aps"];
    latestPushMessage=[dict objectForKey:@"payload"];
    NSError *err = nil;
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:[latestPushMessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    removalPassword = [payload objectForKey:@"RP"];
    mobileConfigURL = [payload objectForKey:@"MC"];
    NSString *msg=[[NSString alloc]initWithFormat:@"Removal Password:%@ MobileConfig:%@",removalPassword,mobileConfigURL];
   // [self ShowMessage:msg];
    profileLock=true;
    
    
    Notification=[[NSString alloc]initWithFormat:@"Go to Settings -> General -> Profile -> Tap on the Corporate Secuity Hub Profile -> Tap on the Delete Profile Button and enter %@ -> Tap on Delete then open our app then new mobile config installation will start ",removalPassword];
    
    [self ShowMessage:Notification];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


-(void)CheckIfPushNotificationisEnabled:(id)sender
{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    BOOL enabled;
    
    // Try to use the newer isRegisteredForRemoteNotifications otherwise use the enabledRemoteNotificationTypes.
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        enabled = [application isRegisteredForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        enabled = types & UIRemoteNotificationTypeAlert;
    }
    
    if(enabled)
        [self ShowMessage:@"Push notification is enabled"];
    else
        [self ShowMessage:@"Push notification is not enabled"];
}

-(void)ShowDeviceTokenValue:(id)sender
{
    NSLog(@"deviceToken:%@",DeviceToken);
    [self ShowMessage:DeviceToken];
}

-(void)GetMeTheLastPushMessage:(id)sender
{
    if([latestPushMessage isKindOfClass:[NSString class]])
    [self ShowMessage:latestPushMessage];
    else
    [self ShowMessage:@"no notifications"];
}


-(void)ShowMessage:(NSString*)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Test" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if(profileLock)
    {
        if([self isInternetOn])
        {
            NSString *url=[[NSString alloc]initWithFormat:@"https://enterprise-dt.qa.intercloud.net/securityProfiles/%@/mobileconfig",mobileConfigURL];
            
             if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]])
             {
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
             }
             else
             {
                profileLock=false;
                 
             }
       }
       else
       {
            [self ShowMessage:Notification];
       }
    }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

-(BOOL)isInternetOn
{
    //   return NO;
    
    NSURL *url=[NSURL URLWithString:@"http://www.ipchicken.com/"];
    
    NSMutableURLRequest *urlReq=[NSMutableURLRequest requestWithURL:url];
    
    [urlReq setTimeoutInterval:5];
    
    NSURLResponse *response;
    
    NSError *error = nil;
    
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:urlReq
                                                 returningResponse:&response
                                                             error:&error];
    
    if(receivedData !=nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



@end
