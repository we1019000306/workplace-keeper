//
//  MYPersonTableViewCell.h
//  职场管家ERP
//
//  Created by Jackie Liu on 15/11/21.
//  Copyright © 2015年 Jackie Liu. All rights reserved.
//


@interface MYPersonTableViewCell : UITableViewCell
{
    UILabel *_MYtextlabel;
    UILabel *_MYdetailLabel;
    UIImageView *_MYimageView;
}
- (void)setMYtextlabel:(NSString *)text andMYdetailLabel:(NSString *)detail andURL:(NSURL *)url;

@end
