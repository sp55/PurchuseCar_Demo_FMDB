//
//  DataManager.h
//  PurchuseCar_Demo_FMDB
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "GoodsModel.h"
@interface DataManager : NSObject


@property(strong,nonatomic)FMDatabase *dataBase;
//初始化
+(DataManager *)sharedDataManager;


//创建发车表
-(void)createGoodsTable;
//增加数据记录
- (void)insertDataFromModel:(id)model Ticket_No:(NSString *)Ticket_No;
//删除数据记录
- (void)deleteDataFromModel:(id)model Ticket_No:(NSString *)Ticket_No;
//获取这个表中的所有数组内容
-(NSArray *)getAllGoodsArr;
//获取这张表的所有数组的个数
-(NSInteger)getAllGoodsArrCount;
//退出这个页面 删除发车这张表
-(void)deleteGoodsTable;


@end
