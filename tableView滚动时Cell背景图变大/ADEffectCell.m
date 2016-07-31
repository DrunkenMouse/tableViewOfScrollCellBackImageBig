//
//  ADEffectCell.m
//  tableView滚动时Cell背景图变大
//
//  Created by 王奥东 on 16/7/30.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADEffectCell.h"
#import "UIView+Frame.h"


#define W   [UIScreen mainScreen].bounds.size.width

#define ADCellHeight 150

#define ADLastCellHeight 230

static NSString * const CellId = @"Cell";

@interface ADEffectCell()
@property(nonatomic, strong)UIView *backGview;

@end

@implementation ADEffectCell

-(UIView *)backGview{
    
    if (!_backGview) {
        
        UIView *view = [UIView new];
        view.layer.masksToBounds = YES;
        [self.contentView addSubview:view];
        _backGview = view;
        
    }
    return _backGview;
}

-(UIImageView *)backGImage{
    
    if (!_backGImage) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.backGview addSubview:imageView];
        _backGImage = imageView;
        
    }
    return _backGImage;
}


+(instancetype)cellFromTableView:(UITableView *)tableView{
    
    ADEffectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[ADEffectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.clipsToBounds = NO;
        
        self.backGview.frame = CGRectMake(0, 0, W, ADCellHeight);
        self.backGImage.frame = CGRectMake(0, 0, W, ADLastCellHeight);
    }
    return self;
}




-(void)cellOfsetOnTableView:(UITableView *)tableView{
    
    CGFloat currentLocation = tableView.contentOffset.y + ADLastCellHeight;

    //下拉禁止第一个cell往下移动
//    if (currentLocation < ADCellHeight) {
//        return;
//    }
//
    
    
    //规定的位置为tableView左上角+ADLastCellHeight - ADCellHeight
  
    
//cell到达ADLastCellHeight - ADCellHeight范围内时即全部显示
//由于tableView上边距内偏移ADLastCellHeight - ADCellHeight,所以流畅的显示全部范围
//cell上显示图形的View往下滑动显示上半部分
    if (self.frame.origin.y < tableView.contentOffset.y + ADLastCellHeight - ADCellHeight) {
        self.backGview.height = ADLastCellHeight;
        self.backGview.y = -(ADLastCellHeight - ADCellHeight);
        
    }
    //cell开始进入tableView左上角加一个LastCellHeight高度范围内
    //且在显示范围内
    //开始滑动显示backGImage下半部分
    else if (self.frame.origin.y <= currentLocation && self.frame.origin.y >= tableView.contentOffset.y){
        //通过绝对值取出移动的Y值，为了防止移动过量做了一些处理
        CGFloat moveY = ABS(self.frame.origin.y - currentLocation) / ADCellHeight * (ADLastCellHeight - ADCellHeight);
        //每次进来把当前Cell提到图层显示最前面
        [self.superview bringSubviewToFront:self];
        //移动的值+cell固定高度
        self.backGview.height = ADCellHeight + moveY;
        //设置偏移量Y值
        self.backGview.y = -moveY;
    }
    //超出左上角加一个LastCellHeight高度(backGImage.height)
    // 让Cell显示图形的View不滑动,只显示上半部分
    else{
        
        self.backGview.height = ADCellHeight;
        self.backGview.y = 0;
    }
        
}



@end
