

#import "DeviceProxy.h"
#import "JSON.h"
#import "NSDictionary+NSNullHandler.h"
#import "NSString+utility.h"

@interface DeviceProxy()

- (void)parseDevices:(NSString*)response;

- (DeviceDataModel*)parseDeviceDetails:(NSDictionary*)dic;

- (id)proxyForDevice:(DeviceDataModel*)deviceObject;

@end


@implementation DeviceProxy

@synthesize deviceProxyDelegate = _deviceProxyDelegate;

#pragma mark -
#pragma mark Life Cycle Method


#pragma mark -
#pragma mark  server request for Devices

- (void)getDevices {
    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
	[url appendString:DEVICE_URL];
    
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    DLog(@"new url : %@",url);
    
    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"GetDevices" withRequestType:GET_REQUEST];
	
    
}



- (void)deleteDevice:(NSString*)devicesUDID {
    

    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
    
    [url appendString:DEVICE_URL];
    [url appendFormat:@"/%@",appDelegate.user.email];
    [url appendFormat:@"/%@",devicesUDID];
    
    DLog(@"new url : %@",url);
    
    
    [super setCache:NO];
    
    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:nil andRequestName:@"DeleteDevice" withRequestType:DELETE_REQUEST];
    
    
    
}

- (void)addDevice:(DeviceDataModel*)deviceObject {
    
    

    DLog(@"****************************addDevice***********************************");

    
    AppDelegate_iPhone * appDelegate = DELEGATE;
    
    NSMutableString *url = [[NSMutableString alloc] initWithString:BASEURL];
	
    [url appendString:DEVICE_URL];
    
    [url appendFormat:@"/%@",appDelegate.user.email];
    
    DLog(@"Device URL %@", url);
    
    NSDictionary *dict = [self proxyForDevice:deviceObject];
    
    DLog(@"**************DEVICE OBJECT %@ *********************",dict);

    
    NSData *data = [super dataFromDictionary:dict];
    

    
    [super setCache:NO];

    [super requestDataWithURL:url UsingToken:appDelegate.authenticationToken UsingData:data andRequestName:@"AddDevice" withRequestType:POST_REQUEST];
    

}



#pragma mark -
#pragma mark  Proxy Data for Add Devices Request


- (id)proxyForDevice:(DeviceDataModel*)deviceObject {
    
    
    NSDictionary *notificationTypeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     deviceObject.notificationType, @"$",nil];                                 
    
    NSDictionary *deviceTypeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     deviceObject.deviceType, @"$",nil];      
    
    NSDictionary *deviceNameDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   deviceObject.deviceName, @"$",nil];  
    
    NSDictionary *receiveNotificationDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   deviceObject.pushNotificationStatus, @"$",nil]; 
    
    NSDictionary *deviceUDIDDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            deviceObject.deviceUDID, @"$",nil];  
    
    NSDictionary *deviceTokenDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   deviceObject.deviceToken, @"$",nil]; 
    
    NSDictionary *appNameDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    deviceObject.appName, @"$",nil]; 
    
    NSDictionary *appVersionDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                deviceObject.appVersion, @"$",nil];  
    
    NSDictionary *systemVersionDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                deviceObject.systemVersion, @"$",nil]; 

                                            
    NSDictionary *deviceDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               notificationTypeDic, @"notification",
                               deviceTypeDic, @"type",
                               deviceNameDic, @"name",
                               receiveNotificationDic, @"receive",
                               deviceUDIDDic, @"id",
                               deviceTokenDic, @"token",
                               appNameDic, @"app_name",
                               appVersionDic, @"app_version",
                               systemVersionDic, @"system_version",
                               nil];
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:deviceDic,@"device",nil];
    
}



#pragma mark -
#pragma mark  server responce for Devices 


- (void)postFailed:(ASIHTTPRequest *)request 
{	
    
	DLog(@"Error : %@",[request error]);
    
    DLog(@"********DEVICE******postFailed*********************");

	//[UIUtils alertView:[[request error] localizedDescription] withTitle:@"Device"];
    
    
    if ([[request responseString] isKindOfClass:[NSNull class]] || [request responseString] == nil) {
        
        [UIUtils alertView:[[request error] localizedDescription] withTitle:@"Device"];
        
    } else {
        
        [UIUtils alertView:[request responseString] withTitle:@"Device"];
        
    }
    
	
    if (self.deviceProxyDelegate && [self.deviceProxyDelegate respondsToSelector:@selector(deviceRequestFailed:)]) {
        
        [self.deviceProxyDelegate deviceRequestFailed:nil];
    }
}



- (void)postSuccess:(ASIHTTPRequest *)request 
{
    
    DLog(@"Error : %@",[request responseString]);
    
    
    DLog(@"********DEVICE******postSUCCESS*********************");

    
    
    NSDictionary *userInfo = [request userInfo];
	NSString *reqName = [userInfo valueForKey:@"RequestName"];
	
    if ([reqName isEqualToString:@"GetDevices"]) {		
		
        [self parseDevices:[request responseString]];
        
    } else if ([reqName isEqualToString:@"DeleteDevice"]) {		
		
        if(self.deviceProxyDelegate && [self.deviceProxyDelegate respondsToSelector:@selector(deviceDeletedSuccesfully)]) {
            
            [self.deviceProxyDelegate deviceDeletedSuccesfully];
        }
        
    } else if ([reqName isEqualToString:@"AddDevice"]) {
        
        if(self.deviceProxyDelegate && [self.deviceProxyDelegate respondsToSelector:@selector(deviceAddedSuccesfully)]) {
            
            [self.deviceProxyDelegate deviceAddedSuccesfully];
        }
    }
    
}


- (void)parseDevices:(NSString*)response {
    
	NSDictionary *mainDict = [response JSONValue];
    
	id deviceROOTObj = [mainDict objectForKey:@"device"];
    
    
    
	NSMutableArray *deviceDetailsArray = [[NSMutableArray alloc] init];
    
	if([deviceROOTObj isKindOfClass:[NSMutableArray class]]) {
        
		if([deviceROOTObj count] != 0 && deviceROOTObj != nil) {										
			for(NSDictionary *dict in deviceROOTObj) {
                
                @autoreleasepool {
                
                DeviceDataModel *deviceDataObject = [self parseDeviceDetails:dict];
                [deviceDetailsArray addObject:deviceDataObject];
                
                }
                
			}						
		}
	}
    
    
    if ([deviceROOTObj isKindOfClass:[NSDictionary class]]) {
        
        @autoreleasepool {
        
            DeviceDataModel *deviceDataObject  = [self parseDeviceDetails:deviceROOTObj];
            [deviceDetailsArray addObject:deviceDataObject];
        
        }
        
    }
    
        
    if(self.deviceProxyDelegate && [self.deviceProxyDelegate respondsToSelector:@selector(receiveddevices:)]) {
            
        [self.deviceProxyDelegate receiveddevices:deviceDetailsArray];
    }
        

    
}


- (DeviceDataModel*)parseDeviceDetails:(NSDictionary*)dic {
    
    DeviceDataModel *deviceDataObject = [[DeviceDataModel alloc] init];
        
    
    NSDictionary *notificationTypeDic = [dic objectForKey:@"notification"];
    
    if([notificationTypeDic isDictionaryExist]) {
        
       deviceDataObject.notificationType = [notificationTypeDic objectForKey:@"$"];

    }
    
    
    NSDictionary *deviceTypeDic = [dic objectForKey:@"type"];
    
    if([deviceTypeDic isDictionaryExist]) {
        
       deviceDataObject.deviceType  = [deviceTypeDic objectForKey:@"$"];
        
        
    }
    
    NSDictionary *deviceNameDic = [dic objectForKey:@"name"];
    
    if([deviceNameDic isDictionaryExist]) {
        
        deviceDataObject.deviceName  = [deviceNameDic objectForKey:@"$"];
        
        
    }
    
    
    NSDictionary *receiveNotificationDic = [dic objectForKey:@"receive"];
    
    if([receiveNotificationDic isDictionaryExist]) {
        
        deviceDataObject.pushNotificationStatus  = [receiveNotificationDic objectForKey:@"$"];
        
        
    }
    
    
    NSDictionary *deviceUDIDDic = [dic objectForKey:@"id"];
    
    if([deviceUDIDDic isDictionaryExist]) {
        
        deviceDataObject.deviceUDID  = [deviceUDIDDic objectForKey:@"$"];
        
        
    }
    

    NSDictionary *deviceTokenDic = [dic objectForKey:@"token"];
    
    if([deviceTokenDic isDictionaryExist]) {
        
        deviceDataObject.deviceToken  = [deviceTokenDic objectForKey:@"$"];
        
    }
    
    
    NSDictionary *appNameDic = [dic objectForKey:@"app_name"];

    if([appNameDic isDictionaryExist]) {
        
        deviceDataObject.appName  = [appNameDic objectForKey:@"$"];
        
    }
    
    
    NSDictionary *appVersionDic = [dic objectForKey:@"app_version"];
    
    if([appVersionDic isDictionaryExist]) {
        
        deviceDataObject.appVersion  = [appVersionDic objectForKey:@"$"];
        
    }
    
    
    NSDictionary *systemVersionDic = [dic objectForKey:@"system_version"];
    
    if([systemVersionDic isDictionaryExist]) {
        
        deviceDataObject.systemVersion  = [systemVersionDic objectForKey:@"$"];
        
    }

    return deviceDataObject;
    
}

@end
