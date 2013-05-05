//
//  ConditionsList.m
//  Bandit4e
//
//  Created by Cameron Lockey on 3/17/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import "Character.h"
#import "Condition.h"
#import "ConditionsList.h"
#import "ConditionAdd.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@interface ConditionsList ()

@end

@implementation ConditionsList

@synthesize character, managedObjectContext, durations, types;

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
	
	// set title
	self.title = @"CONDITIONS";
	
	self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableBg.png"]];
	
	// set up conditions types
	types = [NSArray arrayWithObjects:@"Ongoing Damage", @"Asleep", @"Blinded", @"Dazed", @"Deafened", @"Dominated", @"Helpless", @"Immobilized", @"Petrified", @"Prone", @"Restrained", @"Slowed", @"Stunned", @"Unconscious", @"Weakened", nil];
	
	// set up conditions durations
	durations = [NSArray arrayWithObjects:@"Start of Turn (SOT)", @"End of Turn (EOT)", @"Save Ends", @"End of Encounter (EOE)", @"# of Turns", nil];
	
	
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
    return 5;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [durations objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    // Return the number of rows in the section.
	
	int count = 0;
	for (Condition *condition in character.conditions) {
		if (condition.duration.intValue == section) {
			count++;
		}
	}
	
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// Draw top border only on first cell
	if (indexPath.row == 0) {
		UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
		topLineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
		[cell addSubview:topLineView];
	}
	else
	{
		UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
		topLineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
		[cell addSubview:topLineView];
	}
	
	UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, self.view.bounds.size.width, 1)];
	bottomLineView.backgroundColor = [UIColor colorWithWhite:0.45 alpha:1.0];
	[cell addSubview:bottomLineView];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

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

/* !PrepareForSegue
 * ---------------------------------------------*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddCondition"]) {
		ConditionAdd *condtionAdd = segue.destinationViewController;
		condtionAdd.delegate = self;
		condtionAdd.character = character;
		condtionAdd.managedObjectContext = managedObjectContext;
	}
}

/* !ConditionAddDelegate
 * ---------------------------------------------*/
-(void)conditionAddDidFinish
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)conditionAddDidCancel
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
