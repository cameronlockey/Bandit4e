//
//  Heal.h
//  Bandit4e
//
//  Created by Cameron Lockey on 2/11/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@protocol HealDelegate;

@interface Heal : UIViewController
{
	int		surgesToUse;
	int		additional;
	int		newHP;
	int		newCurrentSurges;
	int		selectedSegment;
}

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (weak,nonatomic) id <HealDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *numSurgesSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *additionalHealingField;
@property (weak, nonatomic) IBOutlet UITextField *regainSurgesField;

- (IBAction)cancel:(id)sender;
- (IBAction)heal:(id)sender;
@end

@protocol HealDelegate <NSObject>

-(void)didHealDamage;

@end
