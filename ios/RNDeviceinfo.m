
#import "RNDeviceinfo.h"
#import "WapActionManager.h"
#import "gameinfo.h"

@implementation RNDeviceinfo

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

// 获取设备信息
RCT_REMAP_METHOD(getDeviceInfo,   resolver:(RCTPromiseResolveBlock)resolve  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSDictionary* dict = [[WapActionManager shareInstance] getIosDeviceInfo: NULL];
    resolve(dict);
}

@end

