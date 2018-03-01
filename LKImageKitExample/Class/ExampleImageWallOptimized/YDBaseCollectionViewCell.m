//
//  YDBaseCollectionViewCell.m
//  LKImageViewExample
//
//  Created by mac on 1/3/18.
//  Copyright © 2018年 lingtonke. All rights reserved.
//

#import "YDBaseCollectionViewCell.h"

@implementation YDBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.imageView) {
            self.imageView = [UIImageView new];
            self.imageView.frame = CGRectMake(0.f, 0.f, self.bounds.size.width, self.bounds.size.height);
            [self.contentView addSubview:self.imageView];
        }
    }
    return self;
}

@end
