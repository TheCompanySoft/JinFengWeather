//
//  LoginViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/17.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//登录界面C

#import "LoginViewController.h"
#import "UIUtils.h"
#import "RegistViewController.h"
#import "HomeViewController.h"
#import "MissCodeViewController.h"
#import "LoginMainView.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SideBarMenuViewController.h"
#import "LeftViewController.h"
#import "UMSocial.h"
#import "AFNetworking.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface LoginViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,LoginMainViewdelegate,VPImageCropperDelegate>
{
    SideBarMenuViewController *_sideBarMenuVC;
    NSUserDefaults *_personDefault;
    LoginMainView *_loginMainView;
}
@property(nonatomic, copy) NSString *thirdUID;
@property(nonatomic, copy) NSString *third_type;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加登录主页视图
    [self addLoginView];
}
//添加登录主页视图
-(void)addLoginView{
    
    _loginMainView = [[LoginMainView alloc]initWithFrame:self.view.frame];
    _loginMainView.delegate =self;
    [self.view addSubview:_loginMainView];
    
    
}
#pragma mark 按钮的点击方法
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _loginMainView.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                
                             }];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]
                                    initWithTitle:@"您的手机没有拍照功能"
                                    message:nil
                                    delegate:nil
                                    cancelButtonTitle:@"知道了"
                                    otherButtonTitles: nil];
            [alertView show];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){

                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) 
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

-(void)logIn{
    
    UIViewController *viewController = [[UIViewController alloc] init];
    _sideBarMenuVC = [[SideBarMenuViewController alloc] initWithRootViewController:viewController];
    //设定_sideBarMenuVC的左侧栏
    LeftViewController *leftViewController= [[LeftViewController alloc] init];
    leftViewController.sideBarMenuVC = _sideBarMenuVC;
    _sideBarMenuVC.leftViewController = leftViewController;
    //leftViewController展示主视图
    [leftViewController showViewControllerWithSection:0 Index:1];
   
    [self presentViewController:_sideBarMenuVC animated:YES completion:nil];
}
-(void)registration{
//    NSLog(@"注册");
    RegistViewController *registVC =[[RegistViewController alloc]init];
    UINavigationController *regnaVC=[[UINavigationController alloc]initWithRootViewController:registVC];
    [self presentViewController:regnaVC animated:YES completion:nil];
    
}
- (void)sinaButtonPress
{
    [self undoalert];
//    NSLog(@"新浪登录");
}

- (void)qqButtonPress
{
    [self undoalert];

//    NSLog(@"QQ登录");
}

- (void)weixinButtonPress
{
    //[self undoalert];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
//        NSLog(@"--fcff----%u",response.responseCode);
//        NSLog(@"+++ggg+%u",UMSResponseCodeSuccess);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            //存储登录状态
            _personDefault= [NSUserDefaults standardUserDefaults];
            [_personDefault setObject:@"1" forKey:@"isLogin"];
             [_personDefault setObject:snsAccount.userName forKey:@"myname"];
            [_personDefault setObject:snsAccount.iconURL forKey:@"imageurl"];
          
            [_personDefault synchronize];
            
           
            self.thirdUID = snsAccount.usid;
            self.third_type = @"1";
            
            //调用三方登录接口获取用户信息
            [self thirdLogin];
            [self logIn];
        
         //   NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSDictionary *dic = @{@"username":snsAccount.userName,@"password":@"123456",@"id":snsAccount.usid,@"headicon":snsAccount.iconURL,@"type":@"微信"};
            AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager GET:@"http://weather.huakesoft.com/api/register" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"-----%@-----",responseObject);
                NSDictionary *dic = responseObject;
                NSString *result = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                
                [_personDefault setObject:result forKey:@"useId"];
             //   NSLog(@"-------------%@",dic);
               
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //  NSLog(@"%@",error);
            }];
            
        }
        
    });
    
//    NSLog(@"微信登录");
//    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
      //  NSLog(@"SnsInformation is %@",response.data);
        NSString *imageurl=[response.data objectForKey:@"profile_image_url"];
        [_personDefault setObject:imageurl forKey:@"imageurl"];
//NSLog(@"++++++++++++%@",imageurl);
    }];
}

- (void)thirdLogin
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.thirdUID.length > 0) {
        [param setObject:self.thirdUID forKey:@"unionid"];
    }
    if (self.third_type.length > 0) {
        [param setObject:self.third_type forKey:@"third_type"];
    }
}

-(void)undoalert{
    UIAlertView*successAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能暂未开放" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [successAlertView show];
}
-(void)missPassWord{
    NSLog(@"忘记密码");
    MissCodeViewController *misCodeVC =[[MissCodeViewController alloc]init];
    UINavigationController *missnaVC=[[UINavigationController alloc]initWithRootViewController:misCodeVC];
    [self presentViewController:missnaVC animated:YES completion:nil];
    
}
-(void)back{
    
    NSLog(@"返回按钮被点击");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark LoginMainViewdelegate
-(void)loginMainViewphotoGet{
    [self editPortrait];
    
}
-(void)loginMainViewlogIn{
    [self logIn];
}
-(void)loginMainViewregistration{
    [self registration];
}

- (void)loginMainViewsinaButtonPress{
    [self sinaButtonPress];
}

- (void)loginMainViewqqButtonPress{
    [self qqButtonPress];
}

- (void)loginMainViewweixinButtonPress{
    [self weixinButtonPress];
}

-(void)loginMainViewmissPassWord{
    [self missPassWord];
}

-(void)loginMainViewback{
    [self back];
}



@end
