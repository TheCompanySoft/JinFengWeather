//
//  PersoninfoViewController.m
//  JinFengWeather
//
//  Created by huake on 15/9/18.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//个人信息界面可以上传头像绑定邮箱

#import "PersoninfoViewController.h"
#import "UIUtils.h"
#import "Header.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Simple.h"
#import "LoginMainView.h"
#import "AFNetworking.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define ORIGINAL_MAX_WIDTH 640.0f
#define LIGHT_OPAQUE_BLACK_COLOR [UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:0.4f]
@interface PersoninfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,VPImageCropperDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIView *_bgView;
    MBProgressHUD *_HUD;//提示
    UIImage *portraitImg;
    UIImageView *_headerView;
    UIButton *_photoBtn;
    UILabel *_nameLable;
    LoginMainView*_logmainView;
    VPImageCropperViewController *_vpcVC;
    NSUserDefaults *defaults;
    NSUserDefaults *userDefaults;
    UIView *_editTileOpaqueView;//背影
    UITextField *_textfield1;
    UIView *_alertView;
    UITextField*_endAdressTF;
    NSString* documentPath;
    UIAlertView*_sucessAlert;
}
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIView * horizontalSeparator;
@property (nonatomic, strong) UIView * verticalSeparator;
@end

@implementation PersoninfoViewController

- (void)viewDidLoad {
    //Set up Seperator
    self.horizontalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    self.verticalSeparator = [[UIView alloc] initWithFrame:CGRectZero];
    documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    defaults = [NSUserDefaults standardUserDefaults];
    userDefaults = [NSUserDefaults standardUserDefaults];
    //
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title =@"个人信息";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //设置navigationBar
    [self setnavigationbar];
    [self addheadView];
    [self addmessageView];
    [self.view addSubview:self.portraitImageView];
    
    [self setStatusBarColor];
    _bgView =[[UIView alloc]initWithFrame:self.view.frame];
    _bgView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
}
//把状态栏设置为白色
- (void)setStatusBarColor
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)addheadView{
    UIImage *headimage=[UIImage imageNamed:@"userinfo_bg@2x.jpg"];
    _headerView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIUtils getWindowWidth], [UIUtils getWindowHeight]/3)] ;
    _headerView.backgroundColor=[UIColor redColor];
    [_headerView setImage:headimage];
    [self.view addSubview:_headerView];
    [self portraitImageView1];
    _nameLable =[[UILabel alloc]initWithFrame:AdaptCGRectMake(120,130,80,30)];
    
    NSString *myname=[defaults objectForKey:@"myname"];
    _nameLable.text=myname;
    _nameLable.textAlignment=NSTextAlignmentCenter;
    _nameLable.adjustsFontSizeToFitWidth =YES;
    _nameLable.textColor=[UIColor whiteColor];
    [_headerView addSubview:_nameLable];
    
}
//头像
- (void)portraitImageView1 {
    
    UIImage *photoImage=[UIImage imageNamed:@"headImg@2x.png"];
    _portraitImageView = [[UIImageView alloc] initWithFrame:AdaptCGRectMake(0, 0, photoImage.size.width, photoImage.size.height)];
    _portraitImageView.center=CGPointMake([UIUtils getWindowWidth]/2, _portraitImageView.frame.size.height/5*4);
    
    [_portraitImageView setImage:photoImage];
    [_headerView addSubview:_portraitImageView];
    //读取本地图片非resource
    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/userAvatar.jpg",NSHomeDirectory()];
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    if (imgFromUrl3!=Nil) {
        [_portraitImageView setImage:imgFromUrl3];
    }else{
        
        
    }
    [self addxiugai];
    [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
    [_portraitImageView.layer setMasksToBounds:YES];
    [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_portraitImageView setClipsToBounds:YES];
    _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _portraitImageView.layer.shadowOpacity = 0.5;
    _portraitImageView.layer.shadowRadius = 2.0;
    _portraitImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [_portraitImageView addGestureRecognizer:portraitTap];
    
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
    _portraitImageView.image = editedImage;
    [self saveImage:editedImage WithName:@"userAvatar.jpg"];
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
                                 //  NSLog(@"Picker View Controller is presented");
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
        portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
            
        }];
    }];
}
//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)image1
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSString* totalPath = [documentPath stringByAppendingPathComponent:image1];
    //保存到 document
    [imageData writeToFile:totalPath atomically:NO];
    //保存到 NSUserDefaults
    [userDefaults setObject:totalPath forKey:@"avatar"];
    [userDefaults synchronize];
    //显示提示
    _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"上传中..." customView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"file":totalPath};
    [manager POST:@"http://weather.huakesoft.com/api/uploadfile" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:totalPath
                                mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *JSONString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic= [self dictionaryWithJsonString:JSONString];
        NSString *strpath=[dic objectForKey:@"path"];
        NSString *userid=[defaults objectForKey:@"useId"];
        //NSLog(@"ffffff%@",userid);
        //        //修改头像
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *parameters = @{@"id":userid,@"headicon":strpath};
        //        [manager POST:@"http://weather.huakesoft.com/api/update?" parameters:parameters constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSLog(@"11111111111%@",responseObject);
        //            NSLog(@"////修改头像OK");
        //            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        }];
        [manager GET:@"http://weather.huakesoft.com/api/update?" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *JSONString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dic= [self dictionaryWithJsonString:JSONString];
            
            NSString *str=[dic objectForKey:@"email"];
            [userDefaults setObject:str forKey:@"emal"];
            
            [_HUD hide:YES afterDelay:0.0f];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES afterDelay:0.0f];
        _HUD=[MBProgressHUD  show:MBProgressHUDModeIndeterminate message:@"网络状态不佳" customView:self.view];
        [_HUD hide:YES afterDelay:0.3f];
    }];
}
//添加头像
-(void)addxiugai{
    NSString *email=[defaults objectForKey:@"emal"];
    _textfield1.text=email;
    //  NSLog(@"%@",_textfield1.text);
    NSString *ue=@"http://weather.huakesoft.com/";
    NSString *iconhead=[defaults objectForKey:@"headicon"];
    if ( iconhead.length>0) {
        NSString* urlstt=[NSString stringWithFormat:@"%@%@",ue,[defaults objectForKey:@"headicon"]];
        
        [self performSelectorInBackground:@selector(loadimage:) withObject:urlstt];
    }
    
    NSString *imageurl=[defaults objectForKey:@"imageurl"];
    //NSLog(@"imageurl---%@",imageurl);
    [self performSelectorInBackground:@selector(loadimage:) withObject:imageurl];
    
}
-(void)loadimage:(NSString*)urlstr{
    //  NSLog(@"urlstr=%@____%@",urlstr,[NSThread currentThread]);
    //下载图片
    NSURL*url=[NSURL URLWithString:urlstr];
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *image=[UIImage imageWithData:data];
    NSString* totalPath = [documentPath stringByAppendingPathComponent:@"userAvatar.jpg"];
    
    [data writeToFile:totalPath atomically:NO];
    if (image) {
        //回到主线程
        [self  performSelectorOnMainThread:@selector(loadImageFinish:) withObject:image waitUntilDone:YES];
    }
    
    
}
-(void)loadImageFinish:(UIImage*)image{
    
    [_portraitImageView setImage:image];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
        
    }
    return dic;
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
-(void)addmessageView{
    for (int i =0; i<2; i++) {
        UIView *lineView =[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 250+60*i , 320, 1)];
        lineView.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.6];
        [self.view addSubview:lineView];
        UIImage *emilView =[UIImage imageNamed:@"email@2x"];
        UIImage *telView =[UIImage imageNamed:@"tel@2x"];
        UILabel *iconlable =[[UILabel alloc]initWithFrame:AdaptCGRectMake(45, 250-60*i+20,80,30)];
        iconlable.textColor=[UIColor grayColor];
        
        
        if (i==0) {
            UIImageView *iconView =[[UIImageView alloc]initWithFrame:AdaptCGRectMake(15, 250-60*i+28,emilView.size.width,emilView.size.height)];
            [iconView setImage:emilView];
            
            [self.view addSubview:iconView];
            iconlable.text=@"我的邮箱";
            
        }else{
            UIImageView *iconView =[[UIImageView alloc]initWithFrame:AdaptCGRectMake(15, 250-60*i+20,telView.size.width,telView.size.height)];
            [iconView setImage:telView];
            [self.view addSubview:iconView];
            iconlable.text=@"我的手机";
        }
        [self.view addSubview:iconlable];
    }
    _textfield1 =[[UITextField alloc]initWithFrame:AdaptCGRectMake(105, 250+20, 200, 30)];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=AdaptCGRectMake(0, 0, 200, 30);
    [btn addTarget:self action:@selector(editEmalView) forControlEvents:UIControlEventTouchUpInside];
    [_textfield1 addSubview:btn];
    if (_textfield1.text==nil) {
        NSString *email=[defaults objectForKey:@"email"];
        _textfield1.text=email;
    }else{
        NSString *emai=[userDefaults objectForKey:@"emal"];
        _textfield1.text=emai;
    }
    
    _textfield1.placeholder=@"点击绑定邮箱";
    _textfield1.textAlignment=NSTextAlignmentRight;
    _textfield1.textColor=[UIColor grayColor];
    
    
    
    [self.view addSubview:_textfield1];
    UITextField *textfield =[[UITextField alloc]initWithFrame:AdaptCGRectMake(105, 250-60+20, 200, 30)];
    textfield.textColor=[UIColor grayColor];
    textfield.textAlignment=NSTextAlignmentRight;
    textfield.userInteractionEnabled=NO;
    NSString *phone=[defaults objectForKey:@"myphone"];
    textfield.text=phone;
    [self.view addSubview:textfield];
}
//设置navigationBar
-(void)setnavigationbar{
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:41/255.0 green:147/255.0 blue:209/255.0 alpha:1.0];
    //设置navigationBar的属性
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                      }];
    
    //返回按钮2
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"goback@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    //设置按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem= backItem;
}
#pragma mark 常用方法
-(void)editEmalView{
    
    _alertView=[[UIView alloc]initWithFrame:AdaptCGRectMake(30, 120, 260,140)];
    _alertView.backgroundColor=[UIColor colorWithRed:253.0/255 green:253.0/25 blue:253.0/25 alpha:0.95];
    _alertView.layer.cornerRadius=8;
    UILabel *alertlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 5,240, 35)];
    alertlable.backgroundColor=[UIColor clearColor];
    alertlable.text=@"添加邮箱";
    alertlable.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    alertlable.textAlignment=NSTextAlignmentCenter;
    [_alertView addSubview:alertlable];
    _endAdressTF=[[UITextField alloc]initWithFrame:AdaptCGRectMake(10,50,240,30)];
    _endAdressTF.backgroundColor=[UIColor whiteColor];
    _endAdressTF.layer.borderColor=[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:202/255.0].CGColor;
    _endAdressTF.delegate=self;
    _endAdressTF.keyboardType = UIKeyboardTypeEmailAddress;
    _endAdressTF.layer.borderWidth=1;
    [_endAdressTF becomeFirstResponder];
    _endAdressTF.placeholder=@"请输入邮箱号";
    _endAdressTF.font=[UIFont systemFontOfSize:14];
    self.horizontalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 90, 260, 0.5)];
    
    self.horizontalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
    self.verticalSeparator=[[UIView alloc]initWithFrame:AdaptCGRectMake(130, 91,0.5, 49)];
    self.verticalSeparator.backgroundColor=[UIColor colorWithRed:196.0/255 green:196.0/255 blue:201.0/255 alpha:1.0];
    
    [_alertView addSubview:self.verticalSeparator];
    [_alertView addSubview:self.horizontalSeparator];
    _alertView.layer.shadowColor=[UIColor grayColor].CGColor;
    _alertView.layer.shadowOffset=CGSizeMake(1, 1);
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 addTarget:self action:@selector(updateCancelAction) forControlEvents:UIControlEventTouchUpInside];
    btn3.frame=AdaptCGRectMake(20,98,100,35);
    [btn3 setTitle:@"取消" forState:UIControlStateNormal];
    btn3.backgroundColor=[UIColor clearColor];
    [btn3 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_alertView addSubview:btn3];
    UIButton *btn4=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 addTarget:self action:@selector(updateSaveAction) forControlEvents:UIControlEventTouchUpInside];
    btn4.frame=AdaptCGRectMake(140,98,100,35);
    [btn4 setTitle:@"确定" forState:UIControlStateNormal];
    btn4.backgroundColor=[UIColor clearColor];
    [btn4 setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [_alertView addSubview:btn4];
    [_alertView addSubview:_endAdressTF];
    [self.view addSubview:_bgView];
    [_bgView addSubview:_alertView];
}
-(BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//绑定邮箱
-(void)updateSaveAction{
    
    
    
    if (![self validateEmail:_endAdressTF.text]) {
        //提示框
        UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的邮箱号有误请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_endAdressTF resignFirstResponder];
        [failureAlertView show];
    }else{
        [_alertView removeFromSuperview];
        [_bgView removeFromSuperview];
        [_endAdressTF resignFirstResponder];
        //显示提示
        _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"邮箱绑定中..." customView:self.view];
        _textfield1.text=_endAdressTF.text;
        NSString *userid=[defaults objectForKey:@"useId"];            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSDictionary *parameters = @{@"id":userid,@"email":_endAdressTF.text};
        [manager POST:@"http://weather.huakesoft.com/api/update?" parameters:parameters constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *JSONString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dic= [self dictionaryWithJsonString:JSONString];
            NSString *email=[dic objectForKey:@"email"];
            [userDefaults setObject:email forKey:@"emal"];
            [_HUD hide:YES afterDelay:0.0f];
            _sucessAlert=[[UIAlertView alloc]initWithTitle:nil message:@"绑定成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [_sucessAlert show];
            NSTimer *timer;
            timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_HUD hide:YES afterDelay:0.0f];
            
            
            _HUD=[MBProgressHUD  show:MBProgressHUDModeIndeterminate message:@"网络状态不佳" customView:self.view];
            [_HUD hide:YES afterDelay:0.3f];
        }];
    }
}
-(void)doTime

{
    
    //alert过1秒自动消失
    [_sucessAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    
}
-(void)updateCancelAction{
    [_alertView removeFromSuperview];
    [_bgView removeFromSuperview];
    [_endAdressTF resignFirstResponder];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    [_bgView removeFromSuperview];
    return YES;
    
}

-(void)add{
    if ((_alertView.hidden=NO)) {
        _alertView.hidden=YES;
    }
    if ([_endAdressTF becomeFirstResponder]) {
        [_endAdressTF resignFirstResponder];
    }
    [_bgView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
