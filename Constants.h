//
//  Constants.h
//  Bandit4e
//
//  Created by Cameron Lockey on 2/23/13.
//  Copyright (c) 2013 Fragment. All rights reserved.
//

#import <Foundation/Foundation.h>

// app id
#define APP_ID				796453985
static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";

#define APP_STORE_URL		[NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, APP_ID]];

// set up fonts
#define LEAGUE(fontsize)	[UIFont fontWithName:@"League Gothic" size:fontsize]
#define ARVIL(fontsize)		[UIFont fontWithName:@"Arvil" size:fontsize]
#define MISSION(fontsize)	[UIFont fontWithName:@"Mission Script" size:fontsize]
				
// set up colors
#define GRAY				[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1.0]
#define RED					[UIColor colorWithRed:0.55 green:0.05 blue:0.05 alpha:1]
#define YELLOW				[UIColor colorWithRed:0.63 green:0.58 blue:0.13 alpha:1]

// conditions
#define BLOODIED			character.maxHp.intValue*0.5
#define NEG_BLOODIED		-1*BLOODIED
#define FAILED_SAVES		character.failedSaves.intValue == 3
#define IS_BLOODIED			character.currentHp.intValue <= character.maxHp.intValue*0.5
#define IS_DYING			character.currentHp.intValue <= 0
#define IS_DEAD				character.currentHp.intValue <= NEG_BLOODIED || FAILED_SAVES


#define VIEWBG				[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]
#define TABLEBG				[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableBg.png"]]

@interface Constants : NSObject

+ (void)save:(NSManagedObjectContext*)managedObjectContext;

@end


