//
//  ViewController1.m
//  Karthik
//
//  Created by Duraiamuthan on 17/12/14.
//  Copyright (c) 2014 Calsoft. All rights reserved.
//

#import "ViewController1.h"
#import <CoreData/CoreData.h>

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    
    txtfiAge=[[UITextField alloc]initWithFrame:CGRectMake(10,70,100,30)];
    
    [txtfiAge setBorderStyle:UITextBorderStyleRoundedRect];
    
    [txtfiAge setPlaceholder:@"Age"];
    
    
    
    txtfiName=[[UITextField alloc]initWithFrame:CGRectMake(10,120,100,30)];
    
    [txtfiName setBorderStyle:UITextBorderStyleRoundedRect];
    
    [txtfiName setPlaceholder:@"Name"];
    
    [btn1 setFrame:CGRectMake(10,160,100,30)];
    
    if(self.update)
    [btn1 setTitle:@"Update" forState:UIControlStateNormal];
    else
    [btn1 setTitle:@"Add" forState:UIControlStateNormal];
    
    [btn1 addTarget:self action:@selector(Add:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    
    [self.view addSubview:txtfiAge];
    
    [self.view addSubview:txtfiName];
    
    if(self.update)
    {
        
        NSManagedObject *row=(NSManagedObject*)[self.users objectAtIndex:self.i.intValue];
        
        [txtfiName setText:[row valueForKey:@"name"]];
        
        NSNumber *age=[row valueForKey:@"age"];
        
        [txtfiAge setText:[age stringValue]];
    }
    

    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Add:(id)sender
{
    NSLog(@"add");
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if(!self.update)
    {
    
    NSManagedObject *newUser=[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
    
    [newUser setValue:txtfiName.text forKey:@"name"];
    
    [newUser setValue:[NSNumber numberWithInt:txtfiAge.text.intValue] forKey:@"age"];
    }
    else
    {
         NSManagedObject *row=(NSManagedObject*)[self.users objectAtIndex:self.i.intValue];
        
        [row setValue:txtfiName.text forKey:@"name"];
        
        [row setValue:[NSNumber numberWithInt:txtfiAge.text.intValue] forKey:@"age"];
    }
    
    NSError *error=nil;
    
    if(![context save:&error])
    {
        NSLog(@"Can't save %@ %@",error,[error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //    // Create a new managed object
    //    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
    //    [newDevice setValue:self.nameTextField.text forKey:@"name"];
    //    [newDevice setValue:self.versionTextField.text forKey:@"version"];
    //    [newDevice setValue:self.companyTextField.text forKey:@"company"];
    //
    //    NSError *error = nil;
    //    // Save the object to persistent store
    //    if (![context save:&error]) {
    //        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    //    }
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
