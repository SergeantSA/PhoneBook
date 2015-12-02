//
//  ContactItem.m
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/21/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import "ContactItem.h"

@implementation ContactItem

- (instancetype)initWithName:(NSString *)name lastname:(NSString *)lastname phone:(NSString *)phone email:(NSString *)email itemFileName:(NSString *)itemFileName
{
    if (self = [super init]) {
        _itemFileName = [itemFileName copy];
        _data = [@{@"name" : name,
                   @"lastname" : lastname,
                   @"phone" : (phone ? phone : @""),
                   @"email": (email ? email : @"")
                   } mutableCopy];
    }
    return self;
}

- (NSMutableDictionary *)data
{
    if (_data == nil) {
        _data = [NSMutableDictionary new];
    }
    return _data;
}

- (NSString *)contactName
{
    return self.data[@"name"];
}

- (void)setContactName:(NSString *)contactName
{
    self.data[@"name"] = (contactName ? contactName : @"Name");
}

- (NSString *)contactLastname
{
    return self.data[@"lastname"];
}

- (void)setContactLastname:(NSString *)contactLastname
{
    self.data[@"lastname"] = (contactLastname ? contactLastname : @"Lastname");
}

- (NSString *)contactPhone
{
    return self.data[@"phone"];
}

- (void)setContactPhone:(NSString *)contactPhone
{
    self.data[@"phone"] = (contactPhone ? contactPhone : @"");
}

- (NSString *)contactEmail
{
    return self.data[@"email"];
}

- (void)setContactEmail:(NSString *)contactEmail
{
    self.data[@"email"] = (contactEmail ? contactEmail : @"");
}

@end
