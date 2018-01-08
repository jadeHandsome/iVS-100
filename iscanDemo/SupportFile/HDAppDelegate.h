//
//  hdAppDelegate.h
//  TestDemo
//
//  Created by xsz on 21/8/14.
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //判断是否iPad
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS7_STATUS_HEIGTH      20
#define IOS7_BG_COLOR   [UIColor colorWithRed:221/255.0 green:221/255.0 blue:220/255.0 alpha:1]

#define WHITE_BAR_HEIGHT    20
#define TOP_BAR_HEIGHT      44//45

#define MAX_CHANNEL_CNT     16


typedef enum HDFilmMode: NSUInteger
{
    E_FilmMode_Original     = 0,
    E_FilmMode_Full         = 1,
    E_FilmMode_16_9         = 2,
    E_FilmMode_4_3          = 3
}E_FilmMode;

@class HDPreviewView;

@interface HDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HDPreviewView *previewView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(NSString*) getBaseURL;

@end
