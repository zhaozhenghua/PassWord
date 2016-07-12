//
//  PAWFSafeKeyboard.h
//  PingAnWiFi
//
//  Copyright © 2016年 Ping An Insurance(Group) Company of China, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSafeKeyboardInput @"kSafeKeyboardInput"
#define kSafeKeyboardDel @"kSafeKeyboardDel"
#define kSafeKeyboardEndEditing @"kSafeKeyboardEndEditing"
#define kSafeKeyboardComfirn @"kSafeKeyboardComfirn"
#define kInputChar @"kInputChar"

typedef NS_ENUM(NSInteger, PAWFSafeKeyboardType) {
    PAWFSafeKeyboardTypeNormal,
    PAWFSafeKeyboardTypeDisorder,
};

@protocol PAWFSafeKeyboardDelegate <NSObject>

@optional
- (void)didSelectKeyboard:(NSString*)string indexPath:(NSIndexPath*)indexPath;

- (void)clickedKeyboardBackBtn;

- (void)clickedKeyboardCleanBtn;

- (void)clickedKeyboardComfirnBtn;

@end

@interface PAWFSafeKeyboard : UIView

@property (nonatomic, weak) id<PAWFSafeKeyboardDelegate> delegate;
@property (nonatomic, assign) BOOL useDotKey;
@property (nonatomic, assign) BOOL useComfirnBtn;

- (instancetype)initWithType:(PAWFSafeKeyboardType)type;

@end
