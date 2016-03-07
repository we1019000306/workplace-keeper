//
//  MYAnnouncementViewController.m
//  职场管家
//
//  Created by Jackie Liu on 16/2/20.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import "MYAnnouncementViewController.h"

@interface MYAnnouncementViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,strong) NSString *imgURL;
@end

@implementation MYAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel =  [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.contentLabel];
    WS(ws);
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.imgView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];

    if (self.titleStr) {
        self.titleLabel.text = self.titleStr;
    }
    if (self.contentStr) {
        self.contentLabel.text = self.contentStr;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.lineSpacing = 3;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        
        NSDictionary *dict = @{NSFontAttributeName :[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paraStyle.copy};
        
        NSAttributedString *atrributes = [[NSAttributedString alloc] initWithString:self.contentLabel.text attributes:dict];
        self.contentLabel.attributedText = atrributes;
    }
    if (self.imgURL) {
         [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgURL] placeholderImage:[UIImage imageNamed:@"ZhiGuan.png"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewsWithTitle:(NSString *)title Content:(NSString *)content imgURL:(NSString *)imgUrl{
    NSLog(@"%@",title);
    NSLog(@"%@",content);
    self.titleStr = [[NSString alloc]initWithString:title];
    self.contentStr = [[NSString alloc]initWithString:content];
    self.imgURL = [[NSString alloc]initWithString:imgUrl];
   
}


@end
