//
//  ViewController.m
//  tableView滚动时Cell背景图变大
//
//  Created by 王奥东 on 16/7/30.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "ADEffectCell.h"

/**
    cell的显示通过两个View显示，一个View(backGview)与cell同大小负责显示页面
    另一个View挂在此View上，负责装载图片的整体大小(backGImage)此值大于cell的大小
 
    创建tableView时让其内边距上方偏移backGImage - backGview
    下方偏移tableView.frame.size.height - ADLastCellHeight
    偏移上方是为了让上方第一个完整显示，下方偏移是为了上拉到最后tableView只显示一半
 
    滚动结束后判断backGview高度与Y值如何改变来显示backGImage上承载的图片内容
    改变高度是为了让图片完整显示，修改Y值是为了填补滚动时cell之间的空白差
    空白差造成的原因是tableView的上方内边距与滚动结束上方cell的backGview显示修改
    所以为了填补空白与突然变大的情况还需让当前Cell移动到最前页
 
    判断分为三种情况：以tableView左上角+backGImage高度为规定范围
    超出规定范围，即tableViwe下方的显示只显示backGImage上半部分内容
    达到规定范围，开始让backGview增加高度修改Y遮盖空白区域并显示内容
    当前cell小于tableView左上角+ADLastCellHeight - ADCellHeight范围
    即为tableView上方内边距偏移的位置，则让cell的backGImage完整显示
    
 
    在生成Cell的时候即调用一次滚动结束的方法，让其显示应该显示的内容
 
 */

#define ADCellHeight 150

#define ADLastCellHeight 230

#define ADGetImage(row) [UIImage imageNamed:[NSString stringWithFormat:@"%zd",row]]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}

//创建tableView
-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bak"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    tableView.backgroundView = imageView;
    
    tableView.contentInset = UIEdgeInsetsMake(ADLastCellHeight - ADCellHeight, 0, tableView.frame.size.height - ADLastCellHeight, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

#pragma mark -<UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ADEffectCell *effectCell = [ADEffectCell cellFromTableView:tableView];
    
    return effectCell;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ADEffectCell *effectCell = (ADEffectCell *)cell;
    
    effectCell.backGImage.image = ADGetImage(indexPath.row);
    
    //初始化调用第一次滚动
    [effectCell cellOfsetOnTableView:_tableView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ADCellHeight;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取tableView显示的所有cell并让其调用自定义滚动方法
    [[_tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof ADEffectCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       //cell偏移设置
        [obj cellOfsetOnTableView:_tableView];
    }];
    
}

@end
