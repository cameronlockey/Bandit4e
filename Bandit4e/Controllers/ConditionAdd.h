//
//  ConditionAdd.h
//  Bandit4e
//
//  Created by Cameron Lockey on 3/19/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@class Character;

@protocol ConditionAddDelegate;

@interface ConditionAdd : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
	BOOL damageShowing;
	BOOL turnsShowing;
}

@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) id <ConditionAddDelegate> delegate;

@property (strong,nonatomic) NSArray *names;
@property (strong,nonatomic) NSArray *durations;

@property (weak, nonatomic) IBOutlet UIPickerView *namePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *durationPicker;
@property (weak, nonatomic) IBOutlet UILabel *damageLabel;
@property (weak, nonatomic) IBOutlet UITextField *damageAmountField;
@property (weak, nonatomic) IBOutlet UITextField *damageTypeField;
@property (weak, nonatomic) IBOutlet UILabel *turnsLabel;
@property (weak, nonatomic) IBOutlet UITextField *turnsField;

- (IBAction)cancel:(id)sender;
- (IBAction)saveCondition:(id)sender;
- (IBAction)durationChanged:(id)sender;

-(void)showDamageInterface:(BOOL)show;
-(void)showTurnsInterface:(BOOL)show;
-(void)moveTurnsToSecondRow:(BOOL)move;
-(void)customizeLabel:(UILabel*)label;
-(void)customizeField:(UITextField*)field;
-(void)scrollToDamageFields:(BOOL)showKeyboard;
-(void)scrollToTurnsField:(BOOL)showKeyboard;

@end

@protocol ConditionAddDelegate <NSObject>

-(void)conditionAddDidCancel;
-(void)conditionAddDidFinish;

@end