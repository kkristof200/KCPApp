//
//  KCPViewController.m
//  AIOFW
//
//  Created by Kovács Kristóf on 09/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "KCPViewController.h"

#import "KCPManager.h"
#import "UIView+Facade.h"
#import "UIColor+AIOColors.h"
#import "UIView+AIOUtils.h"
#import "UIImage+AIOUtils.h"

#import "AIOUtils.h"
#import <QuartzCore/QuartzCore.h>

#import "TACloseButton.h"

#import "StarRatingView.h"

@interface KCPViewController ()

@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIImageView *screenShotImageViewLeft;
@property(nonatomic, strong) UIImageView *screenShotImageViewRight;

@property(nonatomic, strong) UIVisualEffectView *visualEffectView;
@property(nonatomic, strong) UIView *separatorView;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *installButton;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) StarRatingView *starRatingView;
@property (nonatomic, strong) UILabel *ratingNrView;

@property (nonatomic, strong) KCPApp *app;

@property (nonatomic, assign) unsigned int reviewCount;
@property (nonatomic, assign) float avgReview;

@end

@implementation KCPViewController

static const float kReviewLimit = 2.6;

- (nullable instancetype)initWithApp:(KCPApp *)app {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.app = app;
    [self setReviews];
    
    return self;
}

- (void)setReviews {
    if (self.app.averageUserRating > self.app.averageUserRatingForCurrentVersion) {
        self.avgReview = self.app.averageUserRating;
        self.reviewCount = self.app.userRatingCount;
    } else {
        self.avgReview = self.app.averageUserRatingForCurrentVersion;
        self.reviewCount = self.app.userRatingCountForCurrentVersion;
    }
}

- (BOOL)shouldShowReviews {
    return self.avgReview > kReviewLimit;
}

- (void)animateButton {
    [self.installButton startWithAnimationType:AIOAnimationTypeFlashDarkLight
                                     frequency:.5];
}

- (void)viewWillAppear:(BOOL)animated {
    [self animateButton];
    
    [NSNotificationCenter.defaultCenter addObserverForName:UIApplicationDidBecomeActiveNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull note) {
                                                    [self.installButton.layer removeAllAnimations];
                                                    self.installButton.backgroundColor = [UIColor colorWithAverageColorFromImage:self.screenShotImageViewLeft.image withAlpha:1];
                                                    [self animateButton];
                                                }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSubViews];
}

- (void)setSubViews {
    self.bgImageView = [UIImageView new];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.image = self.app.iconImage;
    self.bgImageView.clipsToBounds = YES;

    self.screenShotImageViewLeft = [UIImageView new];
    self.screenShotImageViewLeft.contentMode = UIViewContentModeScaleToFill;
    self.screenShotImageViewLeft.image = (UIImage *)self.app.screenShots[0];
    self.screenShotImageViewLeft.clipsToBounds = YES;
    
    if (self.app.screenShots.count > 1) {
        self.screenShotImageViewRight = [UIImageView new];
        self.screenShotImageViewRight.contentMode = UIViewContentModeScaleToFill;
        self.screenShotImageViewRight.image = (UIImage *)self.app.screenShots[1];
        self.screenShotImageViewRight.clipsToBounds = YES;
    }
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 4.0f * [self screenMulti];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.image = self.app.iconImage;
    
    self.closeButton = [[TACloseButton alloc] init];
    [self.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.installButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.installButton setTitle:[NSString stringWithFormat:@"Get for %@", self.app.formattedPrice]
                        forState:UIControlStateNormal];
    [self.installButton addTarget:self action:@selector(installButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.installButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.85 blue:0.39 alpha:1];
    
    self.separatorView = [UIView new];
    
    CGFloat fontMulti = [self screenMulti];
    
    [self.installButton setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    self.installButton.titleLabel.font = [UIFont boldSystemFontOfSize:22 * fontMulti];
    self.installButton.layer.cornerRadius = 2;
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.app.name;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20 * fontMulti];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    UIColor *avgColor = [UIColor colorWithAverageColorFromImage:self.screenShotImageViewLeft.image
                                                      withAlpha:1];
    self.installButton.backgroundColor = avgColor;
    self.separatorView.backgroundColor = avgColor;
    self.iconImageView.layer.borderColor = avgColor.CGColor;
    
    UIColor *bwColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:self.installButton.backgroundColor isFlat:YES];
    
    self.nameLabel.textColor = bwColor;
    self.installButton.titleLabel.textColor = bwColor;
    
    UIBlurEffectStyle style;
    
    if (bwColor.dark) {
        style = UIBlurEffectStyleExtraLight;
    } else {
        style = UIBlurEffectStyleDark;
    }
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:style];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    UIColor *visualColor = [UIColor colorWithAverageColorFromImage:self.iconImageView.image];
    self.visualEffectView.backgroundColor = visualColor;
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.screenShotImageViewLeft];
    [self.view addSubview:self.screenShotImageViewRight];
    [self.view addSubview:self.visualEffectView];
    [self.view addSubview:self.separatorView];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.installButton];
    [self.view addSubview:self.nameLabel];
    
    if ([self shouldShowReviews]) {
        StarRatingViewConfiguration *config = [StarRatingViewConfiguration new];
        
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        
        UIImage *fullImage = [UIImage imageNamed:@"star_full.png"
                                        inBundle:currentBundle
                   compatibleWithTraitCollection:nil];
        fullImage = [fullImage coloredImage:bwColor];
        
        UIImage *halfImage = [UIImage imageNamed:@"star_half.png"
                                        inBundle:currentBundle
                   compatibleWithTraitCollection:nil];
        halfImage = [halfImage coloredImage:bwColor];
        
        UIImage *emptyImage = [UIImage imageNamed:@"star_empty_framed.png"
                                         inBundle:currentBundle
                    compatibleWithTraitCollection:nil];
        emptyImage = [emptyImage coloredImage:bwColor];

        config.rateEnabled = NO;
        config.fullImage = fullImage;
        config.halfImage = halfImage;
        config.emptyImage = emptyImage;
        config.starWidth = 20;
        
        self.starRatingView = [[StarRatingView alloc] initWithFrame:CGRectZero configuration:config];
        self.starRatingView.rating = (CGFloat)self.avgReview;
        
        [self.view addSubview:self.starRatingView];
        
        self.ratingNrView = [[UILabel alloc] init];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.usesSignificantDigits = NO;
        formatter.usesGroupingSeparator = YES;
        formatter.groupingSeparator = @",";
        
        NSString *ratingCountText = [formatter stringFromNumber:@( self.reviewCount)];
        
        self.ratingNrView.text = [NSString stringWithFormat:@"  %@", ratingCountText];
        self.ratingNrView.textColor = bwColor;
        self.ratingNrView.alpha = .5f;
        self.ratingNrView.font = [UIFont boldSystemFontOfSize:10 * fontMulti];
        self.ratingNrView.numberOfLines = 1;
        self.ratingNrView.textAlignment = NSTextAlignmentLeft;
        
        self.ratingNrView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        
        [self.view addSubview:self.ratingNrView];
    }
    
    [self setUpView];
}

- (void)orientationChanged {
    [self setUpView];
}

- (void)viewDidLayoutSubviews {
    self.iconImageView.layer.cornerRadius = CGRectGetWidth(self.iconImageView.frame)/8;
    [super viewDidLayoutSubviews];
}


#pragma mark - Actions

- (void)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)installButtonAction:(id)sender {
    [self.installButton setTitle:@"Opening" forState:UIControlStateNormal];
    self.installButton.enabled = YES;
    
    [self animateOut:^(BOOL finished) {
        NSURL *appUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%.0lu", self.app.id]];
        [UIApplication.sharedApplication openURL:appUrl];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)animateOut:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:.15
                     animations:^{
                         self.nameLabel.alpha = 0;
                         self.installButton.alpha = 0;
                         self.closeButton.alpha = 0;
                         self.starRatingView.alpha = 0;
                         self.ratingNrView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.35
                                          animations:^{
                                              self.visualEffectView.frame = self.view.frame;
                                              self.iconImageView.center = self.view.center;
                                              
                                              if (AIOUtils.isPortraitOrientation) {
                                                  CGRect frame = self.separatorView.frame;
                                                  frame.origin.y = 0;
                                                  self.separatorView.frame = frame;
                                              } else {
                                                  CGRect frame = self.separatorView.frame;
                                                  frame.origin.x = self.view.xMax - self.separatorView.width;
                                                  self.separatorView.frame = frame;
                                              }
                                              self.separatorView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:.5
                                                               animations:^{
                                                                   self.iconImageView.layer.borderColor = [UIColor clearColor].CGColor;
                                                                   self.iconImageView.transform = CGAffineTransformMakeScale(15, 15);
                                                                   self.iconImageView.layer.cornerRadius = self.iconImageView.width / 2;
                                                                   self.iconImageView.alpha = 0;
                                                               } completion:^(BOOL finished) {
                                                                   completion(YES);
                                                               }];
                                          }];
                     }];
}

#pragma mark - Private

- (void)setUpView {
    self.bgImageView.frame = self.view.frame;
    self.screenShotImageViewLeft.contentMode = UIViewContentModeScaleToFill;

    CGFloat screenMulti = [self screenMulti];
    CGSize logoSize = CGSizeMake(screenMulti * 128, screenMulti * 128);
    CGFloat labelHeight = screenMulti * 35;
    CGFloat buttonHeight = 50;
    CGFloat separatorThickness = screenMulti * 4;
    
    self.closeButton.frame = CGRectMake(self.view.width - screenMulti * 10 - buttonHeight,
                                        screenMulti * 10,
                                        buttonHeight,
                                        buttonHeight);
    
    buttonHeight *= screenMulti;
    
    if (AIOUtils.isPortraitOrientation) {
        if (!self.screenShotImageViewLeft.image.isPortrait) {
            self.screenShotImageViewLeft.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        self.screenShotImageViewRight.hidden = YES;
        
        self.visualEffectView.frame = CGRectMake(0,
                                                 self.view.height * .75,
                                                 self.view.width,
                                                 self.view.height * .25);
        
        self.separatorView.frame = CGRectMake(0,
                                              self.visualEffectView.yMin,
                                              self.visualEffectView.width,
                                              separatorThickness);
        
        self.screenShotImageViewLeft.frame = self.view.frame;
        self.iconImageView.frame = CGRectMake((self.view.width - logoSize.width) / 2,
                                              self.visualEffectView.yMin - logoSize.height / 2,
                                              logoSize.width,
                                              logoSize.height);
        self.nameLabel.frame = CGRectMake(screenMulti * 0 + 5,
                                          self.iconImageView.yMax,
                                          self.view.width - (10 + separatorThickness),
                                          labelHeight);
        self.installButton.frame = CGRectMake(screenMulti * 0,
                                              self.view.yMax - buttonHeight,
                                              self.view.width,
                                              buttonHeight);
    } else {
        CGFloat ssMulti = self.view.height / self.view.width;
        CGFloat ssWidth = self.view.height * ssMulti;
        
        if (self.app.screenShots.count > 1) {
            self.screenShotImageViewRight.hidden = NO;
            
            if (!self.screenShotImageViewLeft.image.isPortrait) {
                if (AIOUtils.isPhone) {
                    ssWidth *= 2;
                }
                
                self.screenShotImageViewRight.frame = CGRectMake(self.view.width - ssWidth,
                                                                 screenMulti * 0,
                                                                 ssWidth,
                                                                 self.view.height / 2);
                self.screenShotImageViewLeft.frame = CGRectMake(self.view.width - ssWidth,
                                                                self.view.height / 2,
                                                                ssWidth,
                                                                self.view.height / 2);
            } else {
                if (AIOUtils.isPhone) {
                    self.screenShotImageViewRight.frame = CGRectMake(self.view.width - ssWidth,
                                                                     screenMulti * 0,
                                                                     ssWidth,
                                                                     self.view.height);
                    self.screenShotImageViewLeft.frame = CGRectMake(self.screenShotImageViewRight.xMin - ssWidth,
                                                                    screenMulti * 0,
                                                                    ssWidth,
                                                                    self.view.height);
                } else {
                    self.screenShotImageViewRight.hidden = YES;
                    
                    self.screenShotImageViewLeft.frame = CGRectMake(self.view.width - ssWidth,
                                                                    screenMulti * 0,
                                                                    ssWidth,
                                                                    self.view.height);
                }
            }
        } else {
            self.screenShotImageViewRight.hidden = YES;
            
            self.screenShotImageViewLeft.frame = CGRectMake(self.visualEffectView.width - ssWidth,
                                                            screenMulti * 0,
                                                            ssWidth,
                                                            self.view.height);
        }
        
        self.visualEffectView.frame = CGRectMake(screenMulti * 0,
                                                 screenMulti * 0,
                                                 self.screenShotImageViewLeft.xMin,
                                                 self.view.height);
        self.separatorView.frame = CGRectMake(self.visualEffectView.xMax - separatorThickness,
                                              self.visualEffectView.yMin,
                                              separatorThickness,
                                              self.visualEffectView.height);
        self.iconImageView.frame = CGRectMake((self.visualEffectView.width - logoSize.width) / 2,
                                              screenMulti * 50,
                                              logoSize.width,
                                              logoSize.height);
        self.nameLabel.frame = CGRectMake(screenMulti * 0 + 5,
                                          self.iconImageView.yMax + screenMulti * 50,
                                          self.visualEffectView.width - (10 + separatorThickness),
                                          labelHeight);
        self.installButton.frame = CGRectMake(0,
                                              self.view.yMax - buttonHeight,
                                              self.view.width,
                                              buttonHeight);
    }
    
    if (self.ratingNrView) {
        CGFloat starWidth = self.starRatingView.configuration.starWidth;
        CGSize starRatingFrame = CGSizeMake(100, starWidth);
        CGFloat ratingNrViewHeight = starWidth * .75;
        
        self.starRatingView.frame = CGRectMake((self.nameLabel.xMax - starRatingFrame.width) / 2,
                                               self.nameLabel.yMax,
                                               starRatingFrame.width,
                                               starRatingFrame.height);
        
        self.ratingNrView.frame = CGRectMake(self.starRatingView.xMax,
                                             self.starRatingView.yMin + (self.starRatingView.height - ratingNrViewHeight) / 2,
                                             self.nameLabel.xMax - self.starRatingView.xMax,
                                             ratingNrViewHeight);
        self.ratingNrView.font = [UIFont systemFontOfSize:self.ratingNrView.height];
        
        [self centerRatingsView];
    } else {
        self.nameLabel.frame = CGRectMake(screenMulti * 0 + 5,
                                          self.iconImageView.yMax,
                                          self.visualEffectView.width - (10 + separatorThickness),
                                          self.installButton.yMin - self.iconImageView.yMax);
    }
    
    [self.visualEffectView bringSubviewToFront:self.separatorView];
    [self.visualEffectView bringSubviewToFront:self.iconImageView];
}

- (void)centerRatingsView {
    [self.ratingNrView sizeToFit];
    
    CGFloat totalWidth = self.starRatingView.width + self.ratingNrView.width;
    
    self.starRatingView.frame = CGRectMake((self.visualEffectView.width - totalWidth) / 2,
                                           self.starRatingView.yMin,
                                           self.starRatingView.width,
                                           self.starRatingView.height);
    
    self.ratingNrView.frame = CGRectMake(self.starRatingView.xMax,
                                         self.starRatingView.yMin + (self.starRatingView.height - self.ratingNrView.height) / 2,
                                         self.nameLabel.xMax - self.starRatingView.xMax,
                                         self.ratingNrView.height);
}

- (CGFloat)screenMulti {
    CGSize actualScreenSize = UIScreen.mainScreen.bounds.size;
    CGSize referenceScreenSize = CGSizeMake(736, 414);
    
    if (AIOUtils.isPortraitOrientation) {
        referenceScreenSize = CGSizeMake(414, 736);
    }
    
    return actualScreenSize.height / referenceScreenSize.height;
}

#pragma mark - Overrides

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
