/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "AddFriendCell.h"
#import "Masonry.h"
@implementation AddFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _addLabel = [[UILabel alloc] init];
        _addLabel.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0];
        _addLabel.textAlignment = NSTextAlignmentCenter;
        _addLabel.text = NSLocalizedString(@"add", @"Add");
        _addLabel.textColor = [UIColor whiteColor];
        _addLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_addLabel];
        [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.centerY.equalTo(@0);
            
        }];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.textLabel.frame;
    rect.size.width -= 70;
    self.textLabel.frame = rect;
    
    rect = _addLabel.frame;
    rect.origin.y = (self.frame.size.height - 30) / 2;
    _addLabel.frame = rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
