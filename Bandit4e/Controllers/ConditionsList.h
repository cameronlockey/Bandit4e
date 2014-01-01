//
//  ConditionsList.h
//  Bandit4e
//
//  Created by Cameron Lockey on 3/17/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionAdd.h"

@class Character;
@class Condition;

@interface ConditionsList : UITableViewController <ConditionAddDelegate>
{
	NSMutableArray *conditions;
}

@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic) NSArray *durations;
@property (strong,nonatomic) NSArray *types;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;


@end
