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

@interface CharacterList : UITableViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSMutableArray *characters;

@property (strong,nonatomic) Character *selectedCharacter;

-(void)readDataForTable;

@end
