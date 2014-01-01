//
//  Notes.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Character.h"
#import "Constants.h"
#import "Note.h"
#import "NoteAdd.h"
#import "Notes.h"
#import "NoteCell.h"
#import "UIHelpers.h"

@interface Notes ()

@end

@implementation Notes

@synthesize character, notes, selectedNote, delegate, managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.view.backgroundColor = TABLEBG;
	self.tableView.backgroundColor = TABLEBG;
	self.tableView.separatorColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.navigationController.navigationBar.translucent = NO;

    // convert notes set to array
	notes = [NSMutableArray arrayWithArray:[character.notes allObjects]];
}

- (void)viewWillAppear:(BOOL)animated
{
	notes = [NSMutableArray arrayWithArray:[character.notes allObjects]];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoteCell";
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	UIView *cellBg = [[UIView alloc] initWithFrame:cell.frame];
	cellBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
	cell.backgroundView = cellBg;
	
	UIView *selectedBg = [[UIView alloc] initWithFrame:cell.frame];
	selectedBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableViewSelected.png"]];
	cell.selectedBackgroundView = selectedBg;
	
	// get the note for the corresponding cell
	Note *theNote = [notes objectAtIndex:indexPath.row];
	cell.textView.text = theNote.text;
	cell.textView.font = [UIFont systemFontOfSize:14];
	cell.textView.textColor = [UIColor darkGrayColor];
	cell.textView.backgroundColor = [UIColor clearColor];
	
	cell.tintColor = [UIColor darkGrayColor];
	
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
    
    return cell;
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	selectedNote = [notes objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"EditNote" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITextView *tempTV = [[UITextView alloc] init];
	
	Note *theNote = [notes objectAtIndex:indexPath.row];
	[tempTV setText:theNote.text];
	tempTV.font = [UIFont systemFontOfSize:14];
	CGFloat width = 264;
	CGSize size = [tempTV sizeThatFits:CGSizeMake(width, 100)];
	return (10 + size.height + 10);
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Get a reference to the table item in our data array
		Note *noteToDelete = [notes objectAtIndex:indexPath.row];
		
		// Delete the item in core data
		[managedObjectContext deleteObject:noteToDelete];
		
		// Remove the item from our array
		[notes removeObjectAtIndex:indexPath.row];
		
		// Commit the deletion in core data
		NSError *error;
		if (![managedObjectContext save:&error])
			NSLog(@"Failed to delete note with error: %@", error.domain);
		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/* !Segue Managment
 * ---------------------------------------------*/
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddNote"])
	{
		NoteAdd *noteAdd = segue.destinationViewController;
		noteAdd.managedObjectContext = managedObjectContext;
		noteAdd.character = character;
		noteAdd.editing = NO;
		noteAdd.title = @"ADD NOTE";
		noteAdd.navigationItem.hidesBackButton = YES;
		noteAdd.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:noteAdd action:@selector(cancel)];
		[noteAdd.navigationItem setBackBarButtonItem:nil];
	}
	else if ([segue.identifier isEqualToString:@"EditNote"])
	{
		NoteAdd *noteAdd = segue.destinationViewController;
		noteAdd.managedObjectContext = managedObjectContext;
		noteAdd.character = character;
		noteAdd.note = selectedNote;
		noteAdd.editing = YES;
		noteAdd.title = @"EDIT NOTE";
		noteAdd.navigationItem.hidesBackButton = YES;
		noteAdd.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:noteAdd action:@selector(cancel)];
		[noteAdd.navigationItem setBackBarButtonItem:nil];
	}
}

/* !User Interaction Handlers
 * ---------------------------------------------*/
- (IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
