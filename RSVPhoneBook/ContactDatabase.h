//
//  ContactDatabase.h
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/21/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactItem;
@class UIImage;

@protocol ContactDatabaseDelegate;

@interface ContactDatabase : NSObject

@property(nonatomic, weak) id<ContactDatabaseDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)saveItem:(ContactItem *)contactItem withPhoto:(UIImage*)photo;
- (void)removeItemAtIndex:(NSUInteger)index;
- (NSUInteger)itemsCount;
- (ContactItem *)itemAtIndex:(NSUInteger)index;
- (UIImage *)imageForItem:(ContactItem *)item;
- (void)reorder;

@end

@protocol ContactDatabaseDelegate <NSObject>

- (void)contactDatabase:(ContactDatabase *)database didLoadData:(id)object;

@end