//
//  Reminders.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/22/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Reminders.h"
#import "Character.h"
#import "Constants.h"
#import "Reminder.h"
#import "ReminderAdd.h"
#import "UIHelpers.h"

@interface Reminders ()

@end

@implementation Reminders

@synthesize character, delegate, reminders, selectedReminder, managedObjectContext;

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

    // convert reminders set to array
	reminders = [NSMutableArray arrayWithArray:[character.reminders allObjects]];
}

- (void) viewWillAppear:(BOOL)animated
{
	reminders = reminders = [NSMutableArray arrayWithArray:[character.reminders allObjects]];
	[self.tableView reloadData];
	
	if (reminders.count < 10 ) {
		self.tableView.scrollEnabled = NO;
	}
	else
		self.tableView.scrollEnabled = YES;
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
    return reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	UIView *cellBg = [[UIView alloc] initWithFrame:cell.frame];
	cellBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
	cell.backgroundView = cellBg;
	
	UIView *selectedBg = [[UIView alloc] initWithFrame:cell.frame];
	selectedBg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableViewSelected.png"]];
	cell.selectedBackgroundView = selectedBg;
	
	Reminder *theReminder = [reminders objectAtIndex:indexPath.row];
	
	cell.tintColor = [UIColor darkGrayColor];
    cell.textLabel.text = [theReminder.text uppercaseString];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor darkGrayColor];
	[UIHelpers applyTextShadow:cell.textLabel];
	cell.textLabel.font = LEAGUE(22);
	cell.detailTextLabel.text = (theReminder.showAtStart.intValue == 1) ? @"START" : @"END";
	
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.font = ARVIL(22);
	[UIHelpers applyTextShadow:cell.detailTextLabel];
	
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
	selectedReminder = [reminders objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"EditReminder" sender:self];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Get a reference to the table item in our data array
		Reminder *reminderToDelete = [reminders objectAtIndex:indexPath.row];
		
		// Delete the item in core data
		[managedObjectContext deleteObject:reminderToDelete];
		
		// Remove the item from our array
		[reminders removeObjectAtIndex:indexPath.row];
		
		// Commit the deletion in core data
		NSError *error;
		if (![managedObjectContext save:&error])
			NSLog(@"Failed to delete reminder with error: %@", error.domain);
		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		if (reminders.count < 10 ) {
			self.tableView.scrollEnabled = NO;
		}
		else
			self.tableView.scrollEnabled = YES;
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddReminder"])
	{
		ReminderAdd *reminderAdd = segue.destinationViewController;
		reminderAdd.managedObjectContext = managedObjectContext;
		reminderAdd.character = character;
		reminderAdd.title = @"ADD REMINDER";
		reminderAdd.navigationItem.hidesBackButton = YES;
		reminderAdd.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:reminderAdd action:@selector(cancel)];
		[reminderAdd.navigationItem setBackBarButtonItem:nil];
	}
	else if ([segue.identifier isEqualToString:@"EditReminder"])
	{
		ReminderAdd *reminderAdd = segue.destinationViewController;
		reminderAdd.managedObjectContext = managedObjectContext;
		reminderAdd.character = character;
		reminderAdd.reminder = selectedReminder;
		reminderAdd.title = @"EDIT REMINDER";
		reminderAdd.navigationItem.hidesBackButton = YES;
		reminderAdd.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:reminderAdd action:@selector(cancel)];
		[reminderAdd.navigationItem setBackBarButtonItem:nil];
	}
}

- (IBAction)done:(id)sender
{
	[delegate remindersDidFinish];
}

@end
