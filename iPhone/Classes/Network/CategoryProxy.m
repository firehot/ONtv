

#import "CategoryProxy.h"
#import "CategoryDataModel.h"
#import "JSON.h"


@interface CategoryProxy ()

- (void)parseCategories:(NSString*)response;

@end

@implementation CategoryProxy 

@synthesize categoryProxyDelegate = _categoryProxyDelegate;



#pragma mark -
#pragma mark  server request for categories

- (void)getCategories {
    
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:@"/lists/categories"];
    
    DLog(@"new url : %@",url);
    
    [super setCache:YES];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetCategories" withRequestType:GET_REQUEST];
    
    
}


#pragma mark -
#pragma mark  server responce for categoires 


- (void)postFailed:(ASIHTTPRequest *)request 
{	
    
	DLog(@"Error : %@",[request error]);
	
    if (self.categoryProxyDelegate && [self.categoryProxyDelegate respondsToSelector:@selector(categoryRequestFailed:)]) {
        
        [self.categoryProxyDelegate categoryRequestFailed:nil];
    }
    
    
    if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
        
        [UIUtils alertView:[[request error] localizedDescription] withTitle:@"Programs"];
        
    } else {
        
        [UIUtils alertView:[request responseString] withTitle:@"Programs"];
        
    }
   
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}




- (void)postSuccess:(ASIHTTPRequest *)request 
{

   // DLog(@"request : %@",[request responseString]);

    NSDictionary *userInfo = [request userInfo];
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
	if ([reqName isEqualToString:@"GetCategories"]) {		
		
        [self parseCategories:[request responseString]];
        
    } 
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

#pragma mark -
#pragma mark parse categoires

- (void)parseCategories:(NSString*)response {
    
    SBJSON *sbjson = [[SBJSON alloc] init];
    id object = [sbjson objectWithString:response];
    
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *rootDic = (NSDictionary*)object;
    
        NSArray *categoryArray = [rootDic objectForKey:@"category"];
        
        NSMutableArray *categoryParsedArray = [[NSMutableArray alloc] init];
        
        for (int i =0; i < [categoryArray count]; i++) {
            
            NSDictionary *categoryDic = [categoryArray objectAtIndex:i];
            NSDictionary *categoryTypeDic = [categoryDic objectForKey:@"type"];
            
            CategoryDataModel *categoryObj = [[CategoryDataModel alloc]init];
            
            categoryObj.categoryType = [categoryTypeDic objectForKey:@"$"];
            
            NSMutableArray  *languageTitleArray = [categoryDic objectForKey:@"name"];
        
            NSString *systemLanguageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
            DLog (@"%@",systemLanguageCode);

            
            for (int i = 0; i < [languageTitleArray count]; i++) {
             
                NSDictionary *languageTitleDic = [languageTitleArray objectAtIndex:i];
                
                NSString *languageCode = [languageTitleDic objectForKey:@"@lang"];
                
                
                if ([languageCode isEqualToString:systemLanguageCode]) {
                 
                    categoryObj.categoryTitle = [languageTitleDic objectForKey:@"$"];
                    break;
                    
                } else {
                    
                    categoryObj.categoryTitle = [categoryTypeDic objectForKey:@"$"];
                }
    
            }
                
            
            
            [categoryParsedArray addObject:categoryObj];
            
        }    
        
        if ([categoryParsedArray count] > 0) {
        
            if (self.categoryProxyDelegate && [self.categoryProxyDelegate respondsToSelector:@selector(receivedCategory:)]) {
                    
                    [self.categoryProxyDelegate receivedCategory:categoryParsedArray];
                }
            
        } else {
            
            if (self.categoryProxyDelegate && [self.categoryProxyDelegate respondsToSelector:@selector(nocategoryRecordsFound)]) {
                
                [self.categoryProxyDelegate nocategoryRecordsFound];
            }
            
        }
    
    } else {
        
        
        if (self.categoryProxyDelegate && [self.categoryProxyDelegate respondsToSelector:@selector(categoryRequestFailed:)]) {
            
                [self.categoryProxyDelegate categoryRequestFailed:nil];
        }

    }
    
}

@end
