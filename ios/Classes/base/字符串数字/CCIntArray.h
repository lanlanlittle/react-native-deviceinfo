//
//  CCIntArray.h
//  majiang
//
//  Created by zltianhen on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCIntArray : NSObject {
    NSMutableArray* intArray;
}


- (id)init;
- (void)add:(int)nNum;
- (int)objectAtIndex:(int)nIndex;
- (int)count;
- (void)clear;
@end
