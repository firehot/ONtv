
#import <Foundation/Foundation.h>
#import "Proxy.h"
#import "DeviceDataModel.h"

@protocol DeviceProxyDelegate;

@interface DeviceProxy : Proxy 

@property (nonatomic, weak) id<DeviceProxyDelegate> deviceProxyDelegate;

- (void)getDevices;

- (void)deleteDevice:(NSString*)devicesUDID;

- (void)addDevice:(DeviceDataModel*)deviceObject;

@end

@protocol DeviceProxyDelegate <NSObject>

- (void)deviceRequestFailed:(NSString *)error;


@optional

- (void)receiveddevices:(NSMutableArray*)array;

- (void)deviceDeletedSuccesfully;

- (void)deviceAddedSuccesfully;

@end