//
//  TaskManager.m
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import "TaskManager.h"

static CFRunLoopTimerRef timeRef;

@implementation TaskManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addRunloopTimer];
    }
    return self;
}

-(instancetype)initWithMaxTasks:(int)maxCount{
  
    self = [super init];
    if (self) {
        [self addRunloopTimer];
        _maxTaskCountInQue= maxCount;
    }
    return self;
    
    
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


-(void)addRunloopTimer{
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    CFRunLoopTimerContext timeContex = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
     timeRef =  CFRunLoopTimerCreate(NULL, 0, 1/60.0, kCFRunLoopBeforeWaiting, 0, &TimerCallBack, &timeContex);
    CFRunLoopAddTimer(runloopRef, timeRef, kCFRunLoopCommonModes);
    CFRelease(timeRef);
    
    
        // CFRunLoopObserverContext contex = {
        //        0,
        //        (__bridge void *)self,
        //        &CFRetain,
        //        &CFRelease,
        //        NULL
        //    };
        //    static CFRunLoopObserverRef runloopObserver;
        //    runloopObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callBack, &contex);
        //    CFRunLoopAddObserver(runloopRef, runloopObserver, kCFRunLoopCommonModes);
        //    CFRelease(runloopObserver);
}



void TimerCallBack(CFRunLoopTimerRef timer, void *info){
    TaskManager *m = (__bridge TaskManager*)info;
    if (m.tasks.count== 0) {
        return;
    }
    runLoopBlock block = m.tasks.firstObject;
    block();
    [m.tasks removeObjectAtIndex:0];
    
    
}

-(void)removeRunLoopTimer{
    CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), timeRef, kCFRunLoopCommonModes);
}
-(void)dealloc{
    
    
}

@end
