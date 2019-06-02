//
//  tablePresent.m
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import "tablePresent.h"
#import "cellModel.h"

@implementation tablePresent

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver];
    }
    return self;
}

-(void)addObserver{
    [self addObserver:self forKeyPath:@"selectTitle" options:NSKeyValueObservingOptionNew context:nil];
    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
    NSLog(@"---%@",title);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(loadTable)]) {
//        [self.delegate loadTable];
//    }
    
    if (self.dataBackArray) {
        self.dataBackArray(self.dataArray,self.indexPath);
    }
    
}

-(void)loadData{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
        
        for (int i =0; i<100; i++) {
            cellModel *model = [[cellModel alloc]init];
            model.title = [NSString stringWithFormat:@"%d",arc4random_uniform(10)];
            model.count = 100;
            [_dataArray addObject:model];
        }
        
        
    }
    
    [NSThread sleepForTimeInterval:1];
    if (_dataBackArray) {
        _dataBackArray(_dataArray,nil);
    }
    
}

-(void)dealloc{
    
    [self removeObserver:self forKeyPath:@"selectTitle"];

    
}
@end
