//
//  ContactDatabase.m
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/21/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDatabase.h"
#import "ContactItem.h"
#import "SettingsViewController.h"

@interface  ContactDatabase()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *dataPath;

@end


@implementation ContactDatabase

- (instancetype)init
{
    if (self = [super init]) {
        _loaded = NO;
        _fileManager = [NSFileManager defaultManager];
        _dataSource = [NSMutableArray new];
        if ([self prepareDataPath]) {
            [self loadData];
        }
    }
    return self;
}

- (BOOL)prepareDataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.dataPath = [paths[0] stringByAppendingPathComponent:@"Contacts"];
    if (![self.fileManager fileExistsAtPath:self.dataPath]) {
        NSError *error;
        if (![self.fileManager createDirectoryAtPath:self.dataPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            return NO;
        }
    }
    return YES;
}

- (void)loadData
{
    NSError *error;
    NSArray *directoryContents = [self.fileManager contentsOfDirectoryAtPath:self.dataPath error:&error];
    for (NSString *fileName in directoryContents) {
        if ([[fileName pathExtension] isEqualToString:@"plist"]) {
            NSString *fileFullPath = [self.dataPath stringByAppendingPathComponent:fileName];
            ContactItem *contactItem = [ContactItem new];
            contactItem.data = [[NSMutableDictionary alloc] initWithContentsOfFile:fileFullPath];
            contactItem.itemFileName = fileName;
            [self.dataSource addObject:contactItem];
        }
    }
    self.loaded = YES;
    [self reorder];
}

- (void)saveItem:(ContactItem *)contactItem withPhoto:(UIImage *)photo
{
    if ([self.dataSource indexOfObject:contactItem] == NSNotFound) {
        [self.dataSource addObject:contactItem];
        [self reorder];
    }
    NSString *filePath = [self.dataPath stringByAppendingPathComponent:contactItem.itemFileName];
    [contactItem.data writeToFile:filePath atomically:YES];
    if (photo) {
        NSData *imageData = UIImagePNGRepresentation(photo);
        NSString *imagePath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
        [imageData writeToFile:imagePath atomically:YES];
    }
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    NSError *error;
    ContactItem *item = self.dataSource[index];
    NSString *filePath = [self.dataPath stringByAppendingPathComponent:item.itemFileName];
    [self.fileManager removeItemAtPath:filePath error:&error];
    NSString *imagePath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
    [self.fileManager removeItemAtPath:imagePath error:&error];
    [self.dataSource removeObjectAtIndex:index];
}

- (NSUInteger)itemsCount
{
    if (self.isLoaded) {
        return [self.dataSource count];
    } else {
        return 0;
    }
}

- (ContactItem *)itemAtIndex:(NSUInteger)index
{
    return self.dataSource[index];
}

- (UIImage *)imageForItem:(ContactItem *)item
{
    NSString *imageFileName = [[item.itemFileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"];
    NSString *imagePath = [self.dataPath stringByAppendingPathComponent:imageFileName];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void)reorder
{
    NSString *key1;
    NSString *key2;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kUserSettingsSortOrder]) {
        key1 = @"lastname"; key2 = @"name";
    } else {
        key1 = @"name"; key2 = @"lastname";
    }
    self.dataSource = [[self.dataSource sortedArrayUsingComparator:^NSComparisonResult(ContactItem *obj1, ContactItem *obj2) {
        if ([obj1.data[key1] isEqualToString:obj2.data[key1]]) {
            return [obj1.data[key2] compare:obj2.data[key2] options:NSRegularExpressionSearch];
        } else {
            return [obj1.data[key1] compare:obj2.data[key1] options:NSRegularExpressionSearch];
        }
    }] mutableCopy];
    [self.delegate contactDatabase:self didLoadData:nil];
}

+ (instancetype)sharedInstance
{
    static ContactDatabase *sharedInstance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

@end
