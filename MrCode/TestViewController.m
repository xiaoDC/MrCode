//
//  TestViewController.m
//  MrCode
//
//  Created by hao on 7/5/15.
//  Copyright (c) 2015 hao. All rights reserved.
//

#import "TestViewController.h"
#import "GITEvent.h"

#import "Masonry.h"
#import "KxMenu.h"
#import "SDWebImageManager.h"

@interface TestViewController ()

@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) UIView *v1;
@property (nonatomic, strong) UIView *v2;
@property (nonatomic, strong) UILabel *l1;

@property (nonatomic, strong) UIButton *button1;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *str = @"2014-06-08T10:16:16Z";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *date = [dateFormatter dateFromString:str];
    NSLog(@"date: %@, class: %@", date, [date class]);
    
    _superView = [UIView new];
    _superView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_superView];
    [_superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 100));
        make.center.equalTo(self.view);
    }];
    
    _v1 = [UIView new];
    _v1.backgroundColor = [UIColor grayColor];
    [_superView addSubview:_v1];
    [_v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 30));
        make.left.equalTo(@10);
        make.top.equalTo(@10);
    }];
    
    _v2 = [UIView new];
    _v2.backgroundColor = [UIColor blueColor];
    [_superView addSubview:_v2];
    [_v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 10));
        make.left.equalTo(_v1.mas_right).offset(5);
        make.top.equalTo(@15);
    }];
    
    _l1 = [UILabel new];
    _l1.lineBreakMode = NSLineBreakByWordWrapping;
    _l1.numberOfLines = 0;
    _l1.text = @"fdafjl fljalsdj lfajls sdlfja lsdjfla flajsd flsdjfa lsdjklka\nladsj flka jldfa djfl";
    _l1.font = [UIFont systemFontOfSize:12.f];
    [_superView addSubview:_l1];
    [_l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_v2);
        make.top.equalTo(_v2.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(@-130);
//        make.bottom.equalTo(@-2);
    }];
    
    // GITEvent
//    [GITEvent eventsOfUser:nil success:^(NSArray *events) {
//        for (GITEvent *event in events) {
//            NSLog(@"event: %@", event.createdAt);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];

    
    _button1 = [UIButton new];
    _button1.backgroundColor = [UIColor greenColor];
    [_button1 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    [_button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(self.view);
        make.top.equalTo(@20);
    }];
    
    [self downloadImage];
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

#pragma mark - Private

- (void)downloadImage
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:@"https://camo.githubusercontent.com/01dd1026d86789cd3479004e93c8320fe125be4d/68747470733a2f2f7261772e6769746875622e636f6d2f6a6f686e696c2f4a46496d6167655069636b6572436f6e74726f6c6c65722f6d61737465722f6173736574732f73637265656e73686f74312e706e67"];
    if ([manager cachedImageExistsForURL:url]) {
        NSString *key = [manager cacheKeyForURL:url];
        NSLog(@"cachedImageExistsForURL=%@", [manager.imageCache defaultCachePathForKey:key]);
    }
    else {
    
        NSLog(@"downloading");
        [manager downloadImageWithURL:url options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSLog(@"downloaded=%@", url);
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
                    imageView.image = image;
                    [self.view addSubview:imageView];
                    
                    //把图片在磁盘中的地址传回给JS
                    NSString *key = [manager cacheKeyForURL:imageURL];
                    
                    NSLog(@"cacheType=%@, key=%@", @(cacheType), key);
                });
            }
        }];
    }
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"ACTION MENU 1234456"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"Share this"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Check this menu"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Reload page"
                     image:[UIImage imageNamed:@"reload"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Search"
                     image:[UIImage imageNamed:@"search_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"Go home"
                     image:[UIImage imageNamed:@"home_icon"]
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];

}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}

@end
