//
//  RLTableViewCell.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/17.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RLTableViewCell.h"

@interface RLTableViewCell()
@property (nonatomic) UILabel *text;
@property (nonatomic) UILabel *idLabel;
@end

@implementation RLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _text = [[UILabel alloc]initWithFrame:CGRectMake(30.0f, 30.0f, 200.0f, 70.0f)];
    _text.text = _items.text;
    [self addSubview:_text];
    
    _idLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 30.0f, 200.0f, 70.0f)];
    _idLabel.text = [NSString stringWithFormat:@"%@", _items.postId];
    [self addSubview:_idLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
