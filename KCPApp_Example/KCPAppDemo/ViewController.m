//
//  ViewController.m
//  KCPAppDemo
//
//  Created by Kovács Kristóf on 10/12/2017.
//  Copyright © 2017 Kovács Kristóf. All rights reserved.
//

#import "ViewController.h"
#import <KCPApp/KCPManager.h>

static NSUInteger idGoPro = 561350520; // Dark
static NSUInteger idUnum = 1057252115; // Light
static NSUInteger idColorStory = 1015059175; // Colorful

static NSUInteger idFacebook = 284882215; // Many reviews
static NSUInteger idCymera = 553807264; // Some reviews
static NSUInteger idChangesForInstagram = 1130658280; // No reviews
static NSUInteger idVodafone = 468772675; // Shitty reviews

static NSUInteger idHomeBudget = 306257910; // Paid

static NSUInteger idFilmicPro = 436577167; // Landscape Screenshots

static NSUInteger idAffinityPhoto = 1117941080; // Ipad Exclusive

// Other Free
static NSUInteger idYoutube = 544007664;
static NSUInteger idSnapchat = 447188370;
static NSUInteger idMessenger = 454638411;
static NSUInteger idAmazon = 297606951;
static NSUInteger idGoogleMaps = 585027354;
static NSUInteger idFlipp = 725097967;
static NSUInteger idSpotify = 324684580;
static NSUInteger idGmail = 422689480;
static NSUInteger idPandora = 284035177;
static NSUInteger idPinterest = 306257910;
static NSUInteger idWhatsapp = 310633997;
static NSUInteger idSoundcloud = 336353151;
static NSUInteger idTwitter = 333903271;
static NSUInteger idGooglePhotos = 962194608;
static NSUInteger idUberEats = 1058959277;
static NSUInteger idWaze = 323229106;
static NSUInteger idGoogleChrome = 535886823;
static NSUInteger idFlipagram = 512727332;
static NSUInteger idHulu = 376510438;
static NSUInteger idLyft = 529379082;
static NSUInteger idMusically = 835599320;
static NSUInteger idEbay = 282614216;
static NSUInteger idVenmo = 351727428;

// Other Paid
static NSUInteger idVideoshop = 615563599;
static NSUInteger idGlitche = 634467171;
static NSUInteger idOlli = 1039012834;
static NSUInteger idHocus = 1030548464;
static NSUInteger idMonumentValley = 728293409;
static NSUInteger idAutoSleep = 1164801111;
static NSUInteger idMextures = 650415564;
static NSUInteger idInfltr = 935623257;

@interface ViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <NSString *> *selectorStrings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.selectorStrings = @[
                             @"cacheAds",
                             @"showAdDarkTheme",
                             @"showAdLightTheme",
                             @"showAdColorfulTheme",
                             @"showAdManyReviews",
                             @"showAdSomeReviews",
                             @"showAdNoReviews",
                             @"showAdShittyReviews",
                             @"showAdPaid",
                             @"showAdLandscapeScreenshots",
                             @"showAdIpadExclusive",
                             @"showAdRandom"
                             ];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Selectors

- (void)showAdDarkTheme {
    [self showAdVCWithId:idGoPro];
}

- (void)showAdLightTheme {
    [self showAdVCWithId:idUnum];
}

- (void)showAdColorfulTheme {
    [self showAdVCWithId:idColorStory];
}

- (void)showAdManyReviews {
    [self showAdVCWithId:idFacebook];
}

- (void)showAdSomeReviews {
    [self showAdVCWithId:idCymera];
}

- (void)showAdNoReviews {
    [self showAdVCWithId:idChangesForInstagram];
}

- (void)showAdShittyReviews {
    [self showAdVCWithId:idVodafone];
}

- (void)showAdPaid {
    [self showAdVCWithId:idHomeBudget];
}

- (void)showAdLandscapeScreenshots {
    [self showAdVCWithId:idFilmicPro];
}

- (void)showAdIpadExclusive {
    [self showAdVCWithId:idAffinityPhoto];
}

- (void)showAdRandom {
    NSArray *allAdIds = [self allAppIds];
    NSUInteger randomNum = arc4random()%allAdIds.count;
    [self showAdVCWithId:[allAdIds[randomNum] unsignedIntegerValue]];
}

- (void)cacheAds {
    NSArray *appIds = [self allAppIds];
    
    [KCPManager saveApps:appIds
              completion:^(BOOL success) {
                  NSString *text = @"Cached all app ads";
                  
                  if (!success) {
                      text = @"Couldn't cache apps | No internet connection";
                  }
                  
                  [self showToastWithText:text];
                }];
}



#pragma mark - UITableViewDataSource's methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectorStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kReuseIdentifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
    }
    
    cell.textLabel.text = [self sentenceFromCamelCase:self.selectorStrings[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate's methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = NSSelectorFromString(self.selectorStrings[indexPath.row]);
    [self performSelector:selector withObject:nil afterDelay:0];
}

#pragma mark - Helper methods

- (void)showAdVCWithId:(NSUInteger)id {
    KCPAdResult result = [KCPManager showAdOnVc:self
                                          appId:id];
    
    typedef NS_ENUM (NSUInteger, KCPAdResult) {
        KCPAdResultSuccess = 0,
        KCPAdResultAppNotCached,
        KCPAdResultFetchingFailed,
        KCPAdResultCurrentDeviceNotSupported,
        KCPAdResultNoInternetConnection
    };
    NSString *text;
    
    switch (result) {
        case KCPAdResultAppNotCached: {
            text = @"App not cached yet";
        }
            break;
        case KCPAdResultFetchingFailed: {
            text = @"Failed to fetch app";
        }
            break;
        case KCPAdResultCurrentDeviceNotSupported: {
            text = @"Current device not supported";
        }
            break;
        case KCPAdResultNoInternetConnection: {
            text = @"No internet connection";
        }
            break;
            default:
            break;
    }
    
    if (text) {
        [self showToastWithText:text];
    }
}

- (nonnull NSArray <NSNumber *> *)allAppIds {
    return @[
             @(idGoPro),
             @(idUnum),
             @(idColorStory),
             @(idFacebook),
             @(idCymera),
             @(idChangesForInstagram),
             @(idVodafone),
             @(idHomeBudget),
             @(idFilmicPro),
             @(idAffinityPhoto),
             
             @(idYoutube),
             @(idSnapchat),
             @(idAmazon),
             @(idGoogleMaps),
             @(idSpotify),
             @(idPandora),
             @(idPinterest),
             @(idWhatsapp),
             @(idSoundcloud),
             @(idTwitter),
             @(idGooglePhotos),
             @(idUberEats),
             @(idWaze),
             @(idGoogleChrome),
             @(idFlipagram),
             @(idHulu),
             @(idLyft),
             @(idMusically),
             @(idVenmo),
             
             @(idVideoshop),
             @(idGlitche),
             @(idHocus),
             @(idMonumentValley),
             @(idAutoSleep),
             @(idMextures),
             @(idInfltr)
             ];
}

- (nonnull NSString *)sentenceFromCamelCase:(nonnull NSString *)str {
    NSMutableString *str2 = [NSMutableString string];
    
    for (NSInteger i=0; i<str.length; i++) {
        NSString *ch = [str substringWithRange:NSMakeRange(i, 1)];
        
        if ([ch rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound) {
            [str2 appendString:@" "];
        }
        
        [str2 appendString:ch];
    }
    
    return [str2.capitalizedString copy];
}

- (void)showToastWithText:(nonnull NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = [UILabel new];
        label.text = text;
        label.font = [UIFont boldSystemFontOfSize:40];
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor darkGrayColor];
        label.textColor = [UIColor whiteColor];
        label.tintColor = [UIColor whiteColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
        
        [self.view addSubview:label];
        
        [UIView animateWithDuration:.3 animations:^{
            label.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:1.0 options:NO animations:^{
                label.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
            } completion:nil];
        }];
    });
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
