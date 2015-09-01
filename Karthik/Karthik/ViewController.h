//
//  ViewController.h
//  Karthik
//
//  Created by Duraiamuthan on 16/12/14.
//  Copyright (c) 2014 Calsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
   
    UITableView *tblvu;
}
@property(strong,nonatomic) NSMutableArray *users;
@end

