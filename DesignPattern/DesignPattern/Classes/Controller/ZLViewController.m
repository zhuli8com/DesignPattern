//
//  ZLViewController.m
//  DesignPattern
//
//  Created by account on 15/9/10.
//  Copyright (c) 2015年 zhuli8. All rights reserved.
//

#import "ZLViewController.h"
#import "ZLLibraryAPI.h"
#import "ZLAlbum+ZLTableRepresentation.h"
#import "ZLHorizontalScroller.h"
#import "ZLAlbumView.h"

@interface ZLViewController () <UITableViewDataSource,UITableViewDelegate,ZLHorizontalScrollerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *allAlbums;
@property (nonatomic,strong) NSDictionary *currentAlbum;
@property (nonatomic,assign) NSInteger currentAlbumIndex;
@property (nonatomic,strong) ZLHorizontalScroller *scroller;
@end

@implementation ZLViewController

#pragma mark - life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
    [self.view addSubview:self.tableView];
    
    [self loadPreviousState];
    
    [self.view addSubview:self.scroller];
    [self reloadScroller];
    
    [self showDataForAlbumAtIndex:self.currentAlbumIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.currentAlbum[@"titles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    cell.textLabel.text=self.currentAlbum[@"titles"][indexPath.row];
    cell.detailTextLabel.text=self.currentAlbum[@"values"][indexPath.row];
    
    return cell;
}

#pragma mark - ZLHorizontalScrollerDelegate
//设置保存当前专辑数据的变量，然后调用showDataForAlbumAtIndex:方法显示专辑数据。
- (void)horizontalScroller:(ZLHorizontalScroller *)scroller clickedViewAtIndex:(NSInteger)index{
    self.currentAlbumIndex=index;
    [self showDataForAlbumAtIndex:index];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(ZLHorizontalScroller *)scroller{
    return self.allAlbums.count;
}

- (UIView *)horizontalScroller:(ZLHorizontalScroller *)scroller viewAtIndex:(NSInteger)index{
    ZLAlbum *album=self.allAlbums[index];
    ZLAlbumView *view=[[ZLAlbumView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
    return view;
}

- (NSInteger)initialViewIndexForHorizontalScroller:(ZLHorizontalScroller *)scroller{
    return self.currentAlbumIndex;
}

#pragma mark - private methods
- (void)showDataForAlbumAtIndex:(NSInteger)albumIndex{
    if (albumIndex<self.allAlbums.count) {
        ZLAlbum *album=self.allAlbums[albumIndex];
        self.currentAlbum=[album tr_tableRepresentation];
    }else{
        self.currentAlbum=nil;
    }
    [self.tableView reloadData];
}

- (void)reloadScroller{
    if (self.currentAlbumIndex<0) {
        self.currentAlbumIndex=0;
    }else if (self.currentAlbumIndex>=self.allAlbums.count){
        self.currentAlbumIndex=self.allAlbums.count-1;
    }
    [self.scroller reload];
    [self showDataForAlbumAtIndex:self.currentAlbumIndex];
}

- (void)saveCurrentState{
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentAlbumIndex forKey:@"currentAlbumIndex"];
}

- (void)loadPreviousState{
    self.currentAlbumIndex=[[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForAlbumAtIndex:self.currentAlbumIndex];
}

#pragma mark - getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundView=nil;
    }
    return _tableView;
}

- (NSArray *)allAlbums{
    if (!_allAlbums) {
        _allAlbums=[[ZLLibraryAPI sharedInstance] getAlbums];
    }
    return _allAlbums;
}

- (ZLHorizontalScroller *)scroller{
    if (!_scroller) {
        _scroller=[[ZLHorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
        _scroller.delegate=self;
        _scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1];
    }
    return _scroller;
}
@end
