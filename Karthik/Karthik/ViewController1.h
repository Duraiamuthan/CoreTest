//
//  ViewController1.h
//  Karthik
//
//  Created by Duraiamuthan on 17/12/14.
//  Copyright (c) 2014 Calsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController1 : UIViewController
{
    UIButton *btn1;
    UITextField *txtfiName;
    UITextField *txtfiAge;
}
@property(strong,nonatomic)NSNumber *i;
@property(assign)BOOL update;
@property(strong,nonatomic) NSMutableArray* users;
@end
