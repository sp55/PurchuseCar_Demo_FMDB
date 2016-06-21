//
//  GoodsCell.m
//  PurchuseCar_Demo_FMDB
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "GoodsCell.h"

@interface GoodsCell()
@property(strong,nonatomic)UILabel *cardLabel;//运单号:123456789
@property(strong,nonatomic)GoodsModel *model;
@end

@implementation GoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)initWithGoodsCellWithTableView:(UITableView *)tableView{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellStr];
    if (!cell) {
        cell = [[GoodsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellStr];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        //选中
        self.selectedBtn =[CustomButton buttonWithType:UIButtonTypeCustom];
        self.selectedBtn.frame =CGRectMake(10, 10, 40, 40);
        [self.selectedBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //100
        //运单号:123456789
        self.cardLabel =[[UILabel alloc]initWithFrame:CGRectMake(60, 20, kScreenWidth-60, 20)];
        self.cardLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.cardLabel];
        [self.contentView addSubview:self.selectedBtn];
        
    }
    return self;
}

#pragma mark - selectedBtnAction
-(void)selectedBtnAction:(CustomButton *)btn
{
    btn.selected=!btn.selected;
    [self.delegate GoodsCellDelegateWithIndexPath:btn.indexPathRow];
}

-(void)configWithModel:(GoodsModel *)model{
    self.model = model;
    if (model.btnIsSelected==YES) {
        [self.selectedBtn setImage:[UIImage imageNamed:@"sendcar_selected"] forState:UIControlStateNormal];
    }else{
        [self.selectedBtn setImage:[UIImage imageNamed:@"sendcar_unselected"] forState:UIControlStateNormal];
    }
    //运单号
    self.cardLabel.text = [NSString stringWithFormat:@"运单号:%@",self.model.Ticket_No];
}

@end
