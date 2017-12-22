//
//  StudentsCenterVC.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/11/7.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "StudentsCenterVC.h"
#import "EnrollDetailsVC.h"
#import "MyOrderViewController.h"
#import "UserInfoHomeViewController.h"
#import "SettingViewController.h"
#import "CouponListViewController.h"
#import "AccountViewController.h"
@interface StudentsCenterVC ()
@property (nonatomic, strong)NSMutableArray *viewControllerArray;
@property (weak, nonatomic) IBOutlet UILabel *studentDriverStateLabel;

/**
 余额
 */
@property (weak, nonatomic) IBOutlet UILabel *BalanceLabel;
/**
骑马币
 */
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
/**
 优惠券
 */
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;
/**
 消息展示view
 */
@property (weak, nonatomic) IBOutlet UIView *messagesNumView;
/**
 消息数量
 */
@property (weak, nonatomic) IBOutlet UILabel *messagesLabel;
/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *HeadPortraitImageView;
/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/**
 电话
 */
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;

@end

@implementation StudentsCenterVC {
    
    NSString *avatar;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setHidesBottomBarWhenPushed:NO];
    
    self.navigationController.navigationBar.hidden = YES;
    self.userNameLabel.text = @"未登录";
    self.userPhoneLabel.text = @"";
    self.BalanceLabel.text = @"0";
    self.couponsLabel.text = @"0";
    self.currencyLabel.text = @"0";
    [self AnalysisUserData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setHidesBottomBarWhenPushed:YES];
}
- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
        for (int i = 0; i <= 5; i++) {
            MyOrderViewController *MyOrderVC = [[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
            if (i == 0) {
                MyOrderVC.index  = 6;
            }else {
                MyOrderVC.index = i - 1;
            }
            [_viewControllerArray addObject:MyOrderVC];
        }
    }
    return _viewControllerArray;
}

//报名订单
- (IBAction)handleStudentDriverOrder:(UIButton *)sender {
    EnrollDetailsVC *VC = [[EnrollDetailsVC alloc] init];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
    [self setHidesBottomBarWhenPushed:YES];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//马术学习订单
- (IBAction)handleSignUpOrder:(UIButton *)sender {
    MyOrderViewController *FYLPageVC =[[MyOrderViewController alloc]initWithNibName:@"MyOrderViewController" bundle:nil];
    UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:FYLPageVC];
    //NAVC.navigationBarHidden = YES;
    [self setHidesBottomBarWhenPushed:YES];
    [self presentViewController:NAVC animated:YES completion:nil];
}

- (IBAction)handleReservationTest:(UIButton *)sender {
    [self showAlert:@"该功能未开通"];
}
//分享注册
- (IBAction)handleShareRegistered:(UIButton *)sender {
    
    
    [self showAlert:@"该功能正在开发中!"];
    return;
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"AppIcon"]];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/share/to_jump?share_type_id=2&school_id=%@&stu_id=%@",kURL_SHY,kStoreId,[UserDataSingleton mainSingleton].studentsId]]
                                      title:@"分享注册"
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
}
- (IBAction)handleMyData:(UIButton *)sender {
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        LogInViewController *loginVC = [[LogInViewController alloc] init];
        UINavigationController * NALoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        NALoginVC.navigationBarHidden = YES;
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NALoginVC animated:YES completion:nil];
        return;
    }
    UserInfoHomeViewController *viewController = [[UserInfoHomeViewController alloc] initWithNibName:@"UserInfoHomeViewController" bundle:nil];
    
    viewController.avatar =  avatar;
    NSLog(@"UserInfoHomeViewController%@", avatar);
    
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}

- (IBAction)handleMySetUp:(UIButton *)sender {
    
    SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//查看余额
- (IBAction)handleCheckBalance:(UIButton *)sender {
    AccountViewController *viewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}
//查看积分
- (IBAction)handleCheckIntegral:(UIButton *)sender {
    [self  showAlert:@"该功能暂未开放"];
    return;
}
//查看优惠券
- (IBAction)handleCheckCoupons:(UIButton *)sender {
    CouponListViewController *viewController = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)AnalysisUserData{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSLog(@"paths%@", paths);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"UserLogInData.plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSArray *keyArray =[userData allKeys];
    
    if (keyArray.count == 0) {
        
        
    }else {
        
        NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/detail", kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"studentId"] =userData[@"stuId"];
        NSLog(@"URL_Dic%@", URL_Dic);
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        __block StudentsCenterVC *VC = self;
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            
            if ([resultStr isEqualToString:@"0"]) {
                [VC showAlert:responseObject[@"msg"] time:1.2];
            }else {
                [VC AnalyticalData:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [VC showAlert:@"请求失败请重试" time:1.0];
        }];
    }
}
//解析的用户详情的数据
- (void)AnalyticalData:(NSDictionary *)dic {
    NSEntityDescription *des = [NSEntityDescription entityForName:@"UserDataModel" inManagedObjectContext:self.managedContext];
    //根据描述 创建实体对象
    UserDataModel *model = [[UserDataModel alloc] initWithEntity:des insertIntoManagedObjectContext:self.managedContext];
    NSString *state = [NSString stringWithFormat:@"%@", dic[@"result"]];
    if ([state isEqualToString:@"1"]) {
        NSDictionary *urseDataDic = dic[@"data"][0];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserLogInData" ofType:@"plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [userData removeAllObjects];
        for (NSString *key in urseDataDic) {
            if ([key isEqualToString:@"subState"]) {
                [UserDataSingleton mainSingleton].subState =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"stuId"]) {
                [UserDataSingleton mainSingleton].studentsId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"coachId"]) {
                [UserDataSingleton mainSingleton].coachId =[NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"state"]) {
                
                [UserDataSingleton mainSingleton].state = [NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
            if ([key isEqualToString:@"balance"]) {
                [UserDataSingleton mainSingleton].balance = [NSString stringWithFormat:@"%@", urseDataDic[key]];
            }
        //    NSLog(@"key%@",key);
            [userData setObject:urseDataDic[key] forKey:key];
            [model setValue:urseDataDic[key] forKey:key];
        }
        //获取应用程序沙盒的Documents目录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPath1 = [paths objectAtIndex:0];
        //得到完整的文件名
        NSString *filename=[plistPath1 stringByAppendingPathComponent:@"UserLogInData.plist"];
        //输入写入
        [userData writeToFile:filename atomically:YES];
        //那怎么证明我的数据写入了呢？读出来看看
        NSMutableDictionary *userData2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    }
    self.userNameLabel.text = model.userName.length==0?@"未设置":model.userName;
    self.userPhoneLabel.text = model.phone;
    self.BalanceLabel.text = [NSString stringWithFormat:@"%d",model.balance];
    self.couponsLabel.text = [NSString stringWithFormat:@"%d",model.ticket];
    self.currencyLabel.text = [NSString stringWithFormat:@"%ld",model.points];
    NSString *subState;
    self.studentDriverStateLabel.text = @"";
    avatar=model.avatar;
    NSLog(@"avatar%@", avatar);
    self.HeadPortraitImageView.layer.cornerRadius = self.HeadPortraitImageView.frame.size.width/2;
    self.HeadPortraitImageView.layer.masksToBounds = YES;
    [self.HeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kURL_Image, model.avatar]] placeholderImage:[UIImage imageNamed:@"icon_portrait_default"]];
  
}

@end
