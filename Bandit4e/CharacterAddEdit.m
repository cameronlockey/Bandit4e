//
//  CharacterAddEdit.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CharacterAddEdit.h"
#import "Character.h"
#import "Constants.h"
#import "UIHelpers.h"

#define nums(x) [f numberFromString:x]

@interface CharacterAddEdit ()
/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

/**
 *  Scroll view to text field.
 *  @param textField Text field to scroll to.
 */
- (void)scrollViewToTextField:(id)textField;
@end

@implementation CharacterAddEdit

@synthesize managedObjectContext, imagePicker, character, delegate, saveButton, cancelButton;
@synthesize nameField, raceField, classField, levelField, photoEditButton, photoView;
@synthesize experienceField, goldField, maxHpField, maxSurgesField, healingSurgeValueField, savingThrowModifierField;
@synthesize actionPointsField;
@synthesize saveAtStartSwitch, usePowerPointsSwitch, maxPowerPointsField;
@synthesize nameLabel, raceLabel, classLabel, levelLabel, photoLabel, maxHpLabel, maxSurgesLabel, surgeValueLabel, savingThrowLabel, experienceLabel, goldLabel, actionPointsLabel, saveAtStartLabel, usePowerPointsLabel,maxPowerPointsLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableBg.png"]];
		
	// Initialize the keyboard controls
	self.keyboardControls = [[BSKeyboardControls alloc] init];
	
	// Set the delegate of the keyboard controls
	self.keyboardControls.delegate = self;
	
	// Add all text fields you want to be able to skip between to the keyboard controls
	// Sets the order of prev/next	
	NSMutableArray *textFields = [NSMutableArray arrayWithObjects:
									   nameField,raceField,classField,levelField,maxHpField,maxSurgesField,healingSurgeValueField,savingThrowModifierField,experienceField,goldField, actionPointsField, maxPowerPointsField,nil];
	
	self.keyboardControls.textFields = textFields;
	
	// Set the tint color of the Previous/Next buttons
	self.keyboardControls.previousNextTintColor = [UIColor lightGrayColor];
	
	// Set the tint color of the done button.
	self.keyboardControls.doneTintColor = [UIColor colorWithRed:34.0/255.0 green:164.0/255.0 blue:255.0/255.0 alpha:1.0];
	
	// Set title for the Previous Button
	self.keyboardControls.previousTitle = @"Previous";
	
	// Set title for Next button
	self.keyboardControls.nextTitle = @"Next";
	
	// Add the keyboard control as an accessory view for all of the text fields
	// Set the delegate of all the text fields to self
	for (id textField in self.keyboardControls.textFields)
	{
		if ([textField isKindOfClass:[UITextField class]])
		{
			((UITextField*) textField).inputAccessoryView = self.keyboardControls;
			((UITextField*) textField).delegate = self;
		}
	}

    // If editing a character, dump in the details
	if (character)
	{
		nameField.text = [character.name uppercaseString];
		raceField.text = [character.race uppercaseString];
		classField.text = [character.classname uppercaseString];
		levelField.text = character.level.stringValue;
		
		if (character.photo)
			photoView.image = [UIImage imageWithData:character.photo];
		
		experienceField.text = character.experience.stringValue;
		goldField.text = character.gold.stringValue;
		maxHpField.text = character.maxHp.stringValue;
		maxSurgesField.text = character.maxSurges.stringValue;
		healingSurgeValueField.text = character.surgeValue.stringValue;
		savingThrowModifierField.text = character.saveModifier.stringValue;
		
		actionPointsField.text = character.actionPoints.stringValue;
		
		saveAtStartSwitch.on = character.saveAtStart.boolValue;
		usePowerPointsSwitch.on = character.usesPp.boolValue;
		maxPowerPointsField.text = character.maxPp.stringValue;
		
	}
	else
	{
		// make the name field the first responder
		[nameField becomeFirstResponder];
	}

	// customize switches
	UIColor *switchBlue = [UIColor colorWithRed:0.16 green:0.32 blue:0.46 alpha:1.0];
	saveAtStartSwitch.onTintColor = switchBlue;
	usePowerPointsSwitch.onTintColor = switchBlue;
	
	if (delegate == nil)
		cancelButton.enabled = NO;
	
	// customize labels
	[self customizeLabels:[NSArray arrayWithObjects:nameLabel, raceLabel, classLabel, levelLabel, photoLabel, maxSurgesLabel, maxHpLabel, surgeValueLabel, savingThrowLabel, experienceLabel, goldLabel, actionPointsLabel, savingThrowLabel, saveAtStartLabel, usePowerPointsLabel, maxPowerPointsLabel, nil]];
	
	// customize fields
	[self customizeFields:textFields];
	
	// configure disabled cell label colors
	if (!usePowerPointsSwitch.on) {
		maxPowerPointsLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
	}
	
	// add in save button and config to done action
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SAVE" style:UIBarButtonItemStylePlain target:self action:@selector(saveCharacter)];
	
}

/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    UITableViewCell *cell = (UITableViewCell *) ((UIView *) textField).superview.superview.superview;
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* !Custom IB Actions
 * ---------------------------------------------*/
- (IBAction)imageFromAlbum:(id)sender
{
	imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)saveCharacter
{
	// If we are adding a new character then create an entry
	if (!character)
		character = (Character*)[NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:managedObjectContext];
	
	// For new and existing characters, set the data from the form
	character.name = [nameField.text capitalizedString];
	character.race = [raceField.text capitalizedString];
	character.classname = [classField.text capitalizedString];	
	
	// Convert those number strings to actual numbers
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	f.numberStyle = NSNumberFormatterDecimalStyle;
	
	character.level = nums(levelField.text);
	character.experience = nums(experienceField.text);
	character.gold = nums(goldField.text);
	character.maxHp = nums(maxHpField.text);
	character.maxSurges = nums(maxSurgesField.text);
	character.surgeValue = nums(healingSurgeValueField.text);
	character.saveModifier = nums(savingThrowModifierField.text);
	character.actionPoints = nums(actionPointsField.text);
	
	if ([maxPowerPointsField.text isEqualToString:@""])
	{
		maxPowerPointsField.text = @"0";
	}
	character.maxPp = nums(maxPowerPointsField.text);
	
	// set values for boolean settings
	character.saveAtStart = [NSNumber numberWithBool:saveAtStartSwitch.on];
	character.usesPp = [NSNumber numberWithBool:usePowerPointsSwitch.on];
	
	// Set rest of fields that are not defined by user, if we are not editing from 
	if (!self.editing)
	{
		character.currentHp = [f numberFromString:maxHpField.text];
		character.currentSurges = [f numberFromString:maxSurgesField.text];
		character.tempHp = [NSNumber numberWithInt:0];
		character.failedSaves = [NSNumber numberWithInt:0];
	}
	
	if (photoView.image)
    {	
        imageData = UIImageJPEGRepresentation(photoView.image, 1);
		
		// Resize and save a smaller version for the table
		float resize = 60.0;
		float actualWidth = photoView.image.size.width;
		float actualHeight = photoView.image.size.height;
		float divBy, newWidth, newHeight;
		if (actualWidth > actualHeight) {
			divBy = (actualWidth / resize);
			newWidth = resize;
			newHeight = (actualHeight / divBy);
		} else {
			divBy = (actualHeight / resize);
			newWidth = (actualWidth / divBy);
			newHeight = resize;
		}
		CGRect rect = CGRectMake(0.0, 0.0, newWidth, newHeight);
		UIGraphicsBeginImageContext(rect.size);
		[photoView.image drawInRect:rect];
		UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		// Save the small image version
		NSData *smallImageData = UIImageJPEGRepresentation(smallImage, 1.0);
		character.photo = smallImageData;
    }
	
    //  Commit item to core data
    [Constants save:managedObjectContext];
	
	//  Automatically pop to previous view now we're done adding
	[delegate characterAddEditDidFinish];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didSwitchUsePowerPoints:(id)sender {
	if (usePowerPointsSwitch.on == YES)
	{
		maxPowerPointsField.enabled = YES;
		[self.keyboardControls.textFields addObject:maxPowerPointsField];
		maxPowerPointsLabel.textColor = [UIColor colorWithWhite:0.35 alpha:1.0];
	}
	else
	{
		maxPowerPointsField.enabled = NO;
		[self.keyboardControls.textFields removeObject:maxPowerPointsField];
		maxPowerPointsLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
		maxPowerPointsField.text = nil;
	}
		
}

-(void)customizeLabel:(UILabel *)label
{
	label.font = ARVIL(25.0f);
	//label.text = [label.text uppercaseString];
	
	label.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	label.layer.shadowOffset = CGSizeMake(0,1);
	label.layer.shadowRadius = 0;
	label.layer.shadowOpacity = 1;
	
	label.textColor = [UIColor colorWithWhite:0.35 alpha:1.0];
	label.highlightedTextColor = GRAY;
}

-(void)customizeLabels:(NSArray *)labels
{
	for (UILabel *label in labels) {
		[self customizeLabel:label];
	}
}

-(void)customizeField:(UITextField *)field
{
	field.font = LEAGUE(25.0f);
	field.textColor = GRAY;
	field.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	field.layer.shadowOffset = CGSizeMake(0,1);
	field.layer.shadowRadius = 0;
	field.layer.shadowOpacity = 1;
	field.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;		
	
}

-(void)customizeFields:(NSArray *)textFields
{
	for (UITextField *field in textFields) {
		[self customizeField:field];
	}
}

/* !UIImagePickerController Delegate Methods
 * ---------------------------------------------*/

//  Dismiss the image picker on selection and use the resulting image in our ImageView
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	photoView.image = editedImage;
	
	[self dismissViewControllerAnimated:NO completion:nil];	
}

//  On cancel, only dismiss the picker controller
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

/* !BSKeyboardControlsDelegate
 * ---------------------------------------------*/
// Close keyboard if Done is pressed
-(void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
	[controls.activeTextField resignFirstResponder];
	
}

// Focus next/previous textfield when Next/Prev is pressed
-(void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
	[textField becomeFirstResponder];
	[self scrollViewToTextField:textField];
}

/* !UITextFieldDelegate
 * ---------------------------------------------*/
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ([self.keyboardControls.textFields containsObject:textField]) {
		self.keyboardControls.activeTextField = textField;
	}
	[self scrollViewToTextField:textField];
}

/* !UITableViewDelegate Methods
 * ---------------------------------------------*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIView *cellBg = [[UIView alloc] initWithFrame:cell.frame];
	cellBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
	cell.backgroundView = cellBg;
	
	UIView *selectedBg = [[UIView alloc] initWithFrame:cell.frame];
	selectedBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableViewSelected.png"]];
	cell.selectedBackgroundView = selectedBg;
	
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// Draw top border only on first cell
	if (indexPath.row == 0) {
		UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
		topLineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
		[cell addSubview:topLineView];
	}
	else
	{
		UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
		topLineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
		[cell addSubview:topLineView];
	}
	
	UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, self.view.bounds.size.width, 1)];
	bottomLineView.backgroundColor = [UIColor colorWithWhite:0.45 alpha:1.0];
	[cell addSubview:bottomLineView];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
	
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 2, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, -1.0);
	label.layer.shadowOpacity = 0.9;
	label.layer.shadowRadius = 0;
    label.font = MISSION(23.0f);
    label.text = sectionTitle;
	
    // Create header view and add label as a subview
	
    // you could also just return the label (instead of making a new view and adding the label as subview. With the view you have more flexibility to make a background color or different paddings
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    [view addSubview:label];
	
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sectionHeader.png"]];
	
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30;
}



@end
