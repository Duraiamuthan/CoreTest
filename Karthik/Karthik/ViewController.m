//
//  ViewController.m
//  Karthik
//
//  Created by Duraiamuthan on 16/12/14.
//  Copyright (c) 2014 Calsoft. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import <CoreData/CoreData.h>

@interface ViewController ()
{
    NSInteger i;
    ViewController1 *vc1;
}
@end

@implementation ViewController
@synthesize users;

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"karthikCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"karthikCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell.textLabel setText:[[users objectAtIndex:indexPath.row]valueForKey:@"name"]];
    
    NSNumber *num=
    [[users objectAtIndex:indexPath.row]valueForKey:@"age"];
    [cell.detailTextLabel setText:[num stringValue]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return users.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == i) {

        return UITableViewCellEditingStyleDelete;
        
//    }
//    else {
//        return UITableViewCellEditingStyleNone;
//    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
     
        NSManagedObjectContext *context = [self managedObjectContext];
        
        [context deleteObject:[users objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        
        [users removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self Show];
        
        [tblvu reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    i=indexPath.row;
    
    vc1=[[ViewController1 alloc]init];
    
    vc1.users=self.users;
    
    vc1.update=YES;
    
    vc1.i=[NSNumber numberWithInt:(int)indexPath.row];
    
    [self.navigationController pushViewController:vc1 animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory");
}

- (void)viewWillAppear:(BOOL)animated
{
    [self Show];
    [tblvu reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    i=-1;
    
    [self.view setBackgroundColor:[UIColor brownColor]];
    
//    UIButton *btnAdd,*btnUpdate,*btnDelete,*btnShow;
//    
//    btnAdd=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    btnUpdate=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    btnShow=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    
//    [btnAdd setFrame:CGRectMake(10,10,100,30)];
//    
//    [btnUpdate setFrame:CGRectMake(10,40,100,30)];
//    
//    [btnDelete setFrame:CGRectMake(10,80,100,30)];
//    
//    [btnShow setFrame:CGRectMake(10,120,100,30)];
//    
//    
//    [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
//    
//    [btnUpdate setTitle:@"Update" forState:UIControlStateNormal];
//  
//    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
//
//    [btnShow setTitle:@"Show" forState:UIControlStateNormal];
//    
//    
//    [btnAdd addTarget:self action:@selector(Add:) forControlEvents:UIControlEventTouchUpInside];
//
//    [btnUpdate addTarget:self action:@selector(Update:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [btnDelete addTarget:self action:@selector(Delete:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [btnShow addTarget:self action:@selector(Show:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [self.view addSubview:btnAdd];
//    
//    [self.view addSubview:btnUpdate];
//    
//    [self.view addSubview:btnDelete];
//    
//    [self.view addSubview:btnShow];
    
    UIBarButtonItem *btnDelete=[[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(DeleteItem:)];
    
    UIBarButtonItem *btnNewItem=[[UIBarButtonItem alloc]initWithTitle:@"New" style:UIBarButtonItemStyleDone target:self action:@selector(AddNewItem:)];
    
    self.navigationItem.rightBarButtonItem=btnDelete;
    
    self.navigationItem.leftBarButtonItem=btnNewItem;

    tblvu=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+30, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];

    
    [tblvu setDataSource:self];
    
    [tblvu setDelegate:self];
    
    [self.view addSubview:tblvu];
}

-(void)AddNewItem:(id)sender
{
    vc1=[[ViewController1 alloc]init];
    
    [self.navigationController pushViewController:vc1 animated:YES];
}

-(void)DeleteItem:(id)sender
{
    UIBarButtonItem *barBtn=(UIBarButtonItem*)sender;
    
    if([barBtn.title isEqualToString:@"Delete"])
    {
      [barBtn setTitle:@"Done"];
      [tblvu setEditing:YES animated:YES];
    }
    else
    {
        [barBtn setTitle:@"Delete"];
        [tblvu setEditing:NO animated:YES];
    }

}


-(void)Add:(id)sender
{
    NSLog(@"add");
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newUser=[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
    
    [newUser setValue:@"Durai" forKey:@"name"];
    
    [newUser setValue:[NSNumber numberWithInt:25] forKey:@"age"];
    
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

-(void)Update:(id)sender
{
    NSLog(@"update");
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    if(users==nil)
    {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Users"];
    
    users = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    }

    [users setValue:@"Amuthan" forKey:@"name"];
    
    NSError *error = nil;

    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}

-(void)Delete:(id)sender
{
    NSLog(@"delete");
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [context deleteObject:[users objectAtIndex:0]];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    

    [users removeObjectAtIndex:0];
}

-(void)Show
{
    NSLog(@"show");
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Users"];
    
    users = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *row in users) {
        NSLog(@"Name:%@",[row valueForKey:@"name"]);
        NSLog(@"Age:%@",[row valueForKey:@"age"]);
    }
    
    if (users.count==0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
        [tblvu setEditing:NO animated:YES];
    }
    else{
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
