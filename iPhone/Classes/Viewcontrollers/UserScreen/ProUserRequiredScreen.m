
#import "ProUserRequiredScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "UIControls.h"
#import "CellHeader.h"
#import "CellProScreen.h"


@interface ProUserRequiredScreen()

- (void)createUI;

- (void)createUpperProUserView;

- (void)createBottomProUserView;

- (void)setLocalizedValues;

- (void)createMenuBar;

- (void) createTableView;

- (void)openLink;

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
    headerLine = NSLocalizedString(@"Demands a TimeFor.TV Pro or TimeFor.TV+ subscription beginning at only EUR 5 an year",nil);
    functionLine = NSLocalizedString(@"Functions",nil);
    firstLine = NSLocalizedString(@"Disable commercials on TimeFor.TV (apps)",nil);
    secondLine = NSLocalizedString(@"Show short summary in listings",nil);
    thirdLine = NSLocalizedString(@"Full version of TimeFor.TV for iPhone and iPad",nil);
    fourthLine=NSLocalizedString(@"Full version of TimeFor.TV for Android", nil);
    fifthLine = NSLocalizedString(@"Full version of TimeFor.TV for Windows", nil);
    sixLine = NSLocalizedString(@"Full version of TimeFor.TV for Facebook", nil);
    sevenLine = NSLocalizedString(@"Full version of TimeFor.TV for Mac", nil);
    eightLine = NSLocalizedString(@"Download EPG data as XMLTV for your media center", nil);
    
    
    tableStrings=[[NSArray alloc] initWithObjects:firstLine,secondLine,thirdLine,fourthLine,fifthLine,sixLine,sevenLine,eightLine, nil];
        
}

- (void)openLink {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://timefor.tv/products/subscriptions"]];
}

#pragma mark - 
#pragma mark Table Voew DataSource
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *wrap=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    [wrap setBackgroundColor: [UIColor clearColor]];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(floorf(0.5f*(wrap.bounds.size.width - 300)), 20, 300, 39)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_red_big"] forState:UIControlStateNormal];
    [btn setTitle:@"Buy Pro or + subscription" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openLink) forControlEvents:UIControlEventTouchUpInside];
    [wrap addSubview:btn];
    return wrap;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 120;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row==0) {
        CellHeader *cell = (CellHeader *) [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CellHeader" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            
        }
        cell.functions.text=functionLine;
        cell.plusMoney.text=NSLocalizedString(@"EUR 5/year", nil);
        cell.proMoney.text=NSLocalizedString(@"EUR 15/year", nil);
               
        return cell;
    } else {
        CellProScreen *cell = (CellProScreen *) [tableView dequeueReusableCellWithIdentifier:@"CellProScreen"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CellProScreen" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
                   }
        
            cell.functionLabel.text=[tableStrings objectAtIndex:indexPath.row-1];
            [cell.functionLabel adjustsFontSizeToFitWidth];
        if (indexPath.row == 2 || indexPath.row==8 || indexPath.row==1) {
            [cell.plusImage setHidden:YES];
        }

        return cell;
    }
    return cell;
}


#pragma Mark -
#pragma Create UI -

- (void)createUI {
    
    [self.view setBackgroundColor:[UIUtils colorFromHexColor:@"353535"]];
    [self setLocalizedValues];
    [self createUpperProUserView];
    [self createTableView];
   // [self createBottomProUserView];
    [self createMenuBar];
}

- (void) createTableView {
    UITableView *table=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView=table;
    [self.tableView setScrollEnabled:YES];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
    
}


- (void)createUpperProUserView {
    
    UILabel *headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 40)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setText:headerLine];
    [headerLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [headerLabel setNumberOfLines:2];
     
    [self.view  addSubview:headerLabel];

}

- (void)createBottomProUserView {
    
    UILabel *ONTVProOrONTVrequiredLabel =[UIControls createUILabelWithFrame:CGRectMake(0, 90, self.view.bounds.size.width, 30) FondSize:26 FontName:@"Helvetica Bold" FontHexColor:@"b00a4f" LabelText:headerLine];
    [ONTVProOrONTVrequiredLabel setTextAlignment:UITextAlignmentCenter];
    ONTVProOrONTVrequiredLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.scrollView  addSubview:ONTVProOrONTVrequiredLabel];

    
    UIButton *proUserReadMoreButton = [UIControls createUIButtonWithFrame:CGRectMake((self.scrollView.bounds.size.width - 231) * .5f, 90+(4*30)-10, 231, 33)];
    [proUserReadMoreButton setBackgroundImage:[UIImage imageNamed:@"ProUserGreenButton"] forState:UIControlStateNormal];
    [proUserReadMoreButton setTitle:firstLine forState:UIControlStateNormal];
    [proUserReadMoreButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [proUserReadMoreButton setTitleColor:[UIUtils colorFromHexColor:@"ffffff"] forState:UIControlStateNormal];
    [proUserReadMoreButton addTarget:self action:@selector(readMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];    
    proUserReadMoreButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.scrollView  addSubview:proUserReadMoreButton];

    UILabel *OnTvFullAccesLabel =[UIControls createUILabelWithFrame:CGRectMake(44, 90+3+(5*30)+5, self.scrollView.bounds.size.width - 90, 60) FondSize:8 FontName:@"Helvetica Bold" FontHexColor:@"858585" LabelText:secondLine];
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
    
    UILabel *noCommercialLabel = [UIControls createUILabelWithFrame:CGRectMake(17+5,-3, 100, 30) FondSize:12 FontName:@"Helvetica" FontHexColor:@"858585" LabelText:thirdLine];
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
