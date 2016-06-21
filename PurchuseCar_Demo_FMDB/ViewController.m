//
//  ViewController.m
//  PurchuseCar_Demo_FMDB
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import "DataManager.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,GoodsCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(strong,nonatomic)DataManager *dataManager;

//bottomView
@property(strong,nonatomic)UIView *bottomView;//
@property(strong,nonatomic)UIButton *toSelectCarBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.dataArr=[NSMutableArray array];
    self.dataManager = [DataManager sharedDataManager];
    [self.dataManager createGoodsTable];//创建表

    
    for (NSInteger i=0; i<20; i++) {
        NSString *ticket_no_str=[NSString stringWithFormat:@"20160621%ld",i];
        GoodsModel *goodsModel = [[GoodsModel alloc] init];
        goodsModel.Ticket_No = ticket_no_str;

        //专门加上的是否选中的状态
        goodsModel.btnIsSelected=NO;
        [self.dataArr addObject:goodsModel];
    }
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];

    
    
    //底部的
    self.bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    
    
    //去选车(3)
    self.toSelectCarBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.toSelectCarBtn.frame = CGRectMake(kScreenWidth-100, 0, 100, 49);
    [self.toSelectCarBtn setTitle:@"去发车" forState:UIControlStateNormal];
    [self.toSelectCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.toSelectCarBtn setBackgroundColor:[UIColor redColor]];
    self.toSelectCarBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.toSelectCarBtn addTarget:self action:@selector(toSelectCarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.toSelectCarBtn];

    
    
}
#pragma mark - 去选车
-(void)toSelectCarBtnAction
{
    if ([self.dataManager getAllGoodsArrCount]>0) {
        //do something
        [self showSingleAlertViewWith:self title:@"提示" message:@"do something"];
    }else{
    
        [self showSingleAlertViewWith:self title:@"提示" message:@"请选择物品"];
    }
}

-(void)showSingleAlertViewWith:(UIViewController *)viewController
                         title:(NSString *)title
                       message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *singleAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:singleAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 刷新底部的选车的数量   reloadBottonViewUI
-(void)reloadBottonViewUI
{
    if ([self.dataManager getAllGoodsArrCount]>0) {
        [self.toSelectCarBtn setTitle:[NSString stringWithFormat:@"去发车(%ld)",(long)[self.dataManager getAllGoodsArrCount]] forState:UIControlStateNormal];
    }else{
        [self.toSelectCarBtn setTitle:@"去发车" forState:UIControlStateNormal];
    }
    
}

#pragma mark - delegate
-(void)GoodsCellDelegateWithIndexPath:(NSInteger)indexPathRow
{

    GoodsModel *cacheModel = self.dataArr[indexPathRow];
    if (cacheModel.btnIsSelected) {
//        NSLog(@"YES==%@",cacheModel.Ticket_No);
        cacheModel.btnIsSelected = NO;
    } else {
//        NSLog(@"NO==%@",cacheModel.Ticket_No);
        cacheModel.btnIsSelected = YES;
    }
    //插入---删除   反复切换
    [self.dataManager insertDataFromModel:cacheModel Ticket_No:cacheModel.Ticket_No];
     //每次执行插入删除操作就会刷新底部的车辆的按钮
    [self reloadBottonViewUI];
   [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPathRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -tableView delegate&dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCell *cell  = [GoodsCell initWithGoodsCellWithTableView:tableView];
    [cell configWithModel:self.dataArr[indexPath.row]];
    cell.selectedBtn.indexPathRow = indexPath.row;
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
