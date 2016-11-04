//
//  JSQueue.h
//  MultiDeviceAudioPlayer
//
//  Created by 陈玉亮 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSQueue : NSObject
{
	NSMutableArray* m_array;
    id      m_object;
}

- (void)enqueue:(id)anObject;
- (id)dequeue;
- (void)clear;

@property (nonatomic, readonly) int count;
@property (nonatomic, copy)   id  m_object;
@end
