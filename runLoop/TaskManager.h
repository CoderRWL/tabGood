//
//  TaskManager.h
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^runLoopBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface TaskManager : NSObject

@property(nonatomic,strong)NSMutableArray *tasks;
@property(nonatomic,assign)int maxTaskCountInQue;



-(instancetype)initWithMaxTasks:(int)maxCount;
-(void)addTask:(runLoopBlock)task;//添加耗时事物
-(void)removeRunLoopTimer;//销毁前必须调用，否则会销毁不了


@end

NS_ASSUME_NONNULL_END
