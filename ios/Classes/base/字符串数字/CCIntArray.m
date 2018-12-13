//
//  CCIntArray.m
//  majiang
//
//  Created by zltianhen on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CCIntArray.h"


@implementation CCIntArray

- (id)init
{
    if ((self=[super init]))
    {
        
    }

    return self;
}


- (void)add:(int)nNum
{
    if (!intArray)
    {
        intArray = [[NSMutableArray alloc]init];
    }
    NSNumber* num  = [[NSNumber alloc] initWithInt:nNum];
    [intArray addObject:num];
    [num release];

}

//这个的错误需要在外面判断
- (int)objectAtIndex:(int)nIndex
{
    NSNumber* num = [intArray objectAtIndex:nIndex];
    return [num intValue];
}



- (void)dealloc
{
    [intArray release];
    [super dealloc];
}

- (int)count
{
    return [intArray count];
}

- (void)clear
{
    [intArray removeAllObjects];
    [intArray release];
    intArray = nil;
}
@end
