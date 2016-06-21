//
//  GoodsCell.h
//  PurchuseCar_Demo_FMDB
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "GoodsModel.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height



@protocol GoodsCellDelegate <NSObject>
@optional;
-(void)GoodsCellDelegateWithIndexPath:(NSInteger)indexPathRow;

@end


static NSString *goodsCellStr = @"goodsCellStr";


@interface GoodsCell : UITableViewCell

@property(strong,nonatomic)CustomButton *selectedBtn; //选中
@property(weak,nonatomic)id<GoodsCellDelegate>delegate;

+(instancetype)initWithGoodsCellWithTableView:(UITableView *)tableView;
-(void)configWithModel:(GoodsModel *)model;




@end
