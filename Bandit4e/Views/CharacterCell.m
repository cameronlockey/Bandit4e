//
//  CharacterCell.m
//  Bandit4e
//
//  Created by Cameron Lockey on 1/16/14.
//  Copyright (c) 2014 Fragment. All rights reserved.
//

#import "CharacterCell.h"

@implementation CharacterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
