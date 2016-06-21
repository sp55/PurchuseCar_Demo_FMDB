//
//  DataManager.m
//  PurchuseCar_Demo_FMDB
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager


//初始化
+(DataManager *)sharedDataManager;
{
    static dispatch_once_t onceToken;
    static DataManager *dataBase=nil;
    dispatch_once(&onceToken, ^{
        dataBase=[[DataManager alloc] init];
    });
    return dataBase;
}
- (instancetype)init
{
    if (self=[super init]) {
        
        //删除原来的数据库
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"goods.db"];
        BOOL bRet = [fileMgr fileExistsAtPath:dataPath];
        if (bRet) {
            NSError *error;
            [fileMgr removeItemAtPath:dataPath error:&error];
        }
        NSString *path = [self getFullDatabasePathFromFileName:@"goods.db"];
        _dataBase=[[FMDatabase alloc] initWithPath:path];
        
        
    }
    return self;
}
#pragma mark - 获取数据库文件的全路径
- (NSString *)getFullDatabasePathFromFileName:(NSString *)name{
    NSString *path = NSHomeDirectory();
    NSString *docPath = [path stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:docPath]) {
        return [docPath stringByAppendingFormat:@"/%@",name];
    }else{
        return nil;
    }
}

//创建发车表
-(void)createGoodsTable{
    if ([_dataBase open]) {
        NSString *tableSql = @"CREATE TABLE IF NOT EXISTS goodsCacheInfo (Ticket_No);";
        BOOL isSuccess = [_dataBase executeUpdate:tableSql];
        if (!isSuccess) {
            NSLog(@"create table failed:%@",[_dataBase lastErrorMessage]);
        }else{
            NSLog(@"表创建成功");
        }
    }else{
        NSLog(@"open database:%@",[_dataBase lastErrorMessage]);
    }

}
#pragma mark--根据Ticket_Key返回是否存在
- (BOOL)isExistDataFromTicket_No:(NSString *)Ticket_No{
    NSString *selectSql = @"select * from goodsCacheInfo where Ticket_No=?";
    FMResultSet *rs = [_dataBase executeQuery:selectSql,Ticket_No];
    if ([rs next]) {
        return YES;
    }else{
        return NO;
    }
}
//增加数据记录
- (void)insertDataFromModel:(id)model Ticket_No:(NSString *)Ticket_No{
     GoodsModel *cacheModel=(GoodsModel *)model;
    if ([self isExistDataFromTicket_No:cacheModel.Ticket_No]) {
        [self deleteDataFromModel:(id)model Ticket_No:(NSString *)Ticket_No];
    }else{//直接插入数据
        NSString *insertSql = @"insert into goodsCacheInfo (Ticket_No) values(?)";
        BOOL isSuccess = [_dataBase executeUpdate:insertSql,cacheModel.Ticket_No];
        if (!isSuccess) {
            NSLog(@"insert error:%@",[_dataBase lastErrorMessage]);
        }else {
            NSLog(@"插入数据success");
        }
    }
}
//删除数据记录
- (void)deleteDataFromModel:(id)model Ticket_No:(NSString *)Ticket_No{
    GoodsModel *cacheModel=(GoodsModel *)model;
    NSString *deleteSql = @"delete from goodsCacheInfo where Ticket_No=?";
    BOOL isSuccess = [_dataBase executeUpdate:deleteSql,cacheModel.Ticket_No];
    if (!isSuccess) {
        NSLog(@"delete Error:%@",[_dataBase lastErrorMessage]);
    }else  {
        NSLog(@"删除数据succcess");
    }

}
//获取这个表中的所有数组内容
-(NSArray *)getAllGoodsArr{
    NSString *getArrGoodssql = @"select * from goodsCacheInfo";
    FMResultSet *rs = [_dataBase executeQuery:getArrGoodssql];
    NSMutableArray *arr = [NSMutableArray array];
    while ([rs next]) {
        GoodsModel *cacheModel=[[GoodsModel alloc] init];
        [cacheModel setValuesForKeysWithDictionary:rs.resultDictionary];
        [arr addObject:cacheModel];
    }
    return arr;//返回找到的所有记录
}
//获取这张表的所有数组的个数
-(NSInteger)getAllGoodsArrCount{
    return [[self getAllGoodsArr] count];
}
//退出这个页面 删除发车这张表
-(void)deleteGoodsTable{
    NSString *deleteSql = @"delete from goodsCacheInfo";
    BOOL isSuccess = [_dataBase executeUpdate:deleteSql];
    if (!isSuccess) {
        NSLog(@"删除表delete Error:%@",[_dataBase lastErrorMessage]);
    }else  {
        NSLog(@"删除这张表succcess");
    }

}

@end
