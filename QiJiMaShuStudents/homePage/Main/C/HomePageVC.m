//
//  HomePageVC.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/8/8.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "HomePageVC.h"
#import "GoodsDetailsVC.h"
#import "CLCycleView.h"
#import "LearnCarShowTVCell.h"
@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource,CLCycleViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic ,strong) CLCycleView *cycleView;
/**
 存储商品的数组
 */
@property (nonatomic, strong)NSMutableArray *goodsListArray;

@end

@implementation HomePageVC

- (NSMutableArray *)goodsListArray {
    if (!_goodsListArray) {
        _goodsListArray = [NSMutableArray array];
    }
    return _goodsListArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, kScreen_heigth-80-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"LearnCarShowTVCell" bundle:nil] forCellReuseIdentifier:@"LearnCarShowTVCell"];
        NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 12; i ++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]];
            [arrayM addObject:image];
        }
        MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self RequestInterface];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        // 设置普通状态下的动画图片  -->  静止的一张图片
        NSArray * normalImagesArray = @[[UIImage imageNamed:@"1"]];
        [header setImages:normalImagesArray forState:MJRefreshStatePulling];
        // 设置即将刷新状态的动画图片
        [header setImages:arrayM forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:arrayM forState:MJRefreshStateRefreshing];
        // 设置header
        self.tableView.mj_header = header;
    }
    return _tableView;
}
/**
 *请求数据
 */
- (void)RequestInterface {
    [_tableView.mj_header endRefreshing];
    
    NSString *URL_Str = [NSString stringWithFormat:@"%@/goods/api/findCourseList", kURL_SHY];
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"storeId"] = kStoreId;
    __weak HomePageVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [VC parsingData:responseObject[@"data"]];
        [_tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [_tableView.mj_header endRefreshing];
        [VC makeToast:@"网络超时.请重试!"];
    }];
    
    
}
/**
 * 解析数据
 * @param array 存储数据的数组
 */
- (void)parsingData:(NSArray *)array {
    [self.goodsListArray removeAllObjects];
    for (NSDictionary *dataDic  in array) {
        
        NSEntityDescription *des = [NSEntityDescription entityForName:@"CourseListModel" inManagedObjectContext:self.managedContext];
        //根据描述 创建实体对象
        CourseListModel *model = [[CourseListModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
        
        for (NSString *key in dataDic) {
            //   NSLog(@"key%@",key);
            [model setValue:dataDic[key] forKey:key];
        }
        [self.goodsListArray addObject:model];
    }
    NSLog(@"self.goodsListArray%@", self.goodsListArray);
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self versionUpdate];
    [self.tableView.mj_header beginRefreshing];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];

    UIButton *releaseButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    releaseButton.frame = CGRectMake(0, 0, 70, 50);
    [releaseButton setImage:[UIImage imageNamed:@"ic_menu"] forState:(UIControlStateNormal)];
    releaseButton.titleLabel.font = [UIFont systemFontOfSize:17];
    UIEdgeInsets  edgeInsets = releaseButton.imageEdgeInsets;
    edgeInsets.left = -50;
    releaseButton.imageEdgeInsets = edgeInsets;
    [releaseButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [releaseButton addTarget:self action:@selector(RegisteredAccount) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.leftBarButtonItem = releaseButtonItem;
    
    
}
- (void)QuickAppointment {
    
    //http://192.168.100.101:8080/seller/student/api/quickMakeReservation?studentId=6eb2a978a5a445918a5ad06e2a366661
    NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/quickMakeReservation",kURL_SHY];
    
    NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
    URL_Dic[@"studentId"] = [UserDataSingleton mainSingleton].studentsId;
    __weak  HomePageVC *VC = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }else {
            [VC showAlert:responseObject[@"msg"] time:1.2];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [VC showAlert:@"请求失败请稍后重试!" time:1.2];
        NSLog(@"error%@", error);
    }];

    
    
}
- (void)RegisteredAccount {
    
    [self XYSideOpenVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.goodsListArray.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        CGRect frame = CGRectMake(0, 0, kScreen_widht, 200);
        NSArray *imageArr = @[@"Img1",@"Img2",@"Img3",@"Img4",@"Img5"];
        CLCycleView *cycleView = [[CLCycleView alloc] initWithFrame:frame duration:3 imageArr:imageArr];
        cycleView.delegate = self;
        cycleView.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        cycleView.pageIndicatorTintColor = [UIColor whiteColor];
        cycleView.diameter = 20;
        cycleView.cycleView = ^(NSInteger indexPage) {
            NSLog(@"block显示点击%ld张图片",indexPage);
        };
        self.cycleView = cycleView;
        [cell addSubview:self.cycleView];
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = MColor(249, 249, 249);
        [cell addSubview:titleView];
        titleView.sd_layout.leftSpaceToView(cell, 0).topSpaceToView(cycleView, 0).rightSpaceToView(cell, 0).heightIs(52);
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = MFont(kFit(16));
        titleLabel.textColor = MColor(45, 45, 45);
        titleLabel.text = @"马术学习套餐";
        [titleView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(titleView, 27).topSpaceToView(titleView, 21).heightIs(16).rightSpaceToView(titleView, 0);
        cell.backgroundColor = MColor(217, 217, 217);
        return cell;
    }else {
        LearnCarShowTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LearnCarShowTVCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.goodsListArray[indexPath.section-1];
        
        return cell;
    }
}
#pragma mark - cycleViewDelegate
- (void)cycleViewDidSelected:(NSInteger)pageIndex {
    NSLog(@"delegate显示点击%ld张图片",pageIndex);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsDetailsVC *VC = [[GoodsDetailsVC alloc] init];
    UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
    CourseListModel *model = self.goodsListArray[indexPath.row];
    VC.goodsId = model.goodsId;
    [self presentViewController:NAVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 262;
    }else {
        return 122;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 26;
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView  *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 26)];
    view.backgroundColor =MColor(240, 240, 240);
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.01;
    }else {
        return 14;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView  *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_widht, 16)];
    view.backgroundColor =MColor(240, 240, 240);
    return view;
}

- (void)versionUpdate{
    //获得当前发布的版本
    if(![self judgeNeedVersionUpdate])  return ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        NSString *URL_Str = [[NSString alloc] initWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",@"1325417441"];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"resultCount"]];
            if ([resultStr isEqualToString:@"1"]) {
                NSArray *array  = responseObject[@"results"];
                if (array.count == 0) {
                    
                }else {
                    dic = responseObject[@"results"][0];
                    NSLog(@"dic%@", dic);
                    //获得上线版本号
                    NSString *version = [dic objectForKey:@"version"];
                    
                    NSString *updateInfo = [dic objectForKey:@"releaseNotes"];
                    
                    //获得当前版本
                    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //更新界面
                        
                        NSLog(@"当前版本%@线上版本%@", currentVersion,version);
                        if ( version &&![version isEqualToString:currentVersion]) {
                            
                            NSString *message = [NSString stringWithFormat:@"有新版本发布啦!\n%@",updateInfo];
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"message:message delegate:self cancelButtonTitle:@"忽略"otherButtonTitles:@"前往更新",nil];
                            
                            [alertView show];
                        }else{
                            //已是最高版本
                            NSLog(@"已经是最高版本");
                        }
                    });
                }
            }else {
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@", error);
        }];
        
        
    });
}
/*根据被点击按钮的索引处理点击事件--当被按钮被点击了这里做出一个反馈*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==1) {
        NSString *url =@"https://itunes.apple.com/cn/app/%E9%AA%90%E9%AA%A5%E9%A9%AC%E6%9C%AF/id1325417441?mt=8";//
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}
//每天进行一次版本判断
- (BOOL)judgeNeedVersionUpdate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取年-月-日
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *currentDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"];
    if ([currentDate isEqualToString:dateString]) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"currentDate"];
    return YES;
}


@end
