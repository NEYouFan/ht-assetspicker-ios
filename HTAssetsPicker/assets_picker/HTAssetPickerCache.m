//
//  HTAssetPickerCache.m
//  Pods
//
//  Created by hj on 16/7/18.
//
//

#import "HTAssetPickerCache.h"

static NSUInteger kAssetPickerCacheDefaultCountLimit = 100;

@implementation HTAssetPickerCache

#pragma mark - class Method

+ (HTAssetPickerCache *)shareAssetPickerCache {
    static dispatch_once_t once;
    static HTAssetPickerCache *instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.countLimit = kAssetPickerCacheDefaultCountLimit;
    });
    return instance;
}


#pragma mark - life Cycle

- (id)init {
    
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
}

@end
