//
//  Damage.h
//  Bandit4e
//
//  Created by Cameron Lockey on 2/10/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@protocol DamageDelegate;

@interface Damage : UIViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (weak,nonatomic) id <DamageDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISwitch *loseSurgeSwitch;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UILabel *loseSurgeLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takeDamageButton;
- (IBAction)takeDamage:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)damageChanged:(id)sender;
@end

@protocol DamageDelegate <NSObject>

-(void)didTakeDamage:(BOOL)amount Surge:(BOOL)surge;

@end
