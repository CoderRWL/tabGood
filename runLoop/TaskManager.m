//
//  TaskManager.m
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import "TaskManager.h"

static CFRunLoopTimerRef timeRef;
static CFRunLoopTimerRef timeRef1;
static NSTimeInterval _currentTime;

@implementation TaskManager


-(instancetype)initWithMaxTasks:(int)maxCount{
  
    self = [super init];
    if (self) {
        
        [self addRunloopTimer];
        _maxTaskCountInQue= maxCount;
        
        if (_maxTaskCountInQue > 30) {
            //任务太多，再开一条循环
            [self addRunloopTimer1];
        }
        _isTimerWork = YES;
        [self addObserver:self forKeyPath:@"isTimerWork" options:NSKeyValueObservingOptionNew context:nil];
    
    }
    return self;
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    BOOL flag = [change[NSKeyValueChangeNewKey]boolValue];
    if (flag) {
        [self continueTimer];
    }else{
        [self stopTimer];
    }
}

-(void)addTask:(runLoopBlock)task{
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }
    if (_isTimerWork == NO) {
        self.isTimerWork = YES;
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
    

     timeRef =  CFRunLoopTimerCreate(NULL,0 , 1/60.0, kCFRunLoopBeforeWaiting, 0, &TimerCallBack, &timeContex);
    CFRunLoopAddTimer(runloopRef, timeRef, kCFRunLoopCommonModes);
    CFRelease(timeRef);
    
    _isTimerWork = YES;

}

-(void)addRunloopTimer1{
    CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
    CFRunLoopTimerContext timeContex = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
   
    timeRef1 =  CFRunLoopTimerCreate(NULL, 0, 1/60.0, kCFRunLoopBeforeWaiting, 0, &TimerCallBack1, &timeContex);
    CFRunLoopAddTimer(runloopRef, timeRef1, kCFRunLoopCommonModes);
    CFRelease(timeRef1);
    
}


void TimerCallBack(CFRunLoopTimerRef timer, void *info){
    TaskManager *m = (__bridge TaskManager*)info;
    
    @synchronized (m) {
        
        if (m.tasks.count== 0) {
            if (m.isTimerWork && isCompleteAllTask()) {
                m.isTimerWork = NO;
            }
            return;
        }
        
        runLoopBlock block = m.tasks.firstObject;
        block();
        [m.tasks removeObjectAtIndex:0];
        if (m.tasks.count== 0) {
            _currentTime = [[NSDate date]timeIntervalSinceReferenceDate];
        }
        
    }
    
    
    
}


void TimerCallBack1(CFRunLoopTimerRef timer, void *info){
    TaskManager *m = (__bridge TaskManager*)info;
    
    @synchronized (m) {
        if (m.tasks.count== 0) {
            if (m.isTimerWork && isCompleteAllTask()) {
                m.isTimerWork = NO;
            }
            return;
        }
        
        runLoopBlock block = m.tasks.lastObject;
        block();
        [m.tasks removeLastObject];
        if (m.tasks.count== 0) {
            _currentTime = [[NSDate date]timeIntervalSinceReferenceDate];
        }
        
    }
    
    
    
}



//5s
bool isCompleteAllTask(){
    return ([[NSDate date]timeIntervalSinceReferenceDate] - _currentTime) > 10;
}


-(void)stopTimer{
    
    CFAbsoluteTime fireDate = [[NSDate distantFuture]timeIntervalSinceReferenceDate];
    
    if (timeRef) {
        CFRunLoopTimerSetNextFireDate(timeRef, fireDate);
    }
    if (timeRef1) {
        CFRunLoopTimerSetNextFireDate(timeRef1, fireDate);
    }
    
}
-(void)continueTimer{
    
    if (timeRef) {
        CFRunLoopTimerSetNextFireDate(timeRef, 0);
    }
    if (timeRef1) {
        CFRunLoopTimerSetNextFireDate(timeRef1, 0);
    }
}

-(void)removeRunLoopTimer{
    if (timeRef) {
        CFRunLoopTimerInvalidate(timeRef);
    }
    if (timeRef1) {
        CFRunLoopTimerInvalidate(timeRef1);
    }

    
}
-(void)dealloc{

    [self removeObserver:self  forKeyPath:@"isTimerWork"];
}

@end
