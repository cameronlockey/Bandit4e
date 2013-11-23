//
//  CharacterAddEdit.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@class Character;

@protocol CharacterAddEditDelegate;

@interface CharacterAddEdit : UITableViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,BSKeyboardControlsDelegate>
{
	NSData *imageData;
}

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic) Character *character;
@property (strong,nonatomic) UIImagePickerController *imagePicker;

@property (weak,nonatomic) id <CharacterAddEditDelegate> delegate;

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *raceField;
@property (weak, nonatomic) IBOutlet UITextField *classField;
@property (weak, nonatomic) IBOutlet UITextField *levelField;
@property (weak, nonatomic) IBOutlet UIButton *photoEditButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITextField *experienceField;
@property (weak, nonatomic) IBOutlet UITextField *goldField;
@property (weak, nonatomic) IBOutlet UITextField *maxHpField;
@property (weak, nonatomic) IBOutlet UITextField *maxSurgesField;
@property (weak, nonatomic) IBOutlet UITextField *healingSurgeValueField;
@property (weak, nonatomic) IBOutlet UITextField *savingThrowModifierField;
@property (weak, nonatomic) IBOutlet UITextField *milestonesField;
@property (weak, nonatomic) IBOutlet UITextField *actionPointsField;
@property (weak, nonatomic) IBOutlet UISwitch *saveAtStartSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *usePowerPointsSwitch;
@property (weak, nonatomic) IBOutlet UITextField *maxPowerPointsField;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raceLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHpLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSurgesLabel;
@property (weak, nonatomic) IBOutlet UILabel *surgeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *savingThrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *milestonesLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveAtStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *usePowerPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPowerPointsLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)imageFromAlbum:(id)sender;
- (IBAction)saveCharacter:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)didSwitchUsePowerPoints:(id)sender;

-(void)customizeLabel:(UILabel*)label;
-(void)customizeLabels:(NSArray*)labels;
-(void)customizeField:(UITextField*)field;
-(void)customizeFields:(NSArray*)textFields;
@end

@protocol CharacterAddEditDelegate <NSObject>

-(void)characterAddEditDidCancel;
-(void)characterAddEditDidFinish;

@end
