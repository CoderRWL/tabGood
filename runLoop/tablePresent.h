//
//  tablePresent.h
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol tablePrsentDelegate <NSObject>

@optional
-(void)loadTable;
-(void)loadCell:(NSIndexPath*)indexPath;


@end

@interface tablePresent : NSObject
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,weak)id<tablePrsentDelegate> delegate;
@property(nonatomic,copy)NSString *selectTitle;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)void(^dataBackArray)(NSArray *data ,NSIndexPath * indexpath);


-(void)loadData;

@end

NS_ASSUME_NONNULL_END
