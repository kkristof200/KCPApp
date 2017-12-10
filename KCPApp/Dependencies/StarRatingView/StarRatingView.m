//
//  RatingView.m
//  StarRatingView
//
//  Created by liaojinxing on 14-5-4.
//  Copyright (c) 2014年 jinxing. All rights reserved.
//

#import "StarRatingView.h"

@interface StarRatingView ()

@property (nonatomic, strong) NSMutableArray *starButtons;
@property (nonatomic, copy) StarRatingViewAction ratingAction;
@property (nonatomic, strong, readwrite) StarRatingViewConfiguration *configuration;

@end

@implementation StarRatingViewConfiguration

@end


@implementation StarRatingView

- (nullable instancetype)initWithFrame:(CGRect)frame configuration:(nonnull StarRatingViewConfiguration *)configuration {
    if (!configuration.fullImage || !configuration.emptyImage || !configuration.halfImage) {
        return nil;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        _starButtons = [[NSMutableArray alloc] initWithCapacity:5];
        
        for (int i = 0; i < 5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button.tag = i;
            [button setUserInteractionEnabled:configuration.rateEnabled];
            
            if (configuration.rateEnabled) {
                [button  addTarget:self action:@selector(rate:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self addSubview:button];
            [_starButtons addObject:button];
        }
        
        self.configuration = configuration;
        
        [self updateFrame:self.frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateFrame:frame];
}

- (void)updateFrame:(CGRect)frame {
    CGFloat starWidth = self.configuration.starWidth? self.configuration.starWidth: 16;
    CGFloat distBetweenStars = (self.frame.size.width - (5 * starWidth)) / 4;
    
    for (NSUInteger i = 0; i < self.starButtons.count; i++) {
        UIButton *button = self.starButtons[i];
        button.frame = CGRectMake((starWidth + distBetweenStars) * i, 0, starWidth, starWidth);
    }
}

- (void)rate:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self setRating:button.tag + 1];
}

- (void)setRating:(CGFloat)rating completion:(nullable StarRatingViewAction)completion {
    [self setRating:rating];
    if (completion) {
        completion();
    }
}

- (void)setRating:(CGFloat)rating {
    _rating = rating;
    UIImage *starFull = self.configuration.fullImage;
    UIImage *starHalf = self.configuration.halfImage;
    UIImage *starEmpty = self.configuration.emptyImage;
    
    rating = round(rating * 2) / 2;
    int fullStars = floor(rating);
    int i;
    for (i = 0; i < fullStars; i++) {
        UIButton *button = [_starButtons objectAtIndex:i];
        [button setImage:starFull forState:UIControlStateNormal];
    }
    
    if (rating - fullStars >= 0.5) {
        UIButton *button = [_starButtons objectAtIndex:fullStars];
        [button setImage:starHalf forState:UIControlStateNormal];
        i++;
    }
    
    for (; i < 5; i++) {
        UIButton *button = [_starButtons objectAtIndex:i];
        [button setImage:starEmpty forState:UIControlStateNormal];
    }
}

@end
