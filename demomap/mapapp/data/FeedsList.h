//
//  FeedsList.h
//  mapapp
//
//  Created by Thomas Brian on 2019-10-28.
//  Copyright © 2019 Thomas Brian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedsList : NSObject

+ (id)sharedInstance;

@property (nonatomic) NSArray<MyAnnotation*> *annotations;

- (void)registerDownloadHooks;
- (void)downloadDataIfNeeded;

@end

NS_ASSUME_NONNULL_END
