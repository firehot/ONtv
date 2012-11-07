
#import "ProUserRequiredScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "UIControls.h"

NSString *ONTVProOrONTVrequiredLabelStr;
NSString *youNeedONTVProLabelStr;
NSString *readMoreLabelStr;
NSString *OnTvFullAccesLabelStr;
NSString *noCommercialStr;



@interface ProUserRequiredScreen()

- (void)createUI;

- (void)createUpperProUserView;

- (void)createBottomProUserView;

- (void)setLocalizedValues;

- (void)createMenuBar;

- (void) createTableView;


@end

@implementation ProUserRequiredScreen

@synthesize scrollView = _scrollView;


#pragma mark -
#pragma mark LifeCycle Method 


- (void)loadView {
    
    [super loadView];
    
    [self createUI];
}
 

- (void)viewDidUnload
{
    [super viewDidUnload];

}


#pragma mark -
#pragma mark Create UI

- (void)setLocalizedValues {
    
    
    ONTVProOrONTVrequiredLabelStr = NSLocalizedString(@"ONTVProOrONTVrequired ",@"Pro User Required Screen, ONTV Pro Or ONTV required Label Text");
    
    youNeedONTVProLabelStr = NSLocalizedString(@"You Need ONTV Pro",@"Pro User Required Screen, you Need ONTV ProLabel Label Info");
    
    readMoreLabelStr = NSLocalizedString(@"Read More",@"Pro User Required Screen, read More Label Text");
    
    OnTvFullAccesLabelStr = NSLocalizedString(@"OnTv Full Access",@"Pro User Required Screen, OnTv Full Access Label Text");
    
    noCommercialStr = NSLocalizedString(@"No Commercial",@"Pro User Required Screen, No Commercial Label Text");
    
}

#pragma mark - 
#pragma mark Table Voew DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma Mark -
#pragma Create UI -

- (void)createUI {
    
    [self.view setBackgroundColor:[UIUtils colorFromHexColor:@"353535"]];
    
    [self setLocalizedValues];
    
    UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    self.scrollView = aScrollView;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 480);
    [self.scrollView setUserInteractionEnabled:YES];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];
    
    [self createUpperProUserView];
    
    [self createBottomProUserView];
    
    [self createMenuBar];
}

- (void) createTableView {

}


- (void)createUpperProUserView {
    
    UIView *upperView = [UIControls createUIViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80) BackGroundColor:@"b00a4f"];
    
    upperView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.scrollView addSubview:upperView];
     
    // create  Ontv Logo Image View
    UIImageView *ontvLogo = [UIControls createUIImageViewWithFrame:CGRectMake(32.5f, 11.5, 255, 57)];
    [ontvLogo setBackgroundColor:[UIUtils colorFromHexColor:@"b00a4f"]];
    UIImage *ontvLogoImage  = [UIImage imageNamed:@"img_logo"];
    [ontvLogo setImage:ontvLogoImage];
    
    ontvLogo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    [self.scrollView  addSubview:ontvLogo];

}

- (void)createBottomProUserView {
    
    UILabel *ONTVProOrONTVrequiredLabel =[UIControls createUILabelWithFrame:CGRectMake(0, 90, self.view.bounds.size.width, 30) FondSize:26 FontName:@"Helvetica Bold" FontHexColor:@"b00a4f" LabelText:ONTVProOrONTVrequiredLabelStr];
    [ONTVProOrONTVrequiredLabel setTextAlignment:UITextAlignmentCenter];
    ONTVProOrONTVrequiredLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView  addSubview:ONTVProOrONTVrequiredLabel];
    
    UILabel *youNeedONTVProLabel =[UIControls createUILabelWithFrame:CGRectMake(44, 90+20, self.scrollView.bounds.size.width - 90, 90) FondSize:12 FontName:@"Helvetica" FontHexColor:@"858585" LabelText:youNeedONTVProLabelStr];
    [youNeedONTVProLabel setNumberOfLines:4];
    [youNeedONTVProLabel setTextAlignment:UITextAlignmentCenter];
    youNeedONTVProLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView  addSubview:youNeedONTVProLabel];
    
    UIButton *proUserReadMoreButton = [UIControls createUIButtonWithFrame:CGRectMake((self.scrollView.bounds.size.width - 231) * .5f, 90+(4*30)-10, 231, 33)];
    [proUserReadMoreButton setBackgroundImage:[UIImage imageNamed:@"ProUserGreenButton"] forState:UIControlStateNormal];
    [proUserReadMoreButton setTitle:readMoreLabelStr forState:UIControlStateNormal];
    [proUserReadMoreButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [proUserReadMoreButton setTitleColor:[UIUtils colorFromHexColor:@"ffffff"] forState:UIControlStateNormal];
    [proUserReadMoreButton addTarget:self action:@selector(readMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];    
    proUserReadMoreButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.scrollView  addSubview:proUserReadMoreButton];

    UILabel *OnTvFullAccesLabel =[UIControls createUILabelWithFrame:CGRectMake(44, 90+3+(5*30)+5, self.scrollView.bounds.size.width - 90, 60) FondSize:8 FontName:@"Helvetica Bold" FontHexColor:@"858585" LabelText:OnTvFullAccesLabelStr];
    [OnTvFullAccesLabel setNumberOfLines:3];
    [OnTvFullAccesLabel setTextAlignment:UITextAlignmentCenter];
    OnTvFullAccesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView  addSubview:OnTvFullAccesLabel];
    
    NSArray *appTypesArray = [[NSArray alloc]initWithObjects:@"Windows",@"Android",@"Mac OS X",@"iGoogle",@"iPhone",@"Facebook",nil];
    
    int j = 0;
    
    int x=0;
    int y=0;
    UILabel *label;
    int xCenter = self.scrollView.bounds.size.width * .5f;
    for (int i = 0; i < 3; i++) 
    {
        x = xCenter - 100;
        y = 90+3+(7*30)+5+(i*20);
        
        UIImageView *ontvLogo = [UIControls createUIImageViewWithFrame:CGRectMake(x,y, 17, 14)];
        UIImage *ontvLogoImage  = [UIImage imageNamed:@"CheckMark"];
        [ontvLogo setImage:ontvLogoImage];
        ontvLogo.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.scrollView  addSubview:ontvLogo];
        label = [UIControls createUILabelWithFrame:CGRectMake(x+17+5,y-3, 70, 20) FondSize:12 FontName:@"Helvetica" FontHexColor:@"858585" LabelText:[appTypesArray objectAtIndex:j]];
        label.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
        [self.scrollView  addSubview:label];
        
        j +=1;
        
        x = xCenter + 10;
        
        UIImageView *ontvLogo1 = [UIControls createUIImageViewWithFrame:CGRectMake(x+17+5,y, 17, 14)];
        UIImage *ontvLogoImage1  = [UIImage imageNamed:@"CheckMark"];
        [ontvLogo1 setImage:ontvLogoImage1];
        ontvLogo1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.scrollView  addSubview:ontvLogo1];
        label = [UIControls createUILabelWithFrame:CGRectMake(x+17+5+20,y-3, 70, 20) FondSize:12 FontName:@"Helvetica" FontHexColor:@"858585" LabelText:[appTypesArray objectAtIndex:j]];
        label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.scrollView  addSubview:label];
        
        j +=1;
        
    }
    
    
    x = xCenter - 60;
    y = 90+3+(7*30)+(3*20)+10;
    
    UIView* wrap = [[UIView alloc]initWithFrame:CGRectMake(x, y, 120,30)];	
    
    UIImageView *ontvLogo6 = [UIControls createUIImageViewWithFrame:CGRectMake(0,0, 17, 14)];
    UIImage *ontvLogoImage6  = [UIImage imageNamed:@"CheckMark"];
    [ontvLogo6 setImage:ontvLogoImage6];
    [wrap addSubview:ontvLogo6];
    
    UILabel *noCommercialLabel = [UIControls createUILabelWithFrame:CGRectMake(17+5,-3, 100, 30) FondSize:12 FontName:@"Helvetica" FontHexColor:@"858585" LabelText:noCommercialStr];
    [wrap addSubview:noCommercialLabel];
    
    wrap.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    [self.scrollView  addSubview:wrap];    
}


#pragma mark -
#pragma mark - Menu Bar Creation and Delegate Methods 

- (void)createMenuBar {
    
    MenuBar *menuBarObj = [[MenuBar alloc] initWithFrame:CGRectMake(0, 0, 197, 44)];
    menuBarObj.menuBarDelegate = self;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBarObj];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backbuttonClicked)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	self.navigationItem.leftBarButtonItem = rightBarButton;
    
}

- (void)menubarButtonClicked:(MenuBarButton)buttonType {
    
    
    DLog(@"%d",buttonType);
    
    AppDelegate_iPhone *appDelegate = DELEGATE;
    
    appDelegate.selectedMenuItem  = buttonType;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [appDelegate.favoriteChannelsViewController  showSelectedMenu];
    
}


#pragma Mark - 
#pragma Mark Button Clicked Event for closeButton

- (void)backbuttonClicked {
        
    
    [self.navigationController popViewControllerAnimated:YES];

    //[appDelegate.rootNavController dismissModalViewControllerAnimated:YES];
    
    
}


- (void)readMoreButtonClicked {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://ontv.dk/subscriptions"]];
}


@end
