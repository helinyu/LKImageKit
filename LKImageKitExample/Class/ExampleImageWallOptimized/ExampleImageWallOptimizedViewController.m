//
//  ExampleImageWallOptimizedViewController.m
//  LKImageViewExample
//
//  Created by lingtonke on 2018/1/9.
//  Copyright © 2018年 lingtonke. All rights reserved.
//

#import "ExampleImageWallOptimizedViewController.h"
#import "ExampleFastFileCache.h"
#import "ExampleImageURLRequest.h"
#import "ExampleNetworkFileLoader.h"
#import "ExampleUtil.h"
#import <YYWebImage.h>
#import <UIImageView+WebCache.h>
#import <UIImage+YYWebImage.h>
#import "YDBaseCollectionViewCell.h"

@implementation ExampleImageWallOptimizedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView.imageManager = [LKImageManager imageWallManager];
    }
    return self;
}

@end

@interface ExampleImageWallOptimizedViewController ()

//@property (nonatomic, strong) NSMapTable *mapTable;
//@property (nonatomic, strong) NSMutableArray<ExampleImageURLRequest*> *preloadRequests;

@end

@interface ExampleImageWallOptimizedViewController ()

@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ExampleImageWallOptimizedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[ExampleImageWallOptimizedCell class] forCellWithReuseIdentifier:@"ExampleImageWallCell"];
    [self.collectionView registerClass:[YDBaseCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YDBaseCollectionViewCell class])];
//    self.mapTable = [[NSMapTable alloc] init];
//    self.preloadRequests = [NSMutableArray array];
    _cellIndex =2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    for (int i = 0; i < ImageCount; i++)
//    {
//        ExampleImageURLRequest *request = [ExampleImageURLRequest requestWithURL:[ExampleUtil imageURLFromFileID:i + 1 size:64]];
//        request.dataCacheEnabled        = YES;
//        request.priority                = NSOperationQueuePriorityVeryLow;
//        [[LKImageManager imageWallManager].loaderManager preloadWithRequest:request];
//        [self.preloadRequests addObject:request];
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    for (ExampleImageURLRequest *request in self.preloadRequests)
//    {
//        [[LKImageManager imageWallManager].loaderManager cancelRequest:request];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer");
        CGFloat offSetY = self.collectionView.contentOffset.y;
        CGFloat boundsHeight = self.collectionView.bounds.size.height;
        CGFloat contentSizeHeight = self.collectionView.contentSize.height;
        CGFloat boundsWidth = self.collectionView.bounds.size.width;
        if((offSetY + boundsHeight) > contentSizeHeight) {
            offSetY -= boundsHeight;
        }
        else {
            offSetY += boundsHeight;
        }
        [self.collectionView scrollRectToVisible:CGRectMake(0.f, offSetY, boundsWidth, boundsHeight) animated:YES];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellIndex == 0) {
        ExampleImageWallCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExampleImageWallCell" forIndexPath:indexPath];
        ExampleImageURLRequest *loadingRequest  = [ExampleImageURLRequest requestWithURL:[ExampleUtil imageURLFromFileID:indexPath.item + 1 size:64]];
        loadingRequest.priority                 = NSOperationQueuePriorityVeryHigh;
        loadingRequest.dataCacheEnabled         = YES;
        imageCell.imageView.loadingImageRequest = loadingRequest;
        imageCell.imageView.URL                 = [ExampleUtil imageURLFromFileID:indexPath.item + 1 size:256];
        return imageCell;
    }
    else if (_cellIndex == 1) {
        YDBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YDBaseCollectionViewCell class]) forIndexPath:indexPath];
        NSString *urlString =[ExampleUtil imageURLFromFileID:indexPath.item + 1 size:256];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        return cell;
    }
    else {
        YDBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YDBaseCollectionViewCell class]) forIndexPath:indexPath];
        [cell.imageView yy_setImageWithURL:[NSURL URLWithString:[ExampleUtil imageURLFromFileID:indexPath.item + 1 size:256]] placeholder:nil];
        return cell;
    }
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

//- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
//{
//    for (NSIndexPath *indexPath in indexPaths)
//    {
//        NSString *URL           = [ExampleUtil imageURLFromFileID:indexPath.item + 1 size:64];
//        LKImageRequest *request = [LKImageURLRequest requestWithURL:URL];
//        request.priority = NSOperationQueuePriorityHigh;
//        [self.mapTable setObject:request forKey:indexPath];
//        [[LKImageManager imageWallManager].loaderManager preloadWithRequest:request];
//    }
//}
//
//- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
//{
//    for (NSIndexPath *indexPath in indexPaths)
//    {
//        LKImageRequest *request = [self.mapTable objectForKey:indexPath];
//        if (request)
//        {
//            [[LKImageManager imageWallManager].loaderManager cancelRequest:request];
//        }
//    }
//}

@end

@implementation LKImageManager (Example)

+ (instancetype)imageWallManager
{
    static LKImageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LKImageConfiguration *config = [LKImageConfiguration defaultConfiguration];
        config.cacheList             = [config.cacheList arrayByAddingObject:[ExampleFastFileCache instance]];
        config.loaderList            = [@[[[ExampleNetworkFileLoader alloc] init]] arrayByAddingObjectsFromArray:config.loaderList];
        instance                     = [[LKImageManager alloc] initWithConfiguration:config];
    });
    return instance;
}

@end
