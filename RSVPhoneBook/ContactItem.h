//
//  ContactItem.h
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/21/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactItem : NSObject

@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactLastname;
@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *contactEmail;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, copy) NSString *itemFileName;

- (instancetype)initWithName:(NSString *)name lastname:(NSString *)lastname phone:(NSString *)phone email:(NSString *)email itemFileName:(NSString *)itemFileName;

@end
