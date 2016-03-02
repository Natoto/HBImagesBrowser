//
//  ViewController.m
//  HBImagesBrowser
//
//  Created by zeno on 16/3/2.
//  Copyright © 2016年 peng. All rights reserved.
//

#import "ViewController.h"
#import "ImagesVideoPreViewController.h"
#import "UIImageView+YYWebImage.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;
@property (strong,nonatomic) NSArray * imageurls;
@end

@implementation ViewController

-(NSArray*)array
{
    return
    @[@"http://img.pm.pengpeng.com/ResData/peng/bg1456453559578_1000x666.jpg",
      @"http://img.pm.pengpeng.com/ResData/peng/bg1456453559899_1000x666.jpg",
      @"http://img.pm.pengpeng.com/ResData/peng/bg1456453560180_1000x666.jpg",
      @"http://img.pm.pengpeng.com/ResData/peng/bg1456453560180_1000x666.jpg",
      @"http://img.pm.pengpeng.com/ResData/peng/bg1456453560801_1000x666.jpg",
      @"http://img.pm.pengpeng.com/ResData/peng/bg1456453561396_1000x666.jpg"];
}

-(NSArray *)imageurls
{
    if (!_imageurls) {
        NSMutableArray * urls    = [NSMutableArray new];
        [self.array enumerateObjectsUsingBlock:^(NSString * imageurl, NSUInteger idx, BOOL *stop) {
            [urls addObject:[NSURL URLWithString:imageurl]];
        }];
        _imageurls = urls;
    }
    return _imageurls;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addimagegesture:self.img1 urlIndex:0];
    [self addimagegesture:self.img2 urlIndex:1];
    [self addimagegesture:self.img3 urlIndex:2];
    [self addimagegesture:self.img4 urlIndex:3];
    [self addimagegesture:self.img5 urlIndex:4];
    [self addimagegesture:self.img6 urlIndex:5];
    
}

-(void)addimagegesture:(UIImageView *)imageview urlIndex:(NSInteger)urlIndex
{
    imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [imageview addGestureRecognizer:tap];
    
    NSURL * url = [self.imageurls objectAtIndex:urlIndex];
    [imageview yy_setImageWithURL:url options:0];
    
    imageview.tag = urlIndex;
}

-(IBAction)imageTap:(id)sender
{
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
    [self showPhotoBrowserWithURLS:self.imageurls CurrentPhotoIndex:tap.view.tag fromView:tap.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
