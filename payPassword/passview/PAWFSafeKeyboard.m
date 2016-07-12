//
//  PAWFSafeKeyboard.m
//  PingAnWiFi
//  Copyright © 2016年 Ping An Insurance(Group) Company of China, Ltd. All rights reserved.
//

#import "PAWFSafeKeyboard.h"
#import "UIView+Ext.h"

#define kCellID @"kCellID"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface PAWFSafeKeyboardCell : UICollectionViewCell
{
    UILabel *_label;
    UIImageView *_imageView;
}

- (void)setKeyUnUserable;

@end

@implementation PAWFSafeKeyboardCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:17.0f];
        _label.textColor =[UIColor blackColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _imageView = [[UIImageView alloc] initWithFrame:_label.frame];
        _imageView.contentMode = UIViewContentModeCenter;
        
        [self addSubview:_imageView];
        [self addSubview:_label];
    }
    return self;
}

- (void)setCellContent:(NSIndexPath*)indexpath array:(NSArray*)array{
    if (indexpath.row == 11) {
        _imageView.image = [UIImage imageNamed:@"Wallet_keyboardBack"];
    }else{
        _label.text = array[indexpath.row];
    }
}

- (void)setKeyUnUserable {
    self.userInteractionEnabled = NO;
    _label.backgroundColor =[UIColor greenColor];
}

@end


@interface PAWFSafeKeyboard()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSArray *_dataArray;
    UIButton *_delBtn;
    UIButton *_comfirnBtn;
}
@end

@implementation PAWFSafeKeyboard

#pragma mark - override
- (void)setUseComfirnBtn:(BOOL)useComfirnBtn {
    _useComfirnBtn = useComfirnBtn;
    if (useComfirnBtn) {
        _comfirnBtn.backgroundColor = [UIColor yellowColor];
        [_comfirnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comfirnBtn.userInteractionEnabled = YES;
    }else{
        _comfirnBtn.backgroundColor = [UIColor brownColor];
        [_comfirnBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _comfirnBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - INIT
- (instancetype)initWithType:(PAWFSafeKeyboardType)type {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth,200)];
    if (self) {
        self.userInteractionEnabled = YES;
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;
        flow.itemSize = CGSizeMake(kScreenWidth / 4, self.height / 4);
        flow.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 4 * 3, self.height) collectionViewLayout:flow];
        [self createDataWithType:type];
        [_collectionView registerClass:[PAWFSafeKeyboardCell class] forCellWithReuseIdentifier:kCellID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(_collectionView.rightX, 0, kScreenWidth - _collectionView.rightX, self.height)];
        controlView.backgroundColor = [UIColor clearColor];
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectMake(0, 0, controlView.width, controlView.height / 2);
        _delBtn.layer.borderWidth = 0.5;
        _delBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _delBtn.backgroundColor = [UIColor whiteColor];
        _delBtn.imageView.center = _delBtn.center;
        [_delBtn setImage:[UIImage imageNamed:@"Wallet_keyboardClean"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _comfirnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _comfirnBtn.frame = CGRectMake(0, controlView.frame.size.height / 2, controlView.width, controlView.frame.size.height / 2);
        [_comfirnBtn setTitle:@"确定" forState:UIControlStateNormal];
        _comfirnBtn.backgroundColor = [UIColor yellowColor];
        [_comfirnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _comfirnBtn.layer.borderWidth = 0.5;
        _comfirnBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_comfirnBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [controlView addSubview:_delBtn];
        [controlView addSubview:_comfirnBtn];
        
        [self addSubview:_collectionView];
        [self addSubview:controlView];
    }
    return self;
}

- (void)createDataWithType:(PAWFSafeKeyboardType)type {
    NSMutableArray *resultArr = [NSMutableArray array];
    if (type == PAWFSafeKeyboardTypeNormal) {
        resultArr = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"]];
    }else{
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"]];
        while (mutArr.count > 0) {
            if (mutArr.count == 1) {
                [resultArr addObject:mutArr.lastObject];
                [mutArr removeLastObject];
            }else{
                NSInteger count = rand()%(mutArr.count - 1);
                NSString *str = [mutArr objectAtIndex:count];
                [mutArr removeObjectAtIndex:count];
                [resultArr addObject:str];
            }
        }
    }
    [resultArr insertObject:@"." atIndex:resultArr.count - 1];
    _dataArray = [resultArr copy];
}

#pragma mark - event
- (void)clickBtn:(UIButton*)sender {
    if (sender == _delBtn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSafeKeyboardDel object:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(clickedKeyboardCleanBtn)]) {
            [_delegate clickedKeyboardCleanBtn];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSafeKeyboardComfirn object:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(clickedKeyboardComfirnBtn)]) {
            [_delegate clickedKeyboardComfirnBtn];
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PAWFSafeKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    [cell setCellContent:indexPath array:_dataArray];
    if (!_useDotKey) {
        if (indexPath.row == 9) {
            [cell setKeyUnUserable];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 11) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSafeKeyboardEndEditing object:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(clickedKeyboardBackBtn)]) {
            [_delegate clickedKeyboardBackBtn];
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kSafeKeyboardInput object:nil userInfo:@{kInputChar:_dataArray[indexPath.row]}];
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectKeyboard:indexPath:)]) {
            [_delegate didSelectKeyboard:_dataArray[indexPath.row] indexPath:indexPath];
        }
    }
}

@end
