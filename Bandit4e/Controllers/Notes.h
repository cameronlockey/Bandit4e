//
//  Notes.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;
@class Note;

@protocol NotesDelegate;

@interface Notes : UITableViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) NSMutableArray *notes;
@property (strong,nonatomic) Note *selectedNote;
@property (weak,nonatomic) id <NotesDelegate> delegate;

- (IBAction)done:(id)sender;
- (void)accessoryButton:(UIControl*)button withEvent:(UIEvent*)event;
@end

@protocol NotesDelegate <NSObject>

@end
