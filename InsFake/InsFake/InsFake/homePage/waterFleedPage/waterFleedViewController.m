//
//  waterFleedViewController.m
//  InsFake
//
//  Created by z on 2020/1/4.
//  Copyright © 2020 lelouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "waterFleedViewController.h"
#import <GXWaterCollectionViewLayout.h>
#import <AVOSCloud/AVOSCloud.h>
#import "collectionCell.h"
#import <MJRefresh.h>
#import <MWPhotoBrowser.h>

@interface waterFleedViewController()<GXWaterCollectionViewLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate>
@property(strong,nonatomic)IBOutlet UICollectionView *table;
@property(nonatomic)int num,feedOrder;
@property(nonatomic,strong)NSMutableDictionary *arr;
@property(nonatomic,strong)NSMutableArray *picsarr;

@property(nonatomic,strong)MWPhoto *pic;

@end

@implementation waterFleedViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.tabBarController.tabBar.hidden=YES;
    
    _num=10;
    _arr=[[NSMutableDictionary alloc]init];
    _picsarr=[[NSMutableArray alloc]init];
    
    GXWaterCollectionViewLayout *water=[[GXWaterCollectionViewLayout alloc]init];
    water.numberOfColumns=2;
    water.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    water.scrollDirection = UICollectionViewScrollDirectionVertical;
    water.headerSize = CGSizeMake(self.view.bounds.size.width, 40);
    water.footerSize = CGSizeMake(self.view.bounds.size.width, 40);
    water.delegate = self;
    UICollectionView*table=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:water];
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    table.delegate=self;
    table.dataSource=self;
    [table registerClass:[collectionCell class] forCellWithReuseIdentifier:@"cell"];
    table.backgroundColor=[UIColor whiteColor];
    table.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.view addSubview:table];
    _table=table;
    
    [self initArr:100];//默认最多100张
    [self loadData:0];
}

-(void)loadMore{
    //[self initArr:_num+10];
    //[self loadData:_num-10];
    _num+=10;
    if(_num>_picsarr.count){
        _num=_picsarr.count;
    }
    NSLog(@"%d   %lu",_num,(unsigned long)_picsarr.count);
    [self.table reloadData];
    [_table.mj_footer endRefreshing];
}

-(void)initArr:(int)nu{
    for(int i=0;i<nu;i++){
        [_arr setObject:[UIImage imageNamed:@"loadPic.png"] forKey:@(i)];
    }
    //_num=nu;
}

-(void)loadData:(int)skipnum{
    AVQuery *query=[AVQuery queryWithClassName:@"feedInfo"];
    //query.skip=skipnum;
    //query.limit=10;
    [query includeKey:@"pics"];
    NSArray *feeds=[query findObjects];
    __block NSInteger number=0;
    NSLog(@"%ld", (long)number);
    for(int i=0;i<feeds.count;i++){
        AVObject *obj=feeds[i];
        NSArray *pics=obj[@"pics"];
        for(int j=0;j<pics.count;j++){
            AVFile *file=pics[j];
            [file downloadWithProgress:^(NSInteger number) {
                //下载中
            } completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
                NSString* urlStr=[filePath absoluteString];
                NSString* cutpath=[urlStr substringWithRange:NSMakeRange(7, urlStr.length-7)];
                //NSLog(@"%@", cutpath);
                UIImage *im=[[UIImage alloc] initWithContentsOfFile:cutpath];

                [self->_arr setObject:im forKey:@(number)];
                [self->_picsarr addObject:im];
                number++;
                [self.table reloadData];
            }];
        }
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return _picsarr.count;
    return _num;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    collectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //cell.backgroundColor=[UIColor blueColor];
    UIImage *img=[_arr objectForKey:@(indexPath.row)];
    //[cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, img.size.width/10, img.size.height/10)];
    [cell setimg:img];
    return cell;
}

- (CGFloat)sizeWithLayout:(GXWaterCollectionViewLayout *)layout indexPath:(NSIndexPath *)indexPath itemSize:(CGFloat)itemSize {
    return itemSize;
}

- (void)moveItemAtSourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionCell *cell = (collectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *img=cell.img;
    _pic=[MWPhoto photoWithImage:img];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [self.navigationController pushViewController:browser animated:YES];
    //NSLog(@"clickcell");
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < 1)
        return _pic;
    return nil;
}

@end
