//
//  Gold.h
//  Bandit4e
//
//  Created by Cameron Lockey on 2/23/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@protocol GoldDelegate;

@interface Gold : UIViewController
{
	int	amount;
	int	total;
}

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (weak,nonatomic) id <GoldDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *currentGoldLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UITextField *goldField;
@property (weak, nonatomic) IBOutlet UISwitch *spendSwitch;
@property (weak, nonatomic) IBOutlet UILabel *spendLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)resolveGold:(id)sender;
- (IBAction)switchToSpend:(id)sender;
- (IBAction)goldChanged:(id)sender;
- (void)updateCommitButton;
- (void)updateTotal;
- (void)updateGoldLabel;

@end

@protocol GoldDelegate <NSObject>

-(void)didAddGold;

@end
