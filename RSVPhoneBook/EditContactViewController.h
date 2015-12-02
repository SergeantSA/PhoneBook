//
//  EditContactViewController.h
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/19/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactItem;

@interface EditContactViewController : UITableViewController

@property (nonatomic, strong) ContactItem *item;

@end
