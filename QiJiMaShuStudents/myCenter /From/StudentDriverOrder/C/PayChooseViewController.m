//
//  PayChooseViewController.m
//  QiJiMaShuStudents
//
//  Created by 石山岭 on 2017/11/29.
//  Copyright © 2017年 石山岭. All rights reserved.
//

#import "PayChooseViewController.h"
#import "CouponListViewController.h"
#import "AccountViewController.h"
#import <AlipaySDK/AlipaySDK.h>
@interface PayChooseViewController ()
//输入金额
@property (weak, nonatomic) IBOutlet UITextField *EnterAmountTF;
//实付金额
@property (weak, nonatomic) IBOutlet UILabel *RealPayAmountLabel;
/**
 余额支付的状态图片
 */
@property (weak, nonatomic) IBOutlet UIButton *balancePayImage;
/**
 支付宝支付的状态图片
 */
@property (weak, nonatomic) IBOutlet UIButton *PayTreasureImage;
/**
 优惠券选择
 */
@property (weak, nonatomic) IBOutlet UIButton *CouponsChooseBtn;

/**
 确认支付按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *ConfirmPayBtn;

/**
 优惠券说明
 */
@property (weak, nonatomic) IBOutlet UILabel *CouponsThatLabel;

@end

@implementation PayChooseViewController {
    
    NSString *payState;//支付类型
    NSString *couponsId;//优惠券ID
}

- (void)viewDidLoad {
    [super viewDidLoad];
    payState = @"0";
    self.ConfirmPayBtn.layer.cornerRadius = 5;
    self.ConfirmPayBtn.layer.masksToBounds = YES;
    self.navigationItem.title =@"支付";
    
    self.navigationController.navigationBar.barTintColor = kNavigation_Color;//导航条颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:kFit(18)]}];//改变导航条标题的颜色与大小
    //返回按钮
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];//去除导航条上图片的渲染色
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:UIBarButtonItemStylePlain target:self action:@selector(handleReturn)];//自定义导航条按钮
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次
    [self.view addGestureRecognizer:singleFingerOne];
    //帮组按钮
    UIBarButtonItem *helpBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收费标准" style:(UIBarButtonItemStylePlain) target:self action:@selector(handleHelp)];
    self.navigationItem.rightBarButtonItem = helpBarButtonItem;
}

- (void)handleHelp {
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"收费标准" message:@"请和当值教练确定实际培训时常并支付金额。收费标准参照俱乐部初级会员收费标准.298/鞍+100元教练费/鞍时（自学不收取教练费）" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    [alertV addAction:cancle];
    // 4.控制器 展示弹框控件，完成时不做操作
    [self presentViewController:alertV animated:YES completion:^{
        nil;
    }];
}


- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tap {
    [self.EnterAmountTF resignFirstResponder];
}
- (void)handleReturn {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击选择优惠券. 如果 secder.tag ==1002 那么进入优惠券选择界面 如果是 1001 那么先判断 有没有优惠券 有的话 点击删除优惠券  没有的话店家选择优惠券
- (IBAction)handleClickChooseCoupon:(UIButton *)sender {
    [self.EnterAmountTF resignFirstResponder];
    __weak PayChooseViewController *selfVC =self;
    //如果还没有选择优惠券
    if (couponsId.length == 0) {
        //跳转优惠券界面
        CouponListViewController *VC = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
        VC.type = @"3";
        VC.obtainCoupons = ^(NSString *couponsID, NSInteger amount,NSString *type ,NSString *couponsTitle) {
            selfVC.CouponsThatLabel.text = couponsTitle;
            couponsId = couponsID;
            [selfVC.CouponsChooseBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:(UIControlStateNormal)];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    else//否者就是已经使用优惠券了
    {
        //如果是点击的删除优惠券按钮
        if (sender.tag == 1001)
        {
            //删除优惠券ID
            couponsId = @"";
            [self.CouponsChooseBtn setImage:[UIImage imageNamed:@"weixuan"] forState:(UIControlStateNormal)];
            self.CouponsThatLabel.text = @"暂未选择优惠券!";
        }
        else//否者就是点击跳转优惠券界面重新选择优惠券
        {
            CouponListViewController *VC = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:nil];
            VC.type = @"3";
            
            VC.obtainCoupons = ^(NSString *couponsID, NSInteger amount,NSString *type,NSString *couponsTitle) {
                couponsId = couponsID;
                selfVC.CouponsThatLabel.text = couponsTitle;
                [selfVC.CouponsChooseBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:(UIControlStateNormal)];
            };
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    }
   
    
}
//取消选择优惠券
- (IBAction)handleCancelCoupon:(id)sender {
    [self.EnterAmountTF resignFirstResponder];
    couponsId = @"";
    [self.CouponsChooseBtn setImage:[UIImage imageNamed:@"weixuan"] forState:(UIControlStateNormal)];
}
//支付宝支付点击
- (IBAction)handlePayTreasurePay:(id)sender {
    [self.EnterAmountTF resignFirstResponder];
    payState = @"1";
    [self.balancePayImage setImage:[UIImage imageNamed:@"weixuan"] forState:(UIControlStateNormal)];
    [self.PayTreasureImage setImage:[UIImage imageNamed:@"gouxuan"] forState:(UIControlStateNormal)];
}
//余额支付点击
- (IBAction)handleBalancePay:(id)sender {
    [self.EnterAmountTF resignFirstResponder];
    payState = @"0";
    [self.balancePayImage setImage:[UIImage imageNamed:@"gouxuan"] forState:(UIControlStateNormal)];
    [self.PayTreasureImage setImage:[UIImage imageNamed:@"weixuan"] forState:(UIControlStateNormal)];
}
//确认支付
- (IBAction)handleConfirmPay:(id)sender {
    [self.EnterAmountTF resignFirstResponder];
    if (couponsId.length == 0) {
        if (self.EnterAmountTF.text.length  == 0) {
            [self showAlert:@"金额不能为 0 " ];
            return;
        }
        [self pay];
    }else {
        [self.EnterAmountTF resignFirstResponder];
        
        NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/updateOrderInfo",kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        __weak  PayChooseViewController *VC = self;
        URL_Dic[@"orderId"] = self.SDOModel.orderId;
        URL_Dic[@"couponMemberId"] = couponsId;
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            if ([resultStr isEqualToString:@"1"]) {
                [self pay];
            }else {
                [VC showAlert:responseObject[@"msg"] time:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error%@", error);
        }];
        
    }
}

- (void)pay {
    [self indeterminateExample];
    __weak  PayChooseViewController *VC = self;
    if ([payState isEqualToString:@"0"]) {//余额支付
        
        
        NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/pay",kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"stuId"]=[UserDataSingleton mainSingleton].studentsId;
        URL_Dic[@"orderSn"] = self.SDOModel.orderSn;
        URL_Dic[@"amount"] =self.EnterAmountTF.text;
        NSLog(@"URL_Dic%@", URL_Dic);
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"uploadProgress%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            [VC delayMethod];
            if ([resultStr isEqualToString:@"1"]) {
                [VC showAlert:responseObject[@"msg"] time:1.2];
                AccountViewController *viewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
                viewController.type = @"6";
                [VC.navigationController pushViewController:viewController animated:YES];
            }else {
                [VC showAlert:responseObject[@"msg"] time:1.2];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [VC delayMethod];
            NSLog(@"error%@", error);
        }];
    }else if ([payState isEqualToString:@"1"]){//支付宝支付
        if (self.EnterAmountTF.text.floatValue <=0) {
            if (couponsId.length == 0) {
                NSString *URL_Str = [NSString stringWithFormat:@"%@/student/api/pay",kURL_SHY];
                NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
                URL_Dic[@"stuId"]=[UserDataSingleton mainSingleton].studentsId;
                URL_Dic[@"orderSn"] = self.SDOModel.orderSn;
                URL_Dic[@"amount"] =self.EnterAmountTF.text;
                NSLog(@"URL_Dic%@", URL_Dic);
                
                AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
                [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
                    NSLog(@"uploadProgress%@", uploadProgress);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"responseObject%@", responseObject);
                    NSString *resultStr = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
                    [VC delayMethod];
                    if ([resultStr isEqualToString:@"1"]) {
                        [VC showAlert:responseObject[@"msg"] time:1.2];
                        AccountViewController *viewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
                        viewController.type = @"6";
                        [VC.navigationController pushViewController:viewController animated:YES];
                    }else {
                        [VC showAlert:responseObject[@"msg"] time:1.2];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"error%@", error);
                    [VC showAlert:@"网络超时请重试!"];
                    [VC delayMethod];
                }];
                
            }
        }
        
        
        StudentDriverOrderModel *model = self.SDOModel;
        [self performSelector:@selector(indeterminateExample)];
        NSString *URL_Str = [NSString stringWithFormat:@"%@/alipay/api/generateSignature",kURL_SHY];
        NSMutableDictionary *URL_Dic = [NSMutableDictionary dictionary];
        URL_Dic[@"body"] = @"一键预约";
        URL_Dic[@"subject"]=@"结账";
        URL_Dic[@"outTradeNo"]=model.orderSn;
        URL_Dic[@"totalAmount"] = @"0.01";//[NSString stringWithFormat:@"%.2f",model.orderAmount];
        NSLog(@"------------------------------URL_Dic%@", URL_Dic);
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:URL_Str parameters:URL_Dic progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@", uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"requestPaymentSignature%@", responseObject);
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"result"]];
            [VC performSelector:@selector(delayMethod)];
            if ([str isEqualToString:@"1"]) {
                NSString *signature = responseObject[@"data"];
                //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                NSString *appScheme = @"QiJiMaShuStudentsScheme";
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:signature fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    NSString *resultStatus = [NSString stringWithFormat:@"%@", resultDic[@"resultStatus"]];
                    NSInteger state = resultStatus.integerValue;
                    [VC performSelector:@selector(delayMethod)];
                    switch (state) {
                        case 9000: {
                            [VC showAlert:@"订单支付成功"];
                            AccountViewController *viewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
                            viewController.type = @"6";
                            [VC.navigationController pushViewController:viewController animated:YES];
                        }
                            break;
                        case 8000: {
                            [VC showAlert:@"正在处理中，支付结果未知（有可能已经支付成功），请查询订单列表中订单的支付状态"];
                            AccountViewController *viewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
                            viewController.type = @"6";
                            [VC.navigationController pushViewController:viewController animated:YES];
                        }
                            break;
                        case 4000:
                            [VC showAlert:@"订单支付失败"];
                            
                            break;
                        case 6001:
                            [VC showAlert:@"用户中途取消"];
                            
                            break;
                        case 6002:
                            [VC showAlert:@"网络连接出错"];
                            
                            break;
                        default:
                            break;
                    }
                    
                }];
            }else {
                [VC showAlert:@"订单提交失败请重试!"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [VC performSelector:@selector(delayMethod)];
            [VC showAlert:@"网络出现问题.请稍后再试!" time:1.0];
            NSLog(@"%@", error);
        }];
    
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer {//弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *)message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.8
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
//网络加载指示器
- (void)indeterminateExample {
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];//加载指示器出现
    
}

- (void)delayMethod{
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];//加载指示器消失
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
