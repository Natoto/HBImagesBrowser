//
//  ImagesVideoPreViewController.m
//  PENG
//
//  Created by zeno on 15/10/28.
//  Copyright © 2015年 nonato. All rights reserved.
//

#import "ImagesVideoPreViewController.h"
#import <objc/runtime.h>
//#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YYPhotoGroupView.h"
//#import "NSObject+PengResource.h"
//#import "RootViewController.h"

@implementation  UIViewController(ImagesVideoPreView)
char key_photos;

-(void)setmwPhotos:(NSMutableArray *)mwphotos
{
    objc_setAssociatedObject(self, &key_photos, mwphotos, OBJC_ASSOCIATION_RETAIN);
}

-(NSMutableArray *)getmwphotos
{
    NSMutableArray * array = objc_getAssociatedObject(self, &key_photos);
    return array;
}

-(void)showPhotoBrowserWithURLS:(NSArray<NSURL *> *)imagevideourls CurrentPhotoIndex:(NSInteger)currentPhotoIndex
{
//    NSMutableArray  * _photos = [NSMutableArray new];
//    [imagevideourls enumerateObjectsUsingBlock:^(NSURL * url, NSUInteger idx, BOOL *stop) {
//        [_photos addObject:[MWPhoto photoWithURL:url]];
//    }];
//    [self setmwPhotos:_photos];
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = YES;
//    browser.displayNavArrows = YES;
//    browser.displaySelectionButtons = NO;
//    browser.alwaysShowControls = NO;
//    browser.zoomPhotosToFill = YES;
//    browser.enableGrid = YES;
//    browser.startOnGrid = NO;
//    browser.enableSwipeToDismiss = YES;
//    browser.autoPlayOnAppear = YES;
//    [browser setCurrentPhotoIndex:currentPhotoIndex];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:nc animated:YES completion:nil];

    [self showPhotoBrowserWithURLS:imagevideourls CurrentPhotoIndex:0 fromView:self.view];

}
-(void)showPhotoBrowserWithURLS:(NSArray<NSURL *> *)imagevideourls CurrentPhotoIndex:(NSInteger)currentPhotoIndex fromView:(UIView *)fromView
{
    NSMutableArray *items = [NSMutableArray new];
    for (NSUInteger i = 0, max = imagevideourls.count; i < max; i++) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = nil;
        item.largeImageURL = imagevideourls[i];//meta.url;
        NSURL * url = imagevideourls[i];
        CGSize imgsize = CGSizeZero; //[self sizeOfResDataimageurl:url.absoluteString];
        if (imgsize.width <=1) {
            imgsize = CGSizeMake(2000, 2000);
        }
        item.largeImageSize = imgsize;
        [items addObject:item];
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:[UIApplication sharedApplication].keyWindow fromPage:(int)currentPhotoIndex animated:YES completion:^{
        
    }]; 
}

-(void)showPhotoBrowserWithURLS:(NSArray<NSURL *> *)imagevideourls
{
    [self showPhotoBrowserWithURLS:imagevideourls  CurrentPhotoIndex:0];
}
// 
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
//{
//    NSMutableArray * array = [self getmwphotos];
//    return array.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
//{
//    NSMutableArray * array = [self getmwphotos];
//    if (index < array.count)
//    {
//        MWPhoto * photo = array[index];
//        return photo;
//    }
//    return nil;
//}

char key_currentVideoPlayerViewController;

-(void)setcurrentVideoPlayerViewController:(MPMoviePlayerViewController *)_currentVideoPlayerViewController
{
    objc_setAssociatedObject(self, &key_currentVideoPlayerViewController, _currentVideoPlayerViewController, OBJC_ASSOCIATION_RETAIN);
}

-(MPMoviePlayerViewController *)getcurrentVideoPlayerViewController
{
    MPMoviePlayerViewController * ctr = objc_getAssociatedObject(self, &key_currentVideoPlayerViewController);
    return ctr;
}

- (void)showVideoBrowserWithURL:(NSURL *)videoURL{
    
    // Setup player
    MPMoviePlayerViewController *_currentVideoPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [_currentVideoPlayerViewController.moviePlayer prepareToPlay];
    _currentVideoPlayerViewController.moviePlayer.shouldAutoplay = YES;
    _currentVideoPlayerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    _currentVideoPlayerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    // Observe ourselves so we can get it to use the crossfade transition
    [[NSNotificationCenter defaultCenter] removeObserver:_currentVideoPlayerViewController
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:_currentVideoPlayerViewController.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_currentVideoPlayerViewController.moviePlayer];
    [self setcurrentVideoPlayerViewController:_currentVideoPlayerViewController];
    // Show
    [self presentViewController:_currentVideoPlayerViewController animated:YES completion:nil];
    
}

- (void)videoFinishedCallback:(NSNotification*)notification {
    
    MPMoviePlayerViewController * _currentVideoPlayerViewController = [self getcurrentVideoPlayerViewController];
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:_currentVideoPlayerViewController.moviePlayer];
    
    // Clear up
    _currentVideoPlayerViewController = nil;
    
    // Dismiss
    BOOL error = [[[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue] == MPMovieFinishReasonPlaybackError;
    if (error) {
        // Error occured so dismiss with a delay incase error was immediate and we need to wait to dismiss the VC
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
