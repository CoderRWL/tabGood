//
//  ViewController.m
//  runLoop
//
//  Created by  RWLi on 2017/9/19.
//  Copyright © 2017年  RWLi. All rights reserved.
//

#import "ViewController.h"
#import "tableDelegateAndDataSourse.h"
#import "tablePresent.h"



@interface ViewController ()<tablePrsentDelegate>

@property(nonatomic,strong)UITableView *tab;
@property(nonatomic,strong)UITableView *tab1;
@property(nonatomic,strong)UITableView *tab2;
@property(nonatomic,strong)tableDelegateAndDataSourse *tableDelegateAndDataSourse;



@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakself = self;
    
    tablePresent *p = [[tablePresent alloc]init];
    p.delegate = self;
    [p setDataBackArray:^(NSArray * _Nonnull data,NSIndexPath*indexP) {
        //数据回来
        if (indexP) {
            [weakself loadCell:indexP];
        }else{
          [weakself loadTable];
        }
        
    }];
    
    
    _tableDelegateAndDataSourse = [[tableDelegateAndDataSourse alloc]initWithReuseIdentifer:@"cellID" present:p cellConfig:^(UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, cellModel * _Nonnull model) {
        [weakself setCell:cell model:model];
    }];
    
    
    
    [_tableDelegateAndDataSourse setScrollViewDidScrollBlock:^(UIScrollView * _Nonnull sc) {
        CGPoint offset =   sc.contentOffset;
        [weakself.tab setContentOffset:offset];
        [weakself.tab1 setContentOffset:offset];
        [weakself.tab2 setContentOffset:offset];
    }];
    
    
    
    [self.view addSubview:self.tab];
    [self.view addSubview:self.tab1];
    [self.view addSubview:self.tab2];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setCell:(UITableViewCell*)cell model:(cellModel*)model{
    if (cell.contentView.subviews.count) {
        
        for (int i =1; i<50; i++) {
            UILabel *lab = [cell.contentView viewWithTag:i];
            lab.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.5 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
            
            lab.text = [NSString stringWithFormat:@"%@",model.title];
        }
    }else{
        
        for (int i =1; i<50; i++) {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(i*10, 0, 10, 40)];
            lab.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.5 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
            
            lab.text = [NSString stringWithFormat:@"%@",model.title];
            lab.tag = i;
            [cell.contentView addSubview:lab];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_tableDelegateAndDataSourse.present loadData];
    
}

#pragma mark - tablePrsentDelegate

-(void)loadTable{
    
    [_tab reloadData];
    [_tab1 reloadData];
    [_tab2 reloadData];
}
-(void)loadCell:(NSIndexPath *)indexPath{
    [_tab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
     [_tab1 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
     [_tab2 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - lay
-(UITableView *)tab{
    if (!_tab) {
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, 150, 700) style:UITableViewStylePlain];
        _tab.delegate = _tableDelegateAndDataSourse;
        _tab.dataSource = _tableDelegateAndDataSourse;
        
    }
    return _tab;
}
-(UITableView *)tab1{
    if (!_tab1) {
        _tab1 = [[UITableView alloc]initWithFrame:CGRectMake(160, 100,100 , 700) style:UITableViewStylePlain];
        _tab1.delegate = _tableDelegateAndDataSourse;
        _tab1.dataSource = _tableDelegateAndDataSourse;
        
    }
    return _tab1;
}
-(UITableView *)tab2{
    if (!_tab2) {
        _tab2 = [[UITableView alloc]initWithFrame:CGRectMake(270, 100, 414-270, 700) style:UITableViewStylePlain];
        _tab2.delegate = _tableDelegateAndDataSourse;
       _tab2.dataSource = _tableDelegateAndDataSourse;
        
    }
    return _tab2;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
