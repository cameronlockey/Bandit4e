//
//  CharacterList.h
//  Bandit4e
//
//  Created by Cameron Lockey on 12/8/12.
//  Copyright (c) 2012 Fragment. All rights reserved.
//

#import <iAd/iAd.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CharacterAddEdit.h"
#import "IAPBanditHelper.h"

@class Character;

@interface CharacterList : UIViewController <ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource, CharacterAddEditDelegate>
{
	UIImageView *banditTitle;
	NSArray *productIdentifiers;
	NSArray *products;
	BOOL hasFullVersion;
	BOOL bannerShowing;
}

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSMutableArray *characters;
@property (strong,nonatomic) UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *purchaseButton;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftSeparator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightSeparator;

@property (strong,nonatomic) Character *selectedCharacter;

-(void)readDataForTable;
-(void)accessoryButton:(UIControl*)button withEvent:(UIEvent*)event;
- (IBAction)showStore:(id)sender;
- (IBAction)addNewCharacter:(id)sender;
- (IBAction)rateApp:(id)sender;


@end
