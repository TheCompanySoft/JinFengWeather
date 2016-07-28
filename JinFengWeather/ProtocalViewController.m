
//
//  ProtocalViewController.m
//  JinFengWeather
//
//  Created by huake on 15/11/17.
//  Copyright (c) 2015年 HKSoft. All rights reserved.
//用户协议

#import "ProtocalViewController.h"
#import "Header.h"
#import "UIUtils.h"
@interface ProtocalViewController ()
{
    UIButton*_nextButton;

}
@end

@implementation ProtocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    UILabel*headlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 25,120, 30)];
    headlable.center=CGPointMake(self.view.center.x,28);
    headlable.text=@"《用户服务协议》";
    headlable.font=[UIFont systemFontOfSize:20];
    headlable.adjustsFontSizeToFitWidth=YES;
    UITextView *textView=[[UITextView alloc]initWithFrame:AdaptCGRectMake(5, 0,310,518)];
    textView.editable=NO;
    [textView addSubview:headlable];
    NSString*str=@"\n\n  请务必认真阅读和理解本《用户服务协议》（以下简称《协议》）中规定的所有权利和限制。除非您接受本《协议》条款,否则您无权注册、登录或使用本协议所涉及的相关服务。您一旦注册、登录、使用或以任何方式使用本《协议》所涉及的相关服务的行为将视为对本《协议》的接受,即表示您同意接受本《协议》各项条款的约束。如果您不同意本《协议》中的条款,请不要注册、登录或使用本《协议》相关服务。 本《协议》是用户与北京博风慧能软件有限责任公司（下称“博风慧能”）之间的法律协议。\n    一、服务内容\n    1.1、“GO+”为“博风慧能”的所有者和经营者,完全按照其发布的服务条款和操作规则提供基于互联网以及移动互联网的相关服务（以下简称“网络服务”）。GO+网络服务由博风慧能根据实际情况提供,您一旦注册、登录、使用本网络服务,需要对自己在账户中的所有活动和事件负全责。如果由于您的过失导致您的账号和密码脱离您的控制,则由此导致的针对您、博风慧能或任何第三方造成的损害,您将承担全部责任。用户不应将其帐号、密码转让、出售或出借予他人使用,若用户授权他人使用账户,应对被授权人在该账户下发生所有行为负全部责任。\n    1.2、GO+网络服务以及各个频道单项服务条款和公告可由博风慧能随时更新,且无需另行通知。您在使用相关服务时,应关注并遵守其所适用的相关条款。您在使用GO+提供的各项服务之前,应仔细阅读本用户服务协议。如您不同意本协议,您可以主动取消GO+提供的服务;您一旦使用GO+服务,即视为您已了解并完全同意本协议各项内容,包括GO+对服务协议随时所做的任何修改,并成为GO+用户。\n    1.3、用户理解并接受,博风慧能仅提供相关的网络服务,除此之外与相关网络服务有关的设备（如个人电脑、手机、及其他与接入互联网或移动互联网有关的装置）及所需的费用（如为接入互联网而支付的电话费及上网费、为使用移动网而支付的手机费）均应由用户自行负担。\n    二、使用规则\n    2.1、用户在使用GO+服务时,必须遵守中华人民共和国相关法律法规的规定,用户应同意将不会利用本服务进行任何违法或不正当的活动,包括但不限于下列行为∶\n    2.1.1、上载、展示、张贴、传播或以其它方式传送含有下列内容之一的信息:\n    1)反对宪法所确定的基本原则的;\n    2)危害国家安全,泄露国家秘密,颠覆国家政权,破坏国家统一的; \n    3)损害国家荣誉和利益的; \n    4)煽动民族仇恨、民族歧视、破坏民族团结的;\n    5)破坏国家宗教政策,宣扬邪教和封建迷信的; \n    6)散布谣言,扰乱社会秩序,破坏社会稳定的;\n    7)散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的;\n    8)侮辱或者诽谤他人,侵害他人合法权利的;\n    9)含有虚假、有害、胁迫、侵害他人隐私、骚扰、侵害、中伤、粗俗、猥亵、或其它道德上令人反感的内容;\n    10) 含有中国法律、法规、规章、条例以及任何具有法律效力之规范所限制或禁止的其它内容的;\n    2.1.2、不得为任何非法目的而使用网络服务系统;\n    2.1.3、不利用GO+服务从事以下活动:\n    1)未经允许,进入计算机信息网络或者使用计算机信息网络资源的; \n    2)未经允许,对计算机信息网络功能进行删除、修改或者增加的;\n    3)未经允许,对进入计算机信息网络中存储、处理或者传输的数据和应用程序进行删除、修改或者增加的;\n    4)故意制作、传播计算机病毒等破坏性程序的;\n    5)其他危害计算机信息网络安全的行为。\n    2.2、用户违反本协议或相关的服务条款的规定,导致或产生的任何第三方主张的任何索赔、要求或损失,包括合理的律师费,您同意赔偿博风慧能与合作公司、关联公司,并使之免受损害。对此,博风慧能有权视用户的行为性质,采取包括但不限于删除用户发布信息内容、暂停使用许可、终止服务、限制使用、回收GO+帐号、追究法律责任等措施。\n    2.3、用户不得对本服务任何部分或本服务之使用或获得,进行复制、拷贝、出售、转售或用于任何其它商业目的。\n   2.4、用户须对自己在使用GO+服务过程中的行为承担法律责任。用户承担法律责任的形式包括但不限于:对受到侵害者进行赔偿,以及在博风慧能首先承担了因用户行为导致的行政处罚或侵权损害赔偿责任后,用户应给予博风慧能等额的赔偿。\n    三、版权声明\nGO+提供的网络服务中包含的任何文本、图片、图形、音频和/或视频资料均受版权、商标和/或其它财产所有权法律的保护, 未经相关权利人同意, 上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行, 或者被用于其他任何商业目的。所有以上资料或资料的任何部分仅可作为私人和非商业用途保存。GO+不就由上述资料产生或在传送或递交全部或部分上述资料过程中产生的延误、不准确、错误和遗漏或从中产生或由此产生的任何损害赔偿, 以任何形式, 向用户或任何第三方负责。\n    四、隐私保护\n保护用户隐私是博风慧能的一项基本政策, GO+保证不对外公开或向第三方提供用户的注册资料及用户在使用网络服务时存储在本网站内的非公开内容, 但下列情况除外:\n    1、事先获得用户的书面明确授权;\n    2、根据有关的法律法规要求;\n    3、按照相关政府主管部门的要求;\n    4、为维护社会公众的利益;\n    5、为维护本网站的合法权益;\n    五、免责声明\n    5.1、博风慧能不担保网络服务一定能满足用户的要求,也不担保网络服务不会中断,对网络服务的及时性、安全性、准确性也都不作担保。\n    5.2、博风慧能不保证为向用户提供便利而设置的外部链接的准确性和完整性,同时,对于该等外部链接指向的,不由博风慧能实际控制的任何网页上的内容,360不承担任何责任。\n    5.3、对于因电信系统或互联网网络故障、计算机故障或病毒、信息损坏或丢失、计算机系统问题或其它任何不可抗力原因而产生损失,博风慧能不承担任何责任,但将尽力减少因此而给用户造成的损失和影响。\n    六、法律及争议解决\n    6.1、本协议适用中华人民共和国法律。\n    6.2、因本协议引起的或与本协议有关的任何争议,各方应友好协商解决;协商不成的,任何一方均可将有关争议提交至北京仲裁委员会并按照其届时有效的仲裁规则仲裁;仲裁裁决是终局的,对各方均有约束力。\n    七、其他条款\n    7.1、如果本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力,或违反任何适用的法律,则该条款被视为删除,但本协议的其余条款仍应有效并且有约束力。\n    7.2、博风慧能有权随时根据有关法律、法规的变化以及公司经营状况和经营策略的调整等修改本协议,而无需另行单独通知用户。修改后的协议会在博风慧能网站（www.huakesoft.com)上公布。用户可随时通过博风慧能网站浏览最新服务协议条款。当发生有关争议时,以最新的协议文本为准。如果不同意博风慧能对本协议相关条款所做的修改,用户有权停止使用网络服务。如果用户继续使用网络服务,则视为用户接受360对本协议相关条款所做的修改。\n   7.3、博风慧能在法律允许最大范围对本协议拥有解释权与修改权。\n\n";
       NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    textView.textAlignment=NSTextAlignmentJustified;
    textView.font = [UIFont fontWithName:@"MicrosoftYaHei" size:18.0];//设置字体名字和字体大小
    
    textView.showsHorizontalScrollIndicator = NO;
    textView.bounces=NO;
   
    [self.view addSubview:textView];
    //下一步的按钮 
    _nextButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image =[UIImage imageNamed:@"regi_nextButton@2x"];
    _nextButton.frame =CGRectMake(30, [UIUtils getWindowHeight]-48, [UIUtils getWindowWidth]-60, 38);
    [_nextButton setBackgroundImage:image forState:UIControlStateNormal];
    _nextButton.layer.cornerRadius=20;
    
    _nextButton.layer.masksToBounds=YES;
    [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(okback) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTintColor:[UIColor whiteColor]];
    _nextButton.titleLabel.font=[UIFont systemFontOfSize:20];
    [self.view addSubview:_nextButton];
}
//返回确定
-(void)okback{

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
