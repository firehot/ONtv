//
//  NSDateFormatter+RFC_1123.m
//  OnTV
//
//  Created by Hellier on 30.10.12.
//
//

#import "NSDateFormatter+RFC_1123.h"

@implementation NSDateFormatter (RFC_1123)
+(NSDateFormatter*)rfc1123Formatter
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
    return df;
}
@end
