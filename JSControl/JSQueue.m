//
//  JSQueue.m
//  MultiDeviceAudioPlayer
//
//  Created by 陈玉亮 on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JSQueue.h"

@implementation JSQueue

@synthesize count;
@synthesize m_object;

- (id)init
{
	if( self=[super init] )
	{
		m_array = [[NSMutableArray alloc] init];
		count = 0;
	}
	return self;
}


- (void)enqueue:(id)anObject
{
	[m_array addObject:anObject];
	count = (int)m_array.count;
}
- (id)dequeue
{
	id obj = nil;
	if(m_array.count > 0)
	{
		obj = [m_array objectAtIndex:0];
		[m_array removeObjectAtIndex:0];
		count = (int)m_array.count;
	}
	return obj;
}

- (void)clear
{
	[m_array removeAllObjects];
	count = 0;
}

@end
