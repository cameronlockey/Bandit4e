//
//  NoteAdd.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Character.h"
#import "Constants.h"
#import "Note.h"
#import "NoteAdd.h"

@interface NoteAdd ()

@end

@implementation NoteAdd

@synthesize textField, managedObjectContext, character, note;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = VIEWBG;
	self.navigationController.navigationBar.translucent = NO;
	
	if (note)
	{
		textField.text = note.text;
	}
	textField.backgroundColor = [UIColor clearColor];
	textField.textColor = [UIColor darkGrayColor];
	textField.font = [UIFont systemFontOfSize:17.0];
	[textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
	if (![textField.text isEqualToString:@""])
	{
		if (!note)
		{
			note = (Note*)[NSEntityDescription  insertNewObjectForEntityForName:@"Note"
														 inManagedObjectContext:managedObjectContext];
		}
		
		note.text = textField.text;
		[character addNotesObject:note];
		[Constants save:managedObjectContext];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		[self cancel];
	}
}

- (void)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
