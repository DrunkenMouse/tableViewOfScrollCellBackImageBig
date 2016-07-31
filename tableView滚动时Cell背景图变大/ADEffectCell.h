//
//  ADEffectCell.h
//  tableView滚动时Cell背景图变大
//
//  Created by 王奥东 on 16/7/30.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADEffectCell : UITableViewCell

/**
 *  背景图
 */
@property(nonatomic,weak)UIImageView *backGImage;

/**
 *  cell偏移设置
 */
-(void)cellOfsetOnTableView:(UITableView *)tableView;

/**
 *  创建cell
 */
+(instancetype)cellFromTableView:(UITableView *)tableView;

@end
