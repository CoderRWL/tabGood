//
//  TaskManager.m
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import "TaskManager.h"

static CFRunLoopObserverRef runloopObserver;

@implementation TaskManager


-(instancetype)initWithMaxTasks:(int)maxCount{
  
    self = [super init];
    if (self) {
    
        [self addRunloopObserver];
        _maxTaskCountInQue= maxCount;
    
    }
    return self;
    
    
}


-(void)addRunloopObserver{
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    CFRunLoopObserverContext contex = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &contex);
    CFRunLoopAddObserver(runloopRef, runloopObserver, kCFRunLoopCommonModes);
    CFRelease(runloopObserver);
    
}

void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    TaskManager *vc = (__bridge TaskManager*)info;
    if (vc.tasks.count == 0) {
        return;
    }
    runLoopBlock block = vc.tasks.firstObject;
    block();
    [vc.tasks removeObjectAtIndex:0];
    
}


-(void)addTask:(runLoopBlock)task{
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }

    
    @synchronized (self) {
        
        if (_tasks.count > _maxTaskCountInQue) {
            [_tasks removeObjectAtIndex:0];
        }
        [_tasks addObject:task];
        
        
    }
}


-(void)removeRunLoopObserver{
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), runloopObserver, kCFRunLoopCommonModes);
}
-(void)dealloc{

}

@end
