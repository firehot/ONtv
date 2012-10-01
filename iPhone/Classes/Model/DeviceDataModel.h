

#import <Foundation/Foundation.h>

@interface DeviceDataModel : NSObject

@property (nonatomic, copy) NSString *deviceUDID;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *pushNotificationStatus;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *notificationType;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *systemVersion;

@end
