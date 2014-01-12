//
//  CharacterList.m
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CharacterList.h"
#import "Character.h"
#import "CharacterAddEdit.h"
#import "Combat.h"
#import "Constants.h"
#import "CoreDataHelper.h"


@interface CharacterList ()

@end

@implementation CharacterList

@synthesize managedObjectContext, characters, selectedCharacter, activity;

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
	
	self.title = @"CHARACTERS";
	
	self.navigationController.navigationBar.translucent = NO;
	
	self.tableView.rowHeight = 80;
	self.view.backgroundColor = TABLEBG;
	self.tableView.backgroundColor = TABLEBG;
	
	activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activity.center = CGPointMake(self.parentViewController.view.frame.size.width/2, self.parentViewController.view.frame.size.height/2);
	activity.hidesWhenStopped = YES;
	[[UIApplication sharedApplication].windows.firstObject addSubview:activity];
}

-(void)viewWillAppear:(BOOL)animated
{
	[self readDataForTable];
	
	if (characters.count < 6 ) {
		self.tableView.scrollEnabled = NO;
	}
	else
		self.tableView.scrollEnabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[activity stopAnimating];
}

-(void)readDataForTable
{	
	// Force table refresh
	[self.tableView reloadData];
}

-(void)accessoryButton:(UIControl *)button withEvent:(UIEvent *)event
{
    UITableViewCell *cell = (UITableViewCell*)[button superview];
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    [self.tableView.delegate tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:ip];
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
    return characters.count;
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
	
    // Get the core data object we need to use to populate this cell
	Character *currentCharacter = [characters objectAtIndex:indexPath.row];
	
	// Fill in the cell contents
	UILabel *name = (UILabel*)[cell viewWithTag:2];
	name.text = currentCharacter.name;
	
	UILabel *raceClass = (UILabel*)[cell viewWithTag:3];
	raceClass.text = [NSString stringWithFormat:@"%@ %@",currentCharacter.race, currentCharacter.classname];
	
	// If a picture exists then use it
	if (currentCharacter.photo) {
		UIImageView *photoView = (UIImageView*)[cell viewWithTag:1];
		photoView.image = [UIImage imageWithData:currentCharacter.photo];
		photoView.layer.borderColor = [[UIColor colorWithWhite:0.6f alpha:1.0f] CGColor];
		photoView.layer.borderWidth = 1;
		photoView.clipsToBounds = NO;
	}
		
	name.font = MISSION(27.0f);
	name.textColor = GRAY;
	name.highlightedTextColor = GRAY;
	name.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	name.layer.shadowOffset = CGSizeMake(0,1);
	name.layer.shadowRadius = 0;
	name.layer.shadowOpacity = 1;
	
	raceClass.font = ARVIL(22.0f);
	raceClass.textColor = GRAY;
	raceClass.highlightedTextColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	raceClass.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	raceClass.layer.shadowOffset = CGSizeMake(0,1);
	raceClass.layer.shadowRadius = 0;
	raceClass.layer.shadowOpacity = 1;
	
	// setup the edit button accessory
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"edit-icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(accessoryButton:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
	
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// Get a reference to the table item in our data array
		Character *characterToDelete = [characters objectAtIndex:indexPath.row];
		
		// Delete the item in core data
		[managedObjectContext deleteObject:characterToDelete];
		
		// Remove the item from our array
		[characters removeObjectAtIndex:indexPath.row];
		
		// Commit the deletion in core data
		NSError *error;
		if (![managedObjectContext save:&error])
			NSLog(@"Failed to delete character with error: %@", error.domain);
		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		// reset scroll enabled
		if (characters.count < 6)
			self.tableView.scrollEnabled = NO;
		else
			self.tableView.scrollEnabled = YES;
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[activity startAnimating];
	selectedCharacter = [characters objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"PlayCharacter" sender:self];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	selectedCharacter = [characters objectAtIndex:indexPath.row];
	[self performSegueWithIdentifier:@"EditCharacter" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddCharacter"])
	{
		CharacterAddEdit *characterAdd = segue.destinationViewController;
		characterAdd.managedObjectContext = managedObjectContext;
		characterAdd.title = @"NEW CHARACTER";
		characterAdd.navigationItem.hidesBackButton = YES;
		characterAdd.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:characterAdd action:@selector(cancel)];
		[characterAdd.navigationItem setBackBarButtonItem:nil];
	}
	else if ([segue.identifier isEqualToString:@"EditCharacter"])
	{
		CharacterAddEdit *characterEdit = segue.destinationViewController;
		characterEdit.managedObjectContext = managedObjectContext;
		characterEdit.character = selectedCharacter;
		characterEdit.title = @"EDIT CHARACTER";
		characterEdit.editing = YES;
		characterEdit.delegate = self;
		characterEdit.navigationItem.hidesBackButton = YES;
		characterEdit.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStylePlain target:characterEdit action:@selector(cancel)];
		[characterEdit.navigationItem setBackBarButtonItem:nil];
	}
	else if ([segue.identifier isEqualToString:@"PlayCharacter"])
	{
		UINavigationController *combatNavController = segue.destinationViewController;
		Combat *combat = combatNavController.viewControllers.firstObject;
		combat.managedObjectContext = managedObjectContext;
		combat.character = selectedCharacter;		
	}
}

/* !CharacterAddEditDelegate Methods
 * ---------------------------------------------*/
-(void)characterAddEditDidFinish
{
	self.editing = NO;
}

@end
