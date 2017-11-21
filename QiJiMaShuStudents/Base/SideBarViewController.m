//
//  SideBarViewController.m
//  guangda_student
//
//  Created by Dino on 15/3/25.
//  Copyright (c) 2015年 daoshun. All rights reserved.
//

#import "SideBarViewController.h"
#import "MyOrderViewController.h"
#import "AccountListViewController.h"
#import "SystemMessageViewController.h"
#import "ComplaintViewController.h"
#import "SettingViewController.h"
#import "UserInfoHomeViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "MyOrderViewController.h"
@interface SideBarViewController ()

@property (strong, nonatomic) IBOutlet UIView *systemMessageView;
@property (strong, nonatomic) IBOutlet UIImageView *messageIcon;
@property (strong, nonatomic) IBOutlet UIImageView *messageRed;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (nonatomic, strong)NSMutableArray *viewControllerArray;

@end

@implementation SideBarViewController
- (NSMutableArray *)viewControllerArray {
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
        for (int i = 0; i <= 5; i++) {
            MyOrderViewController *MyOrderVC = [[MyOrderViewController alloc] initWithNibName:@"MyOrderViewController" bundle:nil];
            MyOrderVC.index = i;
            [_viewControllerArray addObject:MyOrderVC];
        }
        
    }
    return _viewControllerArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userNameLabel.text = @"账号未登录";
    self.phoneNumLabel.text = @"";
    [self.userLogo setImage:[UIImage imageNamed:@"login_icon"]];
    self.addrLabel.text = @"";
    
    self.userLogo.layer.cornerRadius = self.userLogo.bounds.size.width/2;
    self.userLogo.layer.masksToBounds = YES;
    //监听每次 用户详情接口的请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangesData) name:@"ChangesData" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self ChangesData];
}
// 是否显示小红点，提示有消息未读
- (void)showRedPoint {
    
}
- (void)ChangesData {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename=[plistPath stringByAppendingPathComponent:@"UserLogInData.plist"];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"userData%@", userData);
    NSArray *keyArray =[userData allKeys];
    if (keyArray.count == 0 || [UserDataSingleton mainSingleton].studentsId.length == 0) {
        self.userNameLabel.text = @"账号未登录";
        self.phoneNumLabel.text = @"";
        [self.userLogo setImage:[UIImage imageNamed:@"login_icon"]];
        self.addrLabel.text = @"";
        return;
    }
    NSString *userName = [userData objectForKey:@"realName"];
    NSString *phoneNum = [userData objectForKey:@"phone"];
    self.userNameLabel.text = userName?userName:@"未设置";
    self.phoneNumLabel.text = phoneNum;
    [self.userLogo sd_setImageWithURL:[NSURL URLWithString:[userData objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"login_icon"]];
    
}

// 个人信息
- (IBAction)userInfo:(id)sender {
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        LogInViewController *VC = [[LogInViewController alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:NAVC animated:YES completion:nil];
    }else {
        UserInfoHomeViewController *viewController = [[UserInfoHomeViewController alloc] initWithNibName:@"UserInfoHomeViewController" bundle:nil];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:NAVC animated:YES completion:nil];
    }
}

// 我的订单
- (IBAction)myOrderClick:(id)sender {
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        
        LogInViewController *VC = [[LogInViewController alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:NAVC animated:YES completion:nil];
    }else {
        //0:未完成,1:已完结,2:取消中,3:已取消,4:申诉中,5:已关闭)
        FYLPageViewController *FYLPageVC =[[FYLPageViewController alloc]initWithTitles:@[@"未完成",@"已完成",@"取消中",@"已取消",@"申诉中",@"已关闭"] viewControllers:self.viewControllerArray];
        UINavigationController * NAVC = [[UINavigationController alloc] initWithRootViewController:FYLPageVC];
        //NAVC.navigationBarHidden = YES;
        [self setHidesBottomBarWhenPushed:YES];
        [self presentViewController:NAVC animated:YES completion:nil];
    }
}
// 账户
- (IBAction)accountClick:(id)sender {
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        
        LogInViewController *VC = [[LogInViewController alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:NAVC animated:YES completion:nil];
    }else {
    AccountListViewController *viewController = [[AccountListViewController alloc] initWithNibName:@"AccountListViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
    }
}
//学骑马报名
- (IBAction)clickForSignUp:(id)sender{
    
    
}
// 系统消息
- (IBAction)messageClick:(id)sender {
    if ([UserDataSingleton mainSingleton].studentsId.length == 0) {
        
        LogInViewController *VC = [[LogInViewController alloc] init];
        UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:VC];
        [self presentViewController:NAVC animated:YES completion:nil];
    }else {
    SystemMessageViewController *viewController = [[SystemMessageViewController alloc] initWithNibName:@"SystemMessageViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
    }
}

// 设置
- (IBAction)settingClick:(id)sender
{
    SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    UINavigationController *NAVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:NAVC animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}



@end
