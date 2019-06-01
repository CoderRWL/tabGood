//
//  tableDelegateAndDataSourse.h
//  runLoop
//
//  Created by  RWLi on 2019/6/1.
//  Copyright © 2019  RWLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "cellModel.h"
#import "tablePresent.h"

NS_ASSUME_NONNULL_BEGIN

@interface tableDelegateAndDataSourse : NSObject


@property(nonatomic,strong)tablePresent *present;
@property(nonatomic,strong)void (^scrollViewDidScrollBlock)(UIScrollView *sc);

-(instancetype)initWithReuseIdentifer:(NSString*)identifer  present:(tablePresent*)present  cellConfig:(void(^)(UITableViewCell *cell,NSIndexPath *indexPath,cellModel *model))cellConfig;



@end

@interface tableDelegateAndDataSourse() <UITableViewDelegate,UITableViewDataSource>
@end

NS_ASSUME_NONNULL_END
