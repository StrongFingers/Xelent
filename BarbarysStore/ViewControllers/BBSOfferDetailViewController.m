//
//  BBSOfferDetailViewController.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//
static NSString * const kClientId = @"50349261419-n45p3nli1mshq32oed8oo1tu0frlikfq.apps.googleusercontent.com";

#import "BBSOfferDetailViewController.h"
#import "BBSOfferDetailTopCell.h"
#import "BBSOfferDetailSizeColorCell.h"
#import "BBSOfferDetailAbsentSizeCell.h"
#import "BBSOfferDetailHeaderView.h"
#import "BBSPhotoPagingViewController.h"
#import "XLNCommonMethods.h"
#import "XLNDatabaseManager.h"
#import "BBSOfferManager.h"

#import "BBSAPIRequest.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>


#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <VKSdk.h>
#import <LVTwitterOAuthClient.h>
#import <Social/SLComposeServiceViewController.h>
#import <Social/SLComposeViewController.h>
#import <Social/SLRequest.h>
#import <GooglePlus.h>
#import <GPPSignInButton.h>
#import <GTLPlusConstants.h>


@interface BBSOfferDetailViewController () <UITableViewDataSource, UITableViewDelegate, offerDetailTopCellDelegate, BBSAPIRequestDelegate, VKSdkDelegate ,GPPSignInDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableDictionary *expandedInfo;
@property (nonatomic, strong) BBSOffer *offer;
@property (nonatomic, strong) BBSAPIRequest *offerRequest;
@property (nonatomic, strong) id shoppingCartNotification;
@property (nonatomic, strong) id updateSizeColorNotification;
@property (nonatomic, strong) NSString *selectedSize;
@property (nonatomic, strong) NSAttributedString *tmpAttributedStringDescription;
@property (nonatomic, strong) NSAttributedString *tmpAttributedStringBrandDescription;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) FBSDKLoginButton *loginButton;
@property (nonatomic, strong) NSArray *readPermissions;
@property (nonatomic, strong) NSArray *publishPermissions;

@end

@implementation BBSOfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [VKSdk initializeWithDelegate:self andAppId:@"5055669"];
    [VKSdk authorize:@[VK_PER_WALL,VK_PER_PHOTOS] revokeAccess:YES];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.useClientIDForURLScheme= YES;

    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,
                     nil];
    signIn.delegate = self;


   /* self.signIn = [GPPSignIn sharedInstance];
    self.signIn.clientID = kClientId;
    self.signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,nil];
    self.signIn.delegate = self;
    self.signIn trySilentAuthentication];*/
    
   /* signIn.shouldFetchGooglePlusUser =YES;
    signIn.useClientIDForURLScheme = YES;*/
    
    FBSDKLoginButton *loginebutton =[[FBSDKLoginButton alloc] init];
    loginebutton.center = self.view.center;
    loginebutton.userInteractionEnabled = YES;
    loginebutton.hidden = YES;
    self.readPermissions = loginebutton.readPermissions;
    self.publishPermissions = loginebutton.publishPermissions;
    //[self.view addSubview:loginebutton];
    
 
    // self.typeLabel.text = [typeText isEqualToString:LOC(@"offerDetail.sizeAbsent")] ? @"∞" : typeText;
       // if ([self.offer.sizesType objectForKey:LOC(@"offerDetail.sizeAbsent")]) {self.navigationItem.title = @"ABSENT";} else {self.navigationItem.title = @"!ABSENT";}; //detecting absent size in sizesType
    // Do any additional setup after loading the view.
    self.expandedInfo = [[NSMutableDictionary alloc] init];

    
    
    if (self.fromShoppingCart) {
        XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
        self.offer = [manager cartOfferById:self.offerId];
        self.selectedColor = self.offer.color;
    } else {
        self.offerRequest = [[BBSAPIRequest alloc] initWithDelegate:self];
        [self.offerRequest getOfferById:self.offerId];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    }
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(0, 0, 30, 30);
    [self.shareButton setImage:[UIImage imageNamed:@"sharingButtonNormal"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"sharingButtonSelected"] forState:UIControlStateHighlighted];
    UIBarButtonItem *shareRightItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    [self.shareButton addTarget:self action:@selector(sharingPressed:) forControlEvents:UIControlEventTouchUpInside && UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = shareRightItem;
    
}
- (void)viewWillAppear:(BOOL)animated {

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.14 green:0.37 blue:0.51 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.hidesBarsOnTap = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
    

    [super viewWillAppear:animated];

    if (!self.brandName)
            {
                    self.navigationItem.title = self.offer.brand;
            } else
                    {self.navigationItem.title = self.brandName;
            };
    
    self.shoppingCartNotification = [[NSNotificationCenter defaultCenter] addObserverForName:@"addToShoppingCart" object:nil queue:nil usingBlock:^(NSNotification *note) {
        XLNDatabaseManager *dbManager = [[XLNDatabaseManager alloc] init];
       
        BBSCartOffer *cartOffer = [[BBSCartOffer alloc] initWithOffer:self.offer];
        NSString *colorId = note.userInfo[@"color"];
        cartOffer.choosedColor = self.offer.colorsType[colorId][0][@"color_name"];
        cartOffer.size = note.userInfo[@"size"];
        cartOffer.quantity = @"1";
        [dbManager addToShoppingCart:cartOffer];
    }];
    
    self.updateSizeColorNotification = [[NSNotificationCenter defaultCenter] addObserverForName:@"updateSizeColorSection" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = note.userInfo;
        if (userInfo[@"selectedSize"]) {
            self.selectedSize = userInfo[@"selectedSize"];
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (userInfo[@"selectedColor"]) {
            self.selectedColor = userInfo[@"selectedColor"];
            self.offer.color = self.selectedColor;
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self.shoppingCartNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.updateSizeColorNotification];
    [super viewWillDisappear:animated];
}

#pragma mark - Methods

- (void)updateOffer:(BBSOffer *)offer {
    _offer = offer;
    self.selectedColor = offer.color;
}

-(void)sharingPressed:(UIButton *)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"SHARE" message:@"Choose your social" preferredStyle:UIAlertControllerStyleActionSheet];
    /////////////action buttons
    UIAlertAction *facebook = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        /*NSHTTPCookie *cookie =[[NSHTTPCookie alloc] init];
        NSHTTPCookieStorage *cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [cookiesStorage cookies]) {
            [cookiesStorage deleteCookie:cookie];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];*/
        
        /*NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://facebook.com/"]];
        for (NSHTTPCookie* cookie in facebookCookies) {
            [cookies deleteCookie:cookie];
        }
        */
        
        //FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
       // [loginManager logOut];
        //[FBSDKAccessToken setCurrentAccessToken:nil];
        //[FBSDKProfile setCurrentProfile:nil];
        
        FBSDKShareLinkContent *link = [[FBSDKShareLinkContent alloc] init];
        link.contentURL =[NSURL URLWithString:@"http://barbarys.com/"];
        link.contentTitle = [NSString stringWithFormat:@"%@, %@ грн",self.offer.model,self.offer.price];
        link.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.offer.thumbnailUrl]];
       
        [FBSDKShareDialog showFromViewController:self withContent:link delegate:nil];
    }];
    UIAlertAction *twitter = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            //making text of post
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@, %@ грн",self.offer.model,self.offer.price]];
            [tweetSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.offer.thumbnailUrl]]]]];
            [tweetSheet addURL:[NSURL URLWithString:@"http://barbarys.com/"]];
            [self presentViewController:tweetSheet animated:NO completion:nil];
    }];
    UIAlertAction *googlePlus = [UIAlertAction actionWithTitle:@"Google+" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
            [shareBuilder setURLToShare:[NSURL URLWithString:@"http://barbarys.com/"]];
            [shareBuilder setPrefillText:[NSString stringWithFormat:@"%@, %@ грн",self.offer.model,self.offer.price]];
           // [shareBuilder setTitle:@"Barbarys" description:@"ssdfffdf" thumbnailURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.offer.thumbnailUrl]]];
            [shareBuilder setContentDeepLinkID:[NSString stringWithFormat:@"%@", @"share"]];
            [shareBuilder open];


               //[[GPPSignIn sharedInstance] authenticate];
                /*id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
                [shareBuilder setURLToShare:[NSURL URLWithString:@"http://barbarys.com/"]];
                [shareBuilder setPrefillText:[NSString stringWithFormat:@"%@, %@ грн",self.offer.model,self.offer.price]];
                //[shareBuilder setContentDeepLinkID:kClientId];
                UIImage *postImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.offer.thumbnailUrl]]]];
                [shareBuilder attachImage:postImage];
                [shareBuilder open];*/
                

    }];
    UIAlertAction *vkontakte = [UIAlertAction actionWithTitle:@"Vkontakte" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        

        if ([VKSdk wakeUpSession])
        {
            VKShareDialogController *shareIt = [[VKShareDialogController alloc] init];
            shareIt.text = [NSString stringWithFormat:@"%@, %@ грн",self.offer.model,self.offer.price];
            shareIt.shareLink = [[VKShareLink alloc] initWithTitle:@"Barbarys" link:[NSURL URLWithString:@"http://barbarys.com/"]];
            
            UIImage *postImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.offer.thumbnailUrl]]]];
            shareIt.uploadImages = @[[VKUploadImage uploadImageWithImage:postImage andParams:[VKImageParameters jpegImageWithQuality:1.0]]];

            [shareIt setCompletionHandler:^(VKShareDialogControllerResult result) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [self presentViewController:shareIt animated:YES completion:nil];
        } else {
            VKShareDialogController *shareIt = [[VKShareDialogController alloc] init];
            shareIt.text = [NSString stringWithFormat:@"%@, %@ грн",self.offer.model,self.offer.price];
            shareIt.shareLink = [[VKShareLink alloc] initWithTitle:@"Barbarys" link:[NSURL URLWithString:@"http://barbarys.com/"]];
            VKUploadImage *imageToPost = [VKUploadImage uploadImageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.offer.thumbnailUrl]]] andParams:[VKImageParameters jpegImageWithQuality:0.9]];
            //shareIt.vkImages = @[@"224864056_336080820"];
            [shareIt setUploadImages:@[imageToPost]];
            [shareIt setCompletionHandler:^(VKShareDialogControllerResult result) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [self presentViewController:shareIt animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationItem setTitle:@""];
    }];
    /////////////

    [actionSheet addAction:facebook];
    [actionSheet addAction:twitter];
    [actionSheet addAction:googlePlus];
    [actionSheet addAction:vkontakte];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}
#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    if ([self.expandedInfo[@(section)] boolValue]) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:
            return 430;
            break;
        case 1:
            if (![self.offer.sizesType objectForKey:LOC(@"offerDetail.sizeAbsent")])
            {
                return 225;
            } else {return 133;}
            break;
        case 2:{
         //   self.tmpAttributedStringDescription = [XLNCommonMethods convertToBoldedString:self.offer.descriptionText fontSize:17.0];
            return ceilf([XLNCommonMethods findHeightForMutableAttributedText:self.tmpAttributedStringDescription havingWidth:self.view.frame.size.width].height);
        }
            break;
            
            
        case 3:{
        //    self.tmpAttributedStringBrandDescription = [XLNCommonMethods convertToBoldedString:self.offer.brandAboutDescription fontSize:15.0];
            return ceilf([XLNCommonMethods findHeightForMutableAttributedText:self.tmpAttributedStringBrandDescription havingWidth:self.view.frame.size.width].height);

        break;}
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BBSOfferDetailTopCell *cell = (BBSOfferDetailTopCell *)[tableView dequeueReusableCellWithIdentifier:@"offerDetailTopCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailTopCell" owner:self options:nil][0];
        }
        cell.offer = self.offer;
        [cell updateElements];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        // if ([self.offer.sizesType objectForKey:LOC(@"offerDetail.sizeAbsent")]) {self.navigationItem.title = @"ABSENT";} else {self.navigationItem.title = @"!ABSENT";}; //detecting absent size in sizesType
        if (![self.offer.sizesType objectForKey:LOC(@"offerDetail.sizeAbsent")])
        {
            BBSOfferDetailSizeColorCell *cell = (BBSOfferDetailSizeColorCell *)[tableView dequeueReusableCellWithIdentifier:@"offerDetailSizeColorCell"];
            
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailSizeColorCell" owner:self options:nil][0];
            }
            if (self.offer) {
                if (!self.selectedSize) {
                    self.selectedSize = self.offer.colorsType[self.selectedColor][0][@"size_name"];
                }
                NSMutableArray *sizes = [NSMutableArray array];
                for (NSDictionary *item in self.offer.colorsType[self.selectedColor]) {
                    [sizes addObject:item[@"size_name"]];
                }
                cell.defaultSizes = [self.offer.sizesType allKeys];
                [cell updateSizes:sizes selectedSize:self.selectedSize];
                NSMutableDictionary *colors = [NSMutableDictionary dictionary];
                for (NSDictionary *item in self.offer.sizesType[self.selectedSize]) {
                    [colors setObject:item[@"color_hex"] forKey:item[@"color_id"]];
                }
                [cell updateColors:colors selectedColor:self.selectedColor];
            }
            return cell;
        } else
        {
            BBSOfferDetailAbsentSizeCell *cell = (BBSOfferDetailAbsentSizeCell *)[tableView dequeueReusableCellWithIdentifier:@"offerDetailAbsentSizeCell"];
            
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailAbsentSizeCell" owner:self options:nil][0];
            }
            if (self.offer)
            {
                if (!self.selectedSize) {
                    self.selectedSize = LOC(@"offerDetail.sizeAbsent");
                }
                NSMutableDictionary *colors = [NSMutableDictionary dictionary];
                for (NSDictionary *item in self.offer.sizesType[self.selectedSize]) {
                    [colors setObject:item[@"color_hex"] forKey:item[@"color_id"]];
                }
                [cell updateColors:colors selectedColor:self.selectedColor];
            }
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCell"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont lightFont:15];
    //Next switch load an text to expanding cells of detail offer card

    switch (indexPath.section) {
        case 2:{
            
           // cell.textLabel.font = [UIFont lightFont:17];
            self.tmpAttributedStringDescription = [XLNCommonMethods convertToBoldedString:self.offer.descriptionText fontSize:15.0];
        
            
           /* self.tmpAttributedStringDescription = [[NSAttributedString alloc] initWithString:self.offer.descriptionText attributes:@{NSFontAttributeName:[UIFont boldLightFont:25.0]}];*/
            [cell.textLabel setAttributedText:self.tmpAttributedStringDescription];
            break;}
        case 3:{
            self.tmpAttributedStringBrandDescription = [XLNCommonMethods convertToBoldedString:self.offer.brandAboutDescription fontSize:15.0];
            //          self.tmpAttributedStringBrandDescription = [[NSAttributedString alloc] initWithString:self.offer.brandAboutDescription attributes:];
            [cell.textLabel setAttributedText:self.tmpAttributedStringBrandDescription];
            break;}
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor detailCellBackgroundColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return nil;
    }
    NSString *sectionTitle;
    if (section == 2) {
        sectionTitle = LOC(@"offerDetail.descriptionSection.headerTitle");
    } else if (section == 3) {
        sectionTitle = LOC(@"offerDetail.brandSection.headerTitle");
    }
    BBSOfferDetailHeaderView *header = [[BBSOfferDetailHeaderView alloc] headerWithTitle:sectionTitle index:section];
    [header setTouchUpTarget:self selector:@selector(headerTap:)];
    if (self.expandedInfo[@(section)]) {
        header.expanded = [self.expandedInfo[@(section)] boolValue];
    } else {
        header.expanded = NO;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    }
    return 40;
}

- (void)headerTap:(BBSOfferDetailHeaderView *)header {
    NSInteger section = header.index;
    header.expanded = !header.expanded;
    //[header setExpanded:!header.expanded];
    [self.expandedInfo setObject:@(header.expanded) forKey:@(section)];
    [self.mainTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (header.expanded) {
        [self.mainTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.mainTableView endUpdates];
    if (!header.expanded) {return;}
    else {
            UITableViewCell * firstRow = [self.mainTableView cellForRowAtIndexPath:indexPath];
            if ( [[self.mainTableView visibleCells] containsObject:firstRow]) {
                CGPoint expandedHeaderLeftTopPoint = [self.mainTableView contentOffset];
                CGRect screenRect = [[UIScreen mainScreen] bounds];
             
                expandedHeaderLeftTopPoint.y +=screenRect.size.height / 3;
                [self.mainTableView scrollsToTop];
                [self.mainTableView setContentOffset:expandedHeaderLeftTopPoint animated:YES];
                [self.mainTableView reloadData];
                //[self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    }
}

- (void)setBackBarButtonTitle:(NSString *)inputString {
    self.navigationItem.backBarButtonItem.title = inputString;
    [self.navigationItem setTitle:inputString];
}
#pragma mark - OfferDetailTopCellDelegate

- (void)imageTapped:(NSInteger)imageIndex {
    if ([self.offer.pictures count] > 0) {
        BBSPhotoPagingViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BBSPhotoPagingViewController"];
        ctrl.photos = self.offer.pictures[self.selectedColor];
        ctrl.currentIndex = imageIndex;    
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
}
#pragma mark - GPPSignIndelegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error{

    if (error) {
            DLog(@"Received error %@ and auth object %@",error, auth);
    } else {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setURLToShare:[NSURL URLWithString:@"http://barbarys.com/"]];
        [shareBuilder setPrefillText:[NSString stringWithFormat:@"%@, %@ грн",self.offer.model,self.offer.price]];
        //[shareBuilder setContentDeepLinkID:kClientId];
        UIImage *postImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.offer.thumbnailUrl]]]];
        [shareBuilder attachImage:postImage];
        [shareBuilder open];
    }
}

#pragma mark - VKSDKDelegate
-(void)vkSdkNeedCaptchaEnter:(VKError *)captchaError{}
-(void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{}
-(void)vkSdkUserDeniedAccess:(VKError *)authorizationError{}
-(void)vkSdkReceivedNewToken:(VKAccessToken *)newToken{}
-(void)vkSdkShouldPresentViewController:(UIViewController *)controller{
  //  [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - BBSAPIRequest deletage

- (void)requestFinished:(id)responseObject sender:(id)sender {
    DLog(@"\n%@", responseObject);
    if (!self.fromFavorites) {
        self.offer = nil;
        self.offer = [BBSOfferManager parseDetailOffer:responseObject[0]];
        self.offer.offerId = self.offerId;
        self.offer.color = self.selectedColor;
        self.offer.thumbnailUrl = self.offer.pictures[self.selectedColor][0];
        [self.mainTableView reloadData];
        BBSOfferManager *manager = [[BBSOfferManager alloc] init];
        if ([manager countOfRows:self.offer] > 0) {
            [manager updateOfferInFavorites:self.offer state:offerUpdate];
        }
    }
    

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)requestFinishedWithError:(NSError *)error {

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
