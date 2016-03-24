//
//  regTableViewCell.m
//  SKLogin
//
//  Created by User on 3/17/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "regTableViewCell.h"

@implementation regTableViewCell

- (void)awakeFromNib {
    self.keyLabel.adjustsFontSizeToFitWidth = YES;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
}

@end
