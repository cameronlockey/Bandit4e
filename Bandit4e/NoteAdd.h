//
//  NoteAdd.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;
@class Note;

@interface NoteAdd : UIViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) Note *note;

@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (nonatomic, assign) BOOL editing;

- (IBAction)save:(id)sender;
- (void)cancel;

@end
