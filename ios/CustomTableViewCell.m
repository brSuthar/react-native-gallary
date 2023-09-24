//
//  CustomTableViewCell.m
//  card_input
//
//  Created by Bhoma ram on 24/09/23.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize and customize your cell's UI elements here
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel; // You can create a property for easy access
    }
    return self;
}

@end
