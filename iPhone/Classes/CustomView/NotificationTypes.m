

#import "NotificationTypes.h"

@implementation NotificationTypes



+ (NSString*)getReminderType:(NSString*)type {
    
    
    if ([type isEqualToString:@"email"]) {
        
        return @"E-mail";
        
    } else if ([type isEqualToString:@"sms"]) {
        
        return @"SMS";
        
    } else if ([type isEqualToString:@"push"] || [type isEqualToString:@"ios"]) {
        
        return @"Apple Push Notifications";    
        
    } else if ([type isEqualToString:@"ical"]) {
        
        return @"ical";    
        
    } else if ([type isEqualToString:@"c2dm"]) {
        
        return @"c2dm";    
        
    } else {
        
        return type;
    }
    
    
}


+ (NSString*)getReminderTypeForServer:(NSString*)type {
    
    
    if ([type isEqualToString:@"E-mail"]) {
        
        return @"email";
        
    } else if ([type isEqualToString:@"SMS"]) {
        
        return @"sms";
        
    } else if ([type isEqualToString:@"Apple Push Notifications"]) {
        
        return @"push";    
        
    } else if ([type isEqualToString:@"ical"]) {
        
        return @"ical";    
        
    } else if ([type isEqualToString:@"c2dm"]) {
        
        return @"c2dm";    
        
    } else {
        
        return type;
    }
    
    
}




+ (NSString*)getAgentSearchTitleCriteriaType:(NSString*)type {
    
    
    if ([type isEqualToString:@"title"]) {
        
        return NSLocalizedString(@"Title",nil);
        
    } else if ([type isEqualToString:@"summary"]) {
        
        return NSLocalizedString(@"Summary",nil);
        
    } else if ([type isEqualToString:@"all"]) {
        
        return NSLocalizedString(@"Title or summary",nil);    
        
    } else {
        
        return type;
    }
    
    
}


+ (NSString*)getAgentSearchTitleCriteriaTypeForServer:(NSString*)type {
    
    
    
    if ([type isEqualToString:@"Title"]) {
        
        return @"title";
        
    } else if ([type isEqualToString:@"Summary"]) {
        
        return @"summary";
        
    } else if ([type isEqualToString:@"Title or summary"]) {
        
        return @"all";    
        
    } else {
        
        return type;
    }
    
    
}



+ (NSString*)getAgentSearchTypeCriteriaType:(NSString*)type {
    
    
    if ([type isEqualToString:@"exact"]) {
        
        return @"Is";
        
    } else if ([type isEqualToString:@"contains"]) {
        
        return @"Contains";
        
    } else if ([type isEqualToString:@"begins"]) {
        
        return @"Begins with";    
        
    } else if ([type isEqualToString:@"ends"]) {
        
        return @"Ends with";    
        
    } else {
        
        return type;
    }
    
    
}


+ (NSString*)getAgentSearchTypeCriteriaTypeForServer:(NSString*)type {
    
    
    if ([type isEqualToString:@"is"]) {
        
        return @"exact";
        
    } else if ([type isEqualToString:@"Contains"]) {
        
        return @"contains";
        
    } else if ([type isEqualToString:@"Begins with"]) {
        
        return @"begins";    
        
    } else if ([type isEqualToString:@"Ends with"]) {
        
        return @"ends";    
        
    } else {
        
        return type;
    }
    
    
}



+ (NSString*)getProUserAgentDayType:(NSString*)type {
    
    
    if ([type isEqualToString:@"0"]) {
        
        return NSLocalizedString(@"All",nil);
        
    } else if ([type isEqualToString:@"-1"]) {
        
        return NSLocalizedString(@"Weekdays(mon-fri)",nil);
        
    } else if ([type isEqualToString:@"-2"]) {
        
        return NSLocalizedString(@"Weekends(sat-sun)",nil);    
        
    } else if ([type isEqualToString:@"1"]) {
        
        return NSLocalizedString(@"Mondays",nil);    
        
    }else if ([type isEqualToString:@"2"]) {
        
        return NSLocalizedString(@"Tuesdays",nil);    
        
    }else if ([type isEqualToString:@"3"]) {
        
        return NSLocalizedString(@"Wednesdays",nil);    
        
    }else if ([type isEqualToString:@"4"]) {
        
        return NSLocalizedString(@"Thursdays",nil);    
        
    }else if ([type isEqualToString:@"5"]) {
        
        return NSLocalizedString(@"Fridays",nil);    
        
    }else if ([type isEqualToString:@"6"]) {
        
        return NSLocalizedString(@"Saturdays",nil);    
        
    }else if ([type isEqualToString:@"7"]) {
        
        return NSLocalizedString(@"Sundays",nil);    
        
    } else {
        
        return type;
    }
    
    
}


+ (NSString*)getProUserAgentDayTypeForServer:(NSString*)type {
    
    
    if ([type isEqualToString:@"All"]) {
        
        return @"0";
        
    } else if ([type isEqualToString:@"Weekdays(mon-fri)"]) {
        
        return @"-1";
        
    } else if ([type isEqualToString:@"Weekends(sat-sun)"]) {
        
        return @"-2";    
        
    } else if ([type isEqualToString:@"Mondays"]) {
        
        return @"1";    
        
    }else if ([type isEqualToString:@"Tuesdays"]) {
        
        return @"2";    
        
    }else if ([type isEqualToString:@"Wednesdays"]) {
        
        return @"3";    
        
    }else if ([type isEqualToString:@"Thursdays"]) {
        
        return @"4";    
        
    }else if ([type isEqualToString:@"Fridays"]) {
        
        return @"5";    
        
    }else if ([type isEqualToString:@"Saturdays"]) {
        
        return @"6";    
        
    }else if ([type isEqualToString:@"Sundays"]) {
        
        return @"7";    
        
    } else {
        
        return type;
    }
    
}


@end
