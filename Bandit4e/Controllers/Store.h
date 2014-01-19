//
//  Store.h
//  Bandit4e
//
//  Created by Cameron Lockey on 1/18/14.
//  Copyright (c) 2014 Fragment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface Store : UIViewController

@property (strong,nonatomic) NSArray  *products;
@property (strong,nonatomic) SKProduct *fullVersion;

@property (weak, nonatomic) IBOutlet UITextView *productDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UILabel *restoreDescription;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

- (IBAction)cancel:(id)sender;
- (IBAction)purchaseFullVersion:(id)sender;
- (IBAction)restorePurchases:(id)sender;
@end
