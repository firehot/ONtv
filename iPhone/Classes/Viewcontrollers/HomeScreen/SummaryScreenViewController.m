

#import "SummaryScreenViewController.h"
#import "NSString+utility.h"
#import "Program.h"
#import "Image.h"
#import "WebViewController.h"
#import "AppDelegateSuperClass.h"
#import "PlanDetailViewController.h"
#import "AppDelegate_iPhone.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Twitter/Twitter.h>

@interface SummaryScreenViewController (){
    BOOL _shouldCreateUI;
}

- (void)createUI;

- (void)createMenuBar;

- (void)createTopScreen;

- (void)createBottomScreenAtYPosition:(float)yCoordinate;

- (CGSize)getSizeFor:(NSString*)textString withConstrained:(CGSize)maxSize;

- (void)fetchProgramDetails;

- (void)showPlanDetailView;

- (void)getRecommendationforProgram;

- (void)addRecommendationforProgram; 

- (void)deleteRecommendedProgram;

- (void)changeRecommendationStateTo:(BOOL)isrecommend;

- (void)loginButtonClicked;

- (void)createProgramProxy;

- (void)createRecommendationProxy;

- (void)imageViewBackGroundTapped:(UITapGestureRecognizer*)recognizer;

- (void)twitterButtonClicked;

@end

@implementation SummaryScreenViewController

@synthesize programId = _programId;
@synthesize program = _program;
@synthesize channel = _channel;
@synthesize fromSearch = _fromSearch;
@synthesize planView = _planView;
@synthesize recommendedBtn = _recommendedBtn;
@synthesize fromPush = _fromPush;
@synthesize programProxy = _programProxy;
@synthesize recommendProxy = _recommendProxy;
@synthesize postParams= _postParams;



#pragma mark - 
#pragma mark - View lifecycle

// create UI
// Register for Status Bar Height Change i.e when incomming call

- (void)loadView
{
    
    [super loadView];
    
    

        
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self createMenuBar];

    if (self.program && _shouldCreateUI) { 
    
        [self createUI];
        _shouldCreateUI = NO;
    } else {
        
        [self fetchProgramDetails];
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    _summaryScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _summaryScrollView.contentSize.height);

    CGRect scrollViewFrame = _summaryScrollView.frame;
    scrollViewFrame.size.width = self.view.bounds.size.width;
    scrollViewFrame.size.height = self.view.bounds.size.height - scrollViewFrame.origin.y;
    
    _summaryScrollView.frame = scrollViewFrame;
}



#pragma mark - 
#pragma mark - Internal Methods


- (void)createUI {
    

    @autoreleasepool {
    
        [self createTopScreen];
    
    }
}


// creats the top view of summary screen.
// It check which values are present for the selected program i.e title, channels logo, air time, episode. and accordingly creates the view size.
// it also check if the view show is due to push notification or users selections.

- (void)createTopScreen {

    
    UIView *topView  = [UIControls createUIViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 90) BackGroundColor:@"FFFFFF"];
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_title.png"]];
    [topImage setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    [topView addSubview:topImage];
    [self.view addSubview:topView];
    NSString *titleEpisodeString = nil;

    CGPoint currentPoint = CGPointMake(0,0);
    
    
    if ([self.program.episode isStringPresent] && [self.program.title isStringPresent]) {
     
        
       titleEpisodeString = [NSString stringWithFormat:@"%@ (%@)",self.program.title,self.program.episode];
        

    } else if ([self.program.title isStringPresent]) {
        
        titleEpisodeString = self.program.title;
    
    } else if ([self.program.episode isStringPresent]) {
        
        titleEpisodeString = self.program.episode;
    }
    
    UILabel *programTitle = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y, self.view.bounds.size.width - 20, 30) FondSize:16 FontName:SYSTEMBOLD FontHexColor:@"FFFFFF" LabelText:titleEpisodeString];
    
    programTitle.autoresizingMask=(UIViewAutoresizingFlexibleWidth);
    
    [topView addSubview:programTitle];
    
    
    currentPoint.y += 30;
    
    if ([self.program.teaser isStringPresent]) {
        
        
      CGSize currentSize = [self getSizeFor:self.program.teaser withConstrained:CGSizeMake(self.view.bounds.size.width - 20,40)];
        
        UILabel *teaserLabel = [UIControls createUILabelWithFrame:CGRectMake(10, 25, self.view.bounds.size.width - 20, currentSize.height) FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:self.program.teaser];
        
      teaserLabel.autoresizingMask=(UIViewAutoresizingFlexibleWidth);
    
      [topView addSubview: teaserLabel];
        
       int noOfLines = (int)ceilf(currentSize.height/20);
       [teaserLabel setNumberOfLines:noOfLines];
        
       currentPoint.y += currentSize.height; 
        
    } else {
        currentPoint.y +=15;
    }
        
    CGSize currentSize = CGSizeMake(0, 0);
    if ([self.program.start isStringPresent] && [self.program.end isStringPresent] ) {
        
        NSString *day = [UIUtils localDayStringForGMTDateString:self.program.start];
        NSString *startTime = [UIUtils localTimeStringForGMTDateString:self.program.start];
        NSString *endTime = [UIUtils localTimeStringForGMTDateString:self.program.end];
        
        NSString *time = [NSString stringWithFormat: @"%@ %@ - %@ ",day,startTime,endTime];
        //time = [time stringByAppendingString: NSLocalizedString(@"On", nil)];
        
        currentSize = [self getSizeFor:time withConstrained:CGSizeMake(250,30)];
        
        UILabel *ProgramTimeDetails = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y+10, 180, 25) FondSize:12 FontName:@"Helvetica-Bold" FontHexColor:@"000000" LabelText:time];
        //ProgramTimeDetails.autoresizingMask=(UIViewAutoresizingFlexibleWidth);
        [topView addSubview:ProgramTimeDetails];
        
        UIView *divider =[[UIView alloc] initWithFrame:CGRectMake(200, currentPoint.y+10, 1, 25)];
        [divider setBackgroundColor:[UIColor lightGrayColor]];
        [topView addSubview:divider];
        
    }
       
    if (self.fromPush) {
        
        AppDelegate_iPhone *appDelegate = DELEGATE;
        for (int i = 0; i < [appDelegate.favoriteChannelsViewController.allChannelsArray count]; i++) {
            
            Channel *channelObject = [appDelegate.favoriteChannelsViewController.allChannelsArray objectAtIndex:i];
            
            if (channelObject.id == self.program.channel) {
                
                self.channel = channelObject;
                
                break;
            }
        }
        
    }
    
    
    if([self.channel.imageObjectsArray count] !=0 || self.channel.imageObjectsArray != nil) {
        
        Image *imageObject  = nil;
        
        if (self.fromSearch) {
            
            imageObject = [self.channel.imageObjectsArray objectAtIndex:0];
            
        } else {
            
            imageObject = [self.channel.imageObjectsArray objectAtIndex:0];
        }
        
        
        if(imageObject.src != nil) {
            
            NSMutableString *urlString = [[NSMutableString alloc] initWithString:BASEURL];
            [urlString appendString:imageObject.src];
            
            DLog(@"channel server path string %@", imageObject.src);
            
            
            UIImageView *channelLogo = [[UIImageView alloc] initWithFrame:CGRectMake(210, currentPoint.y+10, 100, 25)];
            channelLogo.contentMode = UIViewContentModeScaleAspectFit;
            [channelLogo setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"bigChannelLogo"]];
            
            //channelLogo.autoresizingMask=(UIViewAutoresizingFlexibleWidth);
            
            [topView addSubview:channelLogo];
        }    
        
    }
    
    currentPoint.y += 45;
    
    [topView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, currentPoint.y)];
    topView.layer.shadowColor = [UIColor blackColor].CGColor;
    topView.layer.shadowOffset = CGSizeMake(1, 0);
    topView.layer.shadowOpacity = 0.8;
    topView.layer.shadowRadius = 1.3;
    topView.clipsToBounds = NO;
    
    
    [self createBottomScreenAtYPosition:currentPoint.y];
    
}


// it creates the botton view of the summary screen 
// create plan and recommendation button, and fires request for recommendation status.
// assign the value for genre , original title, summary actor and  start from and adjust the size.
// it also create face book share button.
// create imdb link if the selected program category is serie or movies.

- (void)createBottomScreenAtYPosition:(float)yCoordinate {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,yCoordinate,self.view.bounds.size.width,self.view.bounds.size.height - yCoordinate)];
    scrollView.backgroundColor=[UIUtils colorFromHexColor:@"e6e5e4"];
    _summaryScrollView = scrollView;
    
    [_summaryScrollView setUserInteractionEnabled:YES];
    
    _summaryScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_summaryScrollView];
    
    
    UIView *topSeperatorLine  = [UIControls createUIViewWithFrame:CGRectMake(0, 0, _summaryScrollView.bounds.size.width, 1) BackGroundColor:LIGHTGRAY];
    _summaryScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_summaryScrollView addSubview:topSeperatorLine];
    
    UIButton *planBtn = [UIControls createUIButtonWithFrame:CGRectZero];
    [planBtn addTarget:self action:@selector(planButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [planBtn setBackgroundImage:[[UIImage imageNamed:@"plan_btn"] stretchableImageWithLeftCapWidth:40 topCapHeight:10] forState:UIControlStateNormal];
    [planBtn setBackgroundImage:[[UIImage imageNamed:@"plan_btn_active"] stretchableImageWithLeftCapWidth:40 topCapHeight:10] forState:UIControlStateHighlighted];

    [planBtn setTitle:NSLocalizedString(@"Add notification",nil) forState:UIControlStateNormal];
    [planBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    planBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    planBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 10.0f);
    
    [planBtn sizeToFit];
    planBtn.frame = CGRectOffset(planBtn.frame, 10.0f, 10.0f);
    
    
    

    if (!appDelegate.isGuest) {
        
        [self getRecommendationforProgram];

    }
 
    self.recommendedBtn = [UIControls createUIButtonWithFrame:CGRectZero];
    [self.recommendedBtn addTarget:self action:@selector(recommendationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.recommendedBtn setBackgroundImage:[[UIImage imageNamed:@"recomd_btn"] stretchableImageWithLeftCapWidth:40 topCapHeight:10] forState:UIControlStateNormal];
    [self.recommendedBtn setTitle:NSLocalizedString(@"Recommend",nil) forState:UIControlStateNormal];
    [self.recommendedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.recommendedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
   
    self.recommendedBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 10.0f);
    self.recommendedBtn.frame = CGRectOffset(self.recommendedBtn.frame, CGRectGetMaxX(planBtn.frame) + 10.0f, CGRectGetMinY(planBtn.frame));
    [self.recommendedBtn sizeToFit];
    [_summaryScrollView addSubview:planBtn];
    [_summaryScrollView addSubview:self.recommendedBtn];
    
    
    UIView *middleLineSeperatorLine  = [UIControls createUIViewWithFrame:CGRectMake(0, 33+10+10, _summaryScrollView.bounds.size.width, 1) BackGroundColor:LIGHTGRAY];
    middleLineSeperatorLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_summaryScrollView addSubview:middleLineSeperatorLine];
    
    
    CGPoint currentPoint = CGPointMake(0,90);
    
    
    DLog(@"%@",self.program.imgSrc);
    
    
    if ([self.program.imgSrc isStringPresent]) {
        
        
        NSString *urlString =self.program.imgSrc;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 150 - 10, currentPoint.y+10, 150, 100)];
        programImage = imageView;
        programImage.contentMode = UIViewContentModeScaleAspectFit;
        [programImage setImageWithURL:[NSURL URLWithString:urlString]
                     placeholderImage:[UIImage imageNamed:@"bigChannelLogo.png"]
                              success:^(UIImage *image, BOOL cached) {
                                  NSLog(@"SUSCEESDSD!!!!!");
            
        }
                              failure:^(NSError *error) {
                                  NSLog(@"FAIL!!!");
                                  NSLog(@"%@",error.description);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewBackGroundTapped:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.numberOfTouchesRequired = 1;
        
        [programImage addGestureRecognizer:recognizer];
        recognizer = nil;
        programImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [_summaryScrollView addSubview:programImage];
       
        
    }  
    
    if ([self.program.genre isStringPresent]) {
        
        UILabel *label = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y, floorf(0.5f*_summaryScrollView.bounds.size.width-20), 30) FondSize:12 FontName:SYSTEMBOLD FontHexColor:BLACK LabelText:@"Genre"];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_summaryScrollView addSubview:label];
        
        currentPoint.y +=20; 
        
        label = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y, floorf(0.5f*_summaryScrollView.bounds.size.width-20), 30) FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:self.program.genre];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_summaryScrollView addSubview:label];
        
        currentPoint.y +=30;
    }

    if ([self.program.originalTitle isStringPresent]) {   
        
        UILabel *label = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y, floorf(0.5f*_summaryScrollView.bounds.size.width-40), 30) FondSize:12 FontName:SYSTEMBOLD FontHexColor:BLACK LabelText: NSLocalizedString(@"Original Title",nil)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_summaryScrollView addSubview: label];
        
         currentPoint.y +=30;
        
         int width = _summaryScrollView.bounds.size.width-20;
        
         if ([self.program.imgSrc isStringPresent]) {
              
             width = floorf(0.5f*_summaryScrollView.bounds.size.width-20);
         }  

         CGSize currentSize = [self getSizeFor:self.program.originalTitle withConstrained:CGSizeMake(width,60)];
         
         UILabel *originalTitle = [UIControls createUILabelWithFrame:CGRectMake(10,currentPoint.y,width, currentSize.height) FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:self.program.originalTitle];
        originalTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
         int noOfLines = (int)ceilf(currentSize.height/20);
         [originalTitle setNumberOfLines:noOfLines];
          
         currentPoint.y += currentSize.height+10;
         
        [_summaryScrollView addSubview:originalTitle];
        
        
    } 

    if (![self.program.originalTitle isStringPresent] && [self.program.imgSrc isStringPresent]) {
        
        currentPoint.y += 40;
        
    }
    
    if (![self.program.genre isStringPresent] && [self.program.imgSrc isStringPresent]) {

    
        currentPoint.y += 30;  
             
    }
    
    if (![self.program.genre isStringPresent] &&  ![self.program.originalTitle isStringPresent] && [self.program.imgSrc isStringPresent]) {
        
        programImage.frame = CGRectMake(floorf((self.view.bounds.size.width - 150) * .5f), 63, 150, 100);
        
        programImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        currentPoint.y += 45;
        
    }
    
    [programImage setUserInteractionEnabled:YES];
     programIVFrame = programImage.frame;
    
    
    if ([self.program.summary isStringPresent]) {
        
        UILabel *label = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y, _summaryScrollView.bounds.size.width-20, 30) FondSize:12 FontName:SYSTEMBOLD FontHexColor:BLACK LabelText: NSLocalizedString(@"Summary",nil)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_summaryScrollView addSubview:label];
        
        currentPoint.y += 30;
        
        CGSize currentSize = [self getSizeFor:self.program.summary withConstrained:CGSizeMake(300,400)];
        
        UILabel *summaryLabel = [UIControls createUILabelWithFrame:CGRectMake(10,currentPoint.y,_summaryScrollView.bounds.size.width-20, currentSize.height) FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:self.program.summary];
        summaryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        int noOfLines = (int)ceilf(currentSize.height/18);
        [summaryLabel setNumberOfLines:noOfLines+1];
        
        currentPoint.y += currentSize.height + 10;
        
        [_summaryScrollView addSubview:summaryLabel];
    }
    
    
    if ([self.program.cast isStringPresent]) {
        
        UILabel *label = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y, _summaryScrollView.bounds.size.width-20, 30) FondSize:12 FontName:SYSTEMBOLD FontHexColor:BLACK LabelText:@"Actors"];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_summaryScrollView addSubview: label];
        
        currentPoint.y += 30;
    
        CGSize currentSize = [self getSizeFor:self.program.cast withConstrained:CGSizeMake(300,400)];
        
        UILabel *actorLabel = [UIControls createUILabelWithFrame:CGRectMake(10,currentPoint.y,_summaryScrollView.bounds.size.width-20, currentSize.height) FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:self.program.cast];
        actorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        int noOfLines = (int)ceilf(currentSize.height/18);
        [actorLabel setNumberOfLines:noOfLines+1];
        
        currentPoint.y += currentSize.height + 10;
        
        [_summaryScrollView addSubview:actorLabel];
    }
    
    if ([self.program.year isStringPresent] || [self.program.country isStringPresent]) {
        
        
        NSString *newString = nil;
        
        if ([self.program.year isStringPresent] &&  [self.program.country isStringPresent] ) {
                        
            newString = [NSString stringWithFormat:@"%@ %@",self.program.year,self.program.country];
            
        } else if ([self.program.year isStringPresent]) { 
            
            newString = self.program.year;
            
        } else if ([self.program.country isStringPresent]) {
            
            newString = self.program.country;
        }
        
        
        UILabel *label = [UIControls createUILabelWithFrame:CGRectMake(10, currentPoint.y, _summaryScrollView.bounds.size.width-20, 30) FondSize:12 FontName:SYSTEMBOLD FontHexColor:BLACK LabelText: NSLocalizedString(@"From",nil)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_summaryScrollView addSubview:label];
        
        currentPoint.y += 20;
        
        
        UILabel *yearLabel = [UIControls createUILabelWithFrame:CGRectMake(10,currentPoint.y,_summaryScrollView.bounds.size.width-20,30) FondSize:12 FontName:HELVETICA FontHexColor:GRAY LabelText:newString];
        yearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
         currentPoint.y += 30;
        
        [_summaryScrollView addSubview:yearLabel];
    }
    
    if (currentPoint.y > 63) {
        
    
        UIView *bottomLineSeperatorLine  = [UIControls createUIViewWithFrame:CGRectMake(0, currentPoint.y+10, _summaryScrollView.bounds.size.width, 1) BackGroundColor:LIGHTGRAY];
        bottomLineSeperatorLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_summaryScrollView addSubview:bottomLineSeperatorLine];
        
        currentPoint.y += 10;
        
    }    
    
    if ([self.program.type isEqualToString:@"serie"] || [self.program.type isEqualToString:@"movie"]) {
        
 
            if ([self.program.link isStringPresent]) {
                
                UIButton *linkButton  = [UIControls  createUIButtonWithFrame:CGRectMake(39,currentPoint.y, _summaryScrollView.bounds.size.width, 50)];
                [linkButton addTarget:self action:@selector(linkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [linkButton setTitle: NSLocalizedString(@"Find on IMDB", nil) forState:UIControlStateNormal];
                linkButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [linkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [linkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
                [linkButton setTitleColor:[UIUtils colorFromHexColor:BLACK] forState:UIControlStateNormal];
                linkButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                
                [_summaryScrollView addSubview:linkButton];
                
                
                UIImageView  *accessoryView =[UIControls createUIImageViewWithFrame:CGRectMake(_summaryScrollView.bounds.size.width-17, currentPoint.y+20, 8, 11)];                    
                [accessoryView setImage:[UIImage imageNamed:@"ic_arrow_right"]];
                accessoryView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                [_summaryScrollView addSubview:accessoryView];
                
                UIImageView *searchImage =[UIControls createUIImageViewWithFrame:CGRectMake(10, currentPoint.y+15.5, 19, 19)];
                [searchImage setImage:[UIImage imageNamed:@"ic_search~ipad.png"]];
                searchImage.autoresizingMask =UIViewAutoresizingFlexibleRightMargin;
                [_summaryScrollView addSubview:searchImage];
                
                currentPoint.y += 50;
                
                UIView *bottomLineSeperatorLine2  = [UIControls createUIViewWithFrame:CGRectMake(0, currentPoint.y, _summaryScrollView.bounds.size.width, 1) BackGroundColor:LIGHTGRAY];
                bottomLineSeperatorLine2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                [_summaryScrollView addSubview:bottomLineSeperatorLine2];
                
                
            
            }
    
    }
    
    
    UIButton *faceBookButton  = [UIControls createUIButtonWithFrame:CGRectMake(10,currentPoint.y+15,145, 31)];
    
    [faceBookButton addTarget:self action:@selector(facebookButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [faceBookButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [faceBookButton setBackgroundImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    [faceBookButton setTitle: NSLocalizedString(@"Share on Facebook", nil) forState:UIControlStateNormal];
    [faceBookButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [faceBookButton setTitleShadowColor:[UIColor blackColor] forState: UIControlStateNormal];
    faceBookButton.titleLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    faceBookButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 25.0f, 0.0f, 0.0f);
     
    faceBookButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    UIButton *twitterButton=[UIControls createUIButtonWithFrame:CGRectMake(165, currentPoint.y+15, 146, 28)];
    [twitterButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [twitterButton addTarget:self action:@selector(twitterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
    [twitterButton setTitle: NSLocalizedString(@"Share on Twitter", nil) forState:UIControlStateNormal];
    twitterButton.titleLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    twitterButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 25.0f, 0.0f, 0.0f);
    twitterButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    currentPoint.y += 15+31+15;
    
    UIView *bottomLineSeperatorLine3  = [UIControls createUIViewWithFrame:CGRectMake(0, currentPoint.y, self.view.bounds.size.width, 1) BackGroundColor:LIGHTGRAY];
    [_summaryScrollView addSubview:bottomLineSeperatorLine3];
    
    [_summaryScrollView addSubview:faceBookButton];
    [_summaryScrollView addSubview:twitterButton];
    
    
    
    currentPoint.y += 70;
    
    [_summaryScrollView addSubview:programImage];
    
    NSLog(@"###### before %@", NSStringFromCGRect(_summaryScrollView.frame));
    
    [_summaryScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, currentPoint.y)];
    
    NSLog(@"###### after %@", NSStringFromCGRect(_summaryScrollView.frame));
    
    
    

    
}





#pragma mark - 
#pragma mark - Button Clicked Events 

// event get called when plan button is clicked 
// if the user is not logged in it show alert to login the user. else show the plan setting screen.


- (void)planButtonClicked {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    if (appDelegate.isGuest) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"You need to Login to use Plan functionality" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Login", nil];
        
        [alert show];
        
        
        
    } else  {

        [self showPlanDetailView];
    }
    
}


// event gets called when imdb link is selected.

- (void)linkButtonClicked {
    
    
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.urlString = self.program.title;    
    webViewController.linkType = @"IMDB";
    [self.navigationController pushViewController:webViewController animated:YES];

}

// events gets called when fa e book button is clicked.

    


#pragma mark -
#pragma mark  Get Size 

//  return the size required for the given string, here we also pass the constrained size to limit the generated size to the passed max size.
// we use this size for UILabel creation.

- (CGSize)getSizeFor:(NSString*)textString withConstrained:(CGSize)maxSize {
    
    
    CGSize suggestedSize = [textString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    
    DLog(@" width  == %f, height == %f", suggestedSize.width, suggestedSize.height);
    
    return suggestedSize;
}



#pragma mark -
#pragma mark - Server Communication Methods

//it is called to get selected program details

- (void)fetchProgramDetails {
    
    [self createProgramProxy];
        
    [self.programProxy getProgramDetails:self.programId forType:@"GetProgramDetails" forDate:nil];
    

}



#pragma mark -
#pragma mark - Program Proxy and Program Proxy Delegate Methods

// called if the request fails.

-(void)programDataFailed:(NSString *)error {
    
}

// called when the program get request is successfull.

- (void)receivedProgramsForChannel:(id)objects ForType:(NSString*)queryType {

    if (objects > 0) {
        
        self.program = [objects objectAtIndex:0];
        if ([self isViewLoaded]) {
            [self createUI];
            _shouldCreateUI = NO;
        } else {
            _shouldCreateUI = YES;
        }
    }

}


#pragma mark -
#pragma mark - Menu Bar Creation and Delegate Methods 

// create manubar and adds it on the top of the screen.

- (void)createMenuBar {
    
    MenuBar *menuBarObj = [[MenuBar alloc] initWithFrame:CGRectMake(0, 0, 197, 44)];
    
    menuBarObj.menuBarDelegate = self;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBarObj];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    
    
    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backbuttonClicked)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
    self.navigationItem.leftBarButtonItem = rightBarButton;
    

}

// gets called when user clicks on the menu bar button 

- (void)menubarButtonClicked:(MenuBarButton)buttonType {
    
    DLog(@"%d",buttonType);
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    appDelegate.selectedMenuItem  = buttonType;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [appDelegate.favoriteChannelsViewController  showSelectedMenu];
    
}



- (void)backbuttonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark Show Plan Detail Screen

// shows plans setting view.

- (void)showPlanDetailView {
    
    PlanDetailViewController *planDetailVC = [[PlanDetailViewController alloc] init];
    
    planDetailVC.program = self.program;
    
    planDetailVC.fromPlanEditScreen = NO;
    
    planDetailVC.planDetailDelegate = self.planView;

    [self.navigationController pushViewController:planDetailVC animated:YES];
    
}


#pragma mark -
#pragma mark EGO Image View Delegate 

// gets called when uses clicks on the image in the view.
// it toggles the image from zoom to normal.

- (void)imageViewBackGroundTapped:(UITapGestureRecognizer*)recognizer
{
    
     
    if (programImage.frame.size.width < 300) {
        
        [programImage setContentMode:UIViewContentModeScaleAspectFill];

        [programImage setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];

    
    } else {
        
        [programImage setContentMode:UIViewContentModeScaleAspectFit];
        [programImage setFrame:programIVFrame];
    }
    
}


#pragma mark -
#pragma mark - Recommendation Delegate  and Server communication method

// event get called when users clicks on recommendation button.
// if check if the current recommendation state of the program and then accorgingly adds or delete recommendation.

- (void)recommendationButtonClicked {
    
    AppDelegate_iPhone *appDelegate = DELEGATE;

    if (appDelegate.isGuest) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"You need to Login to use Recommend functionality" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Login", nil];
        
        [alert show];
        
        
    } else  {
        
        if ([self.recommendedBtn.currentTitle isEqualToString: NSLocalizedString(@"Recommend", nil)]) {
            
            
            [self addRecommendationforProgram];
            [self.recommendedBtn sizeToFit];
            
            [self.recommendedBtn setUserInteractionEnabled:NO];
            
        } else if ([self.recommendedBtn.currentTitle isEqualToString: NSLocalizedString(@"Don't recommend", nil)]) {
            
            [self deleteRecommendedProgram];
            [self.recommendedBtn sizeToFit];
            
            [self.recommendedBtn setUserInteractionEnabled:NO];
        }
        
    }
    
}

// It get the recommendation state for the program from server.

- (void)getRecommendationforProgram {
    
        
    [self createRecommendationProxy];
    
    [self.recommendProxy getRecommendationForProgram:self.program.programId];

}


// It add's the recommendation for the program to the server.

- (void)addRecommendationforProgram {
    
    [self createRecommendationProxy];

    [self.recommendProxy addRecommendationForProgram:self.program.programId];
}


// It delete's the recommendation for the program to the server.

- (void)deleteRecommendedProgram {
        
    [self createRecommendationProxy];
    
    [self.recommendProxy deleteRecommendationForProgram:self.program.programId];

}


// gets called when the recommendation state of the program is received from server.

- (void)receivedRecommendation:(BOOL)recommend {
   
    [self changeRecommendationStateTo:recommend];

    [self.recommendedBtn setUserInteractionEnabled:YES];    
}

// gets called when the recommendation state of the program is deleted to server.

- (void)recommendationDeletedSuccesfully {

    [self changeRecommendationStateTo:NO]; 

    [self.recommendedBtn setUserInteractionEnabled:YES];    
}

// gets called when the recommendation state of the program is added to server.


- (void)recommendationAddedSuccesfully {

    [self changeRecommendationStateTo:YES];
    
    [self.recommendedBtn setUserInteractionEnabled:YES];
}

// gets called when the recommendation request fails.

- (void)recommendRequestFailed:(NSString *)error {
    
    [self.recommendedBtn setUserInteractionEnabled:YES];

}


// After successfull server request form recommendation the state is changed locally.

- (void)changeRecommendationStateTo:(BOOL)isrecommend {
    
    if(isrecommend) {
        
        [self.recommendedBtn setBackgroundImage:[[UIImage imageNamed:@"recomd_btn_pressed"] stretchableImageWithLeftCapWidth:60 topCapHeight:10] forState:UIControlStateNormal];
        
        [self.recommendedBtn setTitle:NSLocalizedString(@"Don't recommend", nil) forState:UIControlStateNormal];
        [self.recommendedBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
        [self.recommendedBtn sizeToFit];
        
    } else {
        
        [self.recommendedBtn setBackgroundImage:[[UIImage imageNamed:@"recomd_btn"] stretchableImageWithLeftCapWidth:60 topCapHeight:10] forState:UIControlStateNormal];
        
        [self.recommendedBtn setTitle:NSLocalizedString(@"Recommend", nil) forState:UIControlStateNormal];
        [self.recommendedBtn sizeToFit];
    }

}


#pragma mark -
#pragma mark- Alert View Delegate.

// get called when users click on alert if the user is not logged in.

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    [self loginButtonClicked];
}



#pragma mark -
#pragma mark Button clicked Events 

// gets called to when users chooses the log in button on alert.

- (void)loginButtonClicked {

    AppDelegate_iPhone *appDelegate = DELEGATE;	
    
	[User deleteUser:appDelegate.user.name];
	
    appDelegate.user = nil;

    appDelegate.authenticationToken = nil;
    
    [appDelegate showLoginScreen];
    
}
- (void)facebookButtonClicked {
    AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *) [[UIApplication sharedApplication] delegate];
    if (FBSessionStateClosed) {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
            
    NSArray *localArray = [[[NSLocale currentLocale] localeIdentifier] componentsSeparatedByString:@"_"];
    NSString *currentRegion = [[localArray objectAtIndex:1] lowercaseString];
    if (![currentRegion isEqualToString:@"de"] && ![currentRegion isEqualToString:@"se"]) {
        currentRegion = @"dk";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://ontv.%@/info/%@/?utm_source=facebook&utm_medium=share_on_facebook&utm_campaign=facebook",currentRegion,self.program.programId];
    
    DLog(@"%@",urlString);
    
    NSMutableString *imageURL = [[NSMutableString alloc] initWithString:BASEURL];
    if ([self.program.imgSrc isStringPresent]) {
        [imageURL appendString:self.program.imgSrc];
    } else {
        imageURL=[NSMutableString stringWithString: @"https://dl.dropbox.com/u/7947878/Icon%402x.png"];
       
    }
    
   
        self.postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                           urlString, @"link",
                           imageURL, @"picture",
                           self.program.title, @"name",
                           self.program.summary, @"description",
                           nil];
   
#if NS_BLOCKS_AVAILABLE
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:_summaryScrollView];
	[_summaryScrollView addSubview:hud];
    [hud show:YES];
	
        [FBRequestConnection         startWithGraphPath:@"me/feed"
                                             parameters:self.postParams
                                             HTTPMethod:@"POST"
                                      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                          NSString *alertText;
                                          if (error) {
//                                              [self facebookButtonClicked];
                                          } else {
                                              alertText = NSLocalizedString(@"You post is now shared", nil);
                                          }
                                          [hud hide:YES];
                                          [[[UIAlertView alloc] initWithTitle:@"Result"
                                                                      message:alertText
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK!"
                                                            otherButtonTitles:nil]
                                           show];
                                      }];

#endif
    
   
    
}


- (void)twitterButtonClicked {
    if ([TWTweetComposeViewController canSendTweet])
    {
                
        NSArray *localArray = [[[NSLocale currentLocale] localeIdentifier] componentsSeparatedByString:@"_"];
        NSString *currentRegion = [[localArray objectAtIndex:1] lowercaseString];
        if (![currentRegion isEqualToString:@"de"] && ![currentRegion isEqualToString:@"se"]) {
            currentRegion = @"dk";
        }
        
        NSString *urlString = [NSString stringWithFormat:@"http://ontv.%@/info/%@/?utm_source=facebook&utm_medium=share_on_facebook&utm_campaign=facebook",currentRegion,self.program.programId];
        
        DLog(@"%@",urlString);
        
        NSString *imageURL = [[NSMutableString alloc] init];
        if ([self.program.imgSrc isStringPresent]) {
            imageURL = self.program.imgSrc;
        } else {
            imageURL= @"https://dl.dropbox.com/u/7947878/Icon%402x.png";
            
        }
                
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"I watch %@",self.program.title]];
        
        [tweetSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
        [tweetSheet addURL:[NSURL URLWithString:urlString]];
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have                                 at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
    


#pragma mark -
#pragma mark - Proxy Creation

// creates the proxy for Program requests and assigns delegates.



- (void)createProgramProxy {
    
    if (!self.programProxy) {
        
        ProgramProxy *tempprogramProxy = [[ProgramProxy alloc] init];
        self.programProxy = tempprogramProxy;
        
    }
    
    [self.programProxy setProgramProxyDelegate:self];
    
}

// creates the proxy for recommendation requests and assigns delegates. 


- (void)createRecommendationProxy {
    
    if (!self.recommendProxy) {
   
        RecommendProxy *tempRecommendProxy = [[RecommendProxy alloc] init];
        self.recommendProxy = tempRecommendProxy;
        
    }  
    
    [self.recommendProxy setRecommendProxyDelegate:self];
    
}

@end
