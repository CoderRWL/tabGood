//
//  TaskManager.m
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import "TaskManager.h"


static NSTimeInterval _currentTime;

@interface TaskManager ()
@property(nonatomic,assign)BOOL isTimerWork;
@end


@implementation TaskManager
{
    NSTimer *_timer;
}

-(instancetype)initWithMaxTasks:(int)maxCount{
  
    self = [super init];
    if (self) {
        
        [self addRunloopTimer];
        _maxTaskCountInQue= maxCount;
        _isTimerWork = YES;
    
    }
    return self;
    
    
}

-(void)setIsTimerWork:(BOOL)isTimerWork{
    _isTimerWork = isTimerWork;
    
    if (_timer) {
        if (_isTimerWork) {
            _timer.fireDate = [NSDate distantPast];
        }else{
            _timer.fireDate = [NSDate distantFuture];
        }
    }
   
}

-(void)addRunloopTimer{
    _timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(task) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

-(void)addTask:(runLoopBlock)task{
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }
    if (_isTimerWork == NO ) {
        self.isTimerWork = YES;
    }
    
    @synchronized (self) {
        
        if (_tasks.count > _maxTaskCountInQue) {
            [_tasks removeObjectAtIndex:0];
        }
        [_tasks addObject:task];
        
        
    }
}


-(void)task{
    
        if (_tasks.count== 0) {
            if (_isTimerWork && isCompleteAllTask()) {
                self.isTimerWork = NO;
            }
            return;
        }
    
    [self excuceTaskWithIndex:0];
    [self excuceTaskWithIndex:_tasks.count-1];
    [self excuceTaskWithIndex:_tasks.count/2];
    
        
    
}

-(void)excuceTaskWithIndex:(NSInteger)index{
    if (index < _tasks.count) {
        runLoopBlock block = [_tasks objectAtIndex:index];
        [_tasks removeObjectAtIndex:index];
        block();
    }
    
    if (_tasks.count== 0) {
        _currentTime = [[NSDate date]timeIntervalSinceReferenceDate];
    }
}

bool isCompleteAllTask(){
    return ([[NSDate date]timeIntervalSinceReferenceDate] - _currentTime) > 10;
}



-(void)removeRunLoopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}
-(void)dealloc{

}

@end
