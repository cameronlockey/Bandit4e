//
//  CharacterList.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterAddEdit.h"

@class Character;

@interface CharacterList : UIViewController <UITableViewDelegate, UITableViewDataSource, CharacterAddEditDelegate>
{
	UIImageView *banditTitle;
}

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSMutableArray *characters;
@property (strong,nonatomic) UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong,nonatomic) Character *selectedCharacter;

-(void)readDataForTable;
-(void)accessoryButton:(UIControl*)button withEvent:(UIEvent*)event;

@end
