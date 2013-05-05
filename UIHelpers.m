
/*
 Copyright 2011 Ahmet Ardal
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

//
//  UIHelpers.m
//  Trendle
//
//  Created by Ahmet Ardal on 6/25/10.
//  Copyright 2010 SpinningSphere Labs. All rights reserved.
//

#import "UIHelpers.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIHelpers

#pragma mark -
#pragma mark UIAlertView showing Methods

+ (void) showAlertWithTitle:(NSString *)title
                        msg:(NSString *)msg
                buttonTitle:(NSString *)btnTitle
						tag:(int)tag
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:btnTitle
                                       otherButtonTitles:nil];
	[av setTag:tag];
    [av show];
}

+ (void) showAlertWithTitle:(NSString *)title
{
    [UIHelpers showAlertWithTitle:title
								msg:nil
						buttonTitle:NSLocalizedString(@"OK", @"ok")
								tag:nil];
}

+ (void) showAlertWithTitle:(NSString *)title
                        msg:(NSString *)msg
{
    [UIHelpers showAlertWithTitle:title
                              msg:msg
                      buttonTitle:NSLocalizedString(@"OK", @"ok")
							  tag:nil];
}

+ (void) showConfirmWithTitle:(NSString *)title msg:(NSString *)msg delegate:(UIViewController*)delegate tag:(int)tag
{
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:msg
                                                delegate:delegate
                                       cancelButtonTitle:@"No"
                                       otherButtonTitles:@"Yes", nil];
	
	[av setTag:tag];
	[av show];
}

+ (void) applyTextShadow:(UILabel*)label
{
	label.layer.shadowColor = [[UIColor colorWithWhite:1.0f alpha:0.6f] CGColor];
	label.layer.shadowOffset = CGSizeMake(0,1);
	label.layer.shadowRadius = 0;
	label.layer.shadowOpacity = 1;
}

@end
