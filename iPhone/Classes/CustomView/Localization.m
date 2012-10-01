


#import "Localization.h"

@implementation Localization

+ (NSString*)getCurrentLanguage {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"]; 
    NSString *currentLanguage = [languages objectAtIndex:0];

    return currentLanguage;
}

@end
