//
//  MYPersonTableViewCell.m
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/21.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ViewOriginY (IS_iOS7 ? 64:0)
#import "MYPersonTableViewCell.h"
#import "Masonry.h"
#import <BmobSDK/Bmob.h>
#import "UIImageView+WebCache.h"
@implementation MYPersonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _MYtextlabel = [[UILabel alloc] init];
        _MYtextlabel.font = [UIFont systemFontOfSize:15.0f];

        _MYtextlabel.text = @"text";
        [self.contentView addSubview:_MYtextlabel];
        
        _MYdetailLabel = [[UILabel alloc] init];
        _MYdetailLabel.font = [UIFont systemFontOfSize:10.0f];

        _MYdetailLabel.text = @"detail";
        [self.contentView addSubview:_MYdetailLabel];
        
        _MYimageView = [[UIImageView alloc]init];
        _MYimageView.image = [UIImage imageNamed:@"baobiao@3x.png"];
        [self.contentView addSubview:_MYimageView];
        WS(ws);
        [_MYimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.top.mas_equalTo(ws.mas_top).with.offset(10);
        }];
        [_MYtextlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_MYimageView.mas_right).with.offset(15);
            make.centerY.mas_equalTo(_MYimageView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        [_MYdetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_MYimageView.mas_right).with.offset(15);
            make.top.mas_equalTo(_MYtextlabel.mas_bottom);
            make.centerX.mas_equalTo(_MYtextlabel.mas_centerX);
        }];
    }
    return self;
}

- (void)setMYtextlabel:(NSString *)text andMYdetailLabel:(NSString *)detail andURL:(NSURL *)url{
    _MYtextlabel.text = text;
    _MYdetailLabel.text = detail;
    [_MYimageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"baobiao@3x.png"]];
    [_MYimageView.layer setCornerRadius:30];
    
    [_MYimageView.layer setMasksToBounds:YES];
}

@end
