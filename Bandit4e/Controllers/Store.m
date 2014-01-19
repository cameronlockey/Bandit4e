//
//  Store.m
//  Bandit4e
//
//  Created by Cameron Lockey on 1/18/14.
//  Copyright (c) 2014 Fragment. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "IAPBanditHelper.h"
#import "Store.h"
#import "UIHelpers.h"

@interface Store ()

@end

@implementation Store

@synthesize purchaseButton, fullVersion, productDescriptionLabel, products, restoreButton, restoreDescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBar.translucent = NO;
	self.view.backgroundColor = VIEWBG;
	
	// get fullVersion product from products array
	fullVersion = products.firstObject;
	
	// set up labels with product info
	productDescriptionLabel.text = fullVersion.localizedDescription;
	productDescriptionLabel.font = [UIFont systemFontOfSize:16.0];
	productDescriptionLabel.textAlignment = NSTextAlignmentCenter;
	productDescriptionLabel.textColor = GRAY;
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:fullVersion.priceLocale];
	NSString *formattedPrice = [numberFormatter stringFromNumber:fullVersion.price];
	[purchaseButton setTitle:[NSString stringWithFormat:@"%@ %@", fullVersion.localizedTitle, formattedPrice].uppercaseString forState:UIControlStateNormal];
	purchaseButton.titleLabel.font = LEAGUE(30);
	UIEdgeInsets insets = UIEdgeInsetsMake(3, 0, 0, 0);
	[purchaseButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[purchaseButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
	[purchaseButton setTitleEdgeInsets:insets];
	purchaseButton.backgroundColor = [UIColor colorWithRed:0.04 green:0.64 blue:0 alpha:1.0];
	purchaseButton.titleLabel.layer.shadowOffset = CGSizeMake(0, -0.75);
	purchaseButton.titleLabel.layer.shadowOpacity = 1;
	purchaseButton.titleLabel.layer.shadowColor = [UIColor colorWithRed:0.01 green:0.16 blue:0 alpha:1.0].CGColor;
	purchaseButton.titleLabel.layer.shadowRadius = 0;
	purchaseButton.layer.cornerRadius = 4.0f;
	purchaseButton.layer.shadowColor = [UIColor colorWithRed:0.02 green:0.32 blue:0 alpha:1.0].CGColor;
	purchaseButton.layer.shadowOffset = CGSizeMake(0, 1.5);
	purchaseButton.layer.shadowRadius = 0;
	purchaseButton.layer.shadowOpacity = 1;
	purchaseButton.layer.masksToBounds = NO;
	
	
	insets = UIEdgeInsetsMake(2, 0, 0, 0);
	[restoreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
	[restoreButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
	[restoreButton setTitleEdgeInsets:insets];
	restoreDescription.textColor = GRAY;
	restoreButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
	restoreButton.titleLabel.font = LEAGUE(18);
	restoreButton.titleLabel.layer.shadowOffset = CGSizeMake(0, -0.5);
	restoreButton.titleLabel.layer.shadowOpacity = 1;
	restoreButton.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
	restoreButton.titleLabel.layer.shadowRadius = 0;
	restoreButton.layer.cornerRadius = 4.0f;
	restoreButton.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:1].CGColor;
	restoreButton.layer.shadowOffset = CGSizeMake(0, 1);
	restoreButton.layer.shadowRadius = 0;
	restoreButton.layer.shadowOpacity = 1;
	restoreButton.layer.masksToBounds = NO;
	
}

-(void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)purchaseFullVersion:(id)sender
{
	[[IAPBanditHelper sharedInstance] buyProduct:fullVersion];
}

- (IBAction)restorePurchases:(id)sender
{
	[[IAPBanditHelper sharedInstance] restoreCompletedTransactions];
}

/* !IAPHelperProductPurchasedNotification Callback
 * ---------------------------------------------*/
- (void)productPurchased:(NSNotification *)notification
{
	
    NSString * productIdentifier = notification.object;
    [self dismissViewControllerAnimated:YES completion:NULL];
	NSLog(@"Successfully purchased %@!", productIdentifier);
}
@end
