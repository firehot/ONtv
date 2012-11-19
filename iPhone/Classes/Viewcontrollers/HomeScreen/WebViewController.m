
#import "WebViewController.h"


@interface WebViewController ()

- (void)createUI;


@end

@implementation WebViewController

@synthesize urlString = _urlString;

@synthesize linkType = _linkType;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    [super loadView];
    [self createUI];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)backbuttonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)createUI {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backBtn = [UIUtils createBackButtonWithTarget:self action:@selector(backbuttonClicked)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
    self.navigationItem.leftBarButtonItem = rightBarButton;
    
    
    DLog (@"LINK TO BE SHARE ON FACE BOOK%@",self.urlString);
    
    NSString *title = [self.urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
              title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (__bridge CFStringRef)title,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8 );

    NSString *link = nil;
    
    if ([self.linkType isEqualToString:@"IMDB"]) {

        link = [NSString stringWithFormat:@"http://www.imdb.com/find?s=all&q=%@",encodedString];
        
         DLog (@" FACE BOOK%@",link);
        
        
    } else { // facebook
        
        link = [NSString stringWithFormat:@"https://www.facebook.com/sharer/sharer.php?u=%@",encodedString];
        
    }
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:link]];
        
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
  
    [webview loadRequest:request];
    
    [webview setScalesPageToFit:YES];
    
    [webview setDelegate:self];
    
    [self.view addSubview:webview];
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

#pragma mark -
#pragma mark - Web View Delegate Method


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    DLog(@"webViewDidStartLoad");

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    DLog(@"webViewDidFinishLoad");

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    DLog(@"didFailLoadWithError");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

@end
