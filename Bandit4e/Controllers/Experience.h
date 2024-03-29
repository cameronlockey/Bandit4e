//
//  Experience.h
//  Bandit4e
//
//  Created by Cameron Lockey on 2/18/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@protocol ExperienceDelegate;

@interface Experience : UIViewController
{
	int amount;
}

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) Character *character;
@property (weak,nonatomic) id <ExperienceDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentExperienceLabel;
@property (weak, nonatomic) IBOutlet UITextField *experienceField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gainButton;

- (IBAction)cancel:(id)sender;
- (IBAction)gainExperience:(id)sender;
- (IBAction)experienceChanged:(id)sender;
@end

@protocol ExperienceDelegate <NSObject>

-(void)didGainExperience;

@end
