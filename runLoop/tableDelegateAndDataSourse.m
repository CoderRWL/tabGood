//
//  tableDelegateAndDataSourse.m
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import "tableDelegateAndDataSourse.h"
#import "TaskManager.h"


@interface tableDelegateAndDataSourse() <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)TaskManager *taskManager;


@property(nonatomic,copy)NSString *idelentifer;
@property(nonatomic,strong)void(^cellConfigBlock)(UITableViewCell *cell,NSIndexPath *indexPath,cellModel *model);
@end

@implementation tableDelegateAndDataSourse


-(instancetype)initWithReuseIdentifer:(NSString *)identifer present:(tablePresent*)present  cellConfig:(void (^)(UITableViewCell * _Nonnull, NSIndexPath * _Nonnull, cellModel * _Nonnull))cellConfig{
    if (self = [super init]) {
        _idelentifer = identifer;
        _cellConfigBlock = cellConfig;
        _present = present;

        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.present.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_idelentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_idelentifer];
        cellModel *model = [self.present.dataArray objectAtIndex:indexPath.row];
        if (self.cellConfigBlock) {
            self.cellConfigBlock(cell, indexPath, model);
        }
    }else{
        __weak typeof(self) weakself  =self;
        [self.taskManager addTask:^{
            cellModel *model = [weakself.present.dataArray objectAtIndex:indexPath.row];
            if (weakself.cellConfigBlock) {
                weakself.cellConfigBlock(cell, indexPath, model);
            }
        }];
        
       
    }
    
   
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.present.dataArray.count) {
        cellModel *model = [self.present.dataArray objectAtIndex:indexPath.row];
        model.title = [NSString stringWithFormat:@"%d",arc4random_uniform(100)] ;
        _present.indexPath = indexPath;
        _present.selectTitle = model.title;
        
    }
    
    //mvp
//    if (_present.delegate && [_present.delegate respondsToSelector:@selector(loadCell:)]) {
//        [_present.delegate loadCell:indexPath];
//    }
    
    
    
    
}

-(TaskManager *)taskManager{
    if (!_taskManager) {
        _taskManager = [[TaskManager alloc]initWithMaxTasks:54];
    }
    return _taskManager;
}

#pragma mark - scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollViewDidScrollBlock) {
        _scrollViewDidScrollBlock(scrollView);
    }

}





-(void)dealloc{
    if (_taskManager) {
        [_taskManager removeRunLoopTimer];
    }
   
}

@end
