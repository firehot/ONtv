
#import "ChannelCategory.h"

@implementation ChannelCategory

+ (NSString*)getChannelCatgegoryType:(NSString*)type 
{
    
    if ([type isEqualToString:@"documentary"]) {
        
        return @"DocumentryCategory";
        
    } else if ([type isEqualToString:@"entertainment"]) {
        
        return @"EntertainmentCategory";
        
    } else if ([type isEqualToString:@"kids"]) {
        
        return @"KidsCategory";
        
    } else if ([type isEqualToString:@"movie"]) {
        
        return @"MoviesCategory";
        
    } else if ([type isEqualToString:@"music"]) {
        
        return @"MusicCategory";
        
    } else if ([type isEqualToString:@"news"]) {
        
        return @"NewsCategory";
        
    } else if ([type isEqualToString:@"serie"]) {
        
        return @"TVSeriesCategory";    
        
    } else if ([type isEqualToString:@"show"]) { 
        
        //return @"ShowCategory";
        return @"DramaCategory";
        
    } else if ([type isEqualToString:@"sport"]) {    
        
        return @"SportCategory";
       
    } else if ([type isEqualToString:@"drama"]) {    
        
        return @"DramaCategory";
        
    } else if ([type isEqualToString:@"science"]) {    
        
        return @"ScienceCategory";
        
    }     
    
    return @"bigChannelLogo";

}

@end
