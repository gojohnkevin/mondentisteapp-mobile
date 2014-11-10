//
//  AGBooksTableViewCell.m
//  DrElbaz
//
//  Created by Kevin Go on 9/3/14.
//  Copyright (c) 2014 Argo Technologies. All rights reserved.
//

#import "AGBooksTableViewCell.h"

@implementation AGBooksTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
