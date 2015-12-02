//
//  ContactsListViewController.m
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/19/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import "ContactsListViewController.h"
#import "EditContactViewController.h"
#import "SettingsViewController.h"
#import "ContactDatabase.h"
#import "ContactItem.h"

@interface ContactsListViewController () <ContactDatabaseDelegate>

@property (nonatomic, strong) ContactDatabase *dataSource;

@end


@implementation ContactsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [ContactDatabase sharedInstance];
    _dataSource.delegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _sortOrder = [userDefaults integerForKey:kUserSettingsSortOrder];
    _colorScheme = -1;
    self.navigationController.navigationBar.translucent = NO;
    self.colorScheme = [userDefaults integerForKey:kUserSettingsColorScheme];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource itemsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactInfoCell" forIndexPath:indexPath];
    
    ContactItem *item = [self.dataSource itemAtIndex:indexPath.row];
    cell.textLabel.text = self.sortOrder ? [NSString stringWithFormat:@"%@ %@", item.contactLastname, item.contactName] : [NSString stringWithFormat:@"%@ %@", item.contactName, item.contactLastname];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSource removeItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)setSortOrder:(NSInteger)sortOrder
{
    if (_sortOrder != sortOrder) {
        _sortOrder = sortOrder;
        [self.dataSource reorder];
    }
}

- (void)setColorScheme:(NSInteger)colorScheme
{
    if (_colorScheme != colorScheme) {
        _colorScheme = colorScheme;
        [[UIApplication sharedApplication] keyWindow].tintColor = colorScheme ? [UIColor whiteColor] : [UIColor blackColor];
        self.navigationController.navigationBar.barStyle = colorScheme ? UIBarStyleBlack : UIBarStyleDefault;
        [UITableView appearance].backgroundColor = colorScheme ? [UIColor blackColor] : [UIColor whiteColor];
        [UITableViewCell appearance].backgroundColor = colorScheme ? [UIColor blackColor] : [UIColor whiteColor];
        [UILabel appearance].textColor = colorScheme ? [UIColor whiteColor] : [UIColor blackColor];
        [UIView appearanceWhenContainedIn:[UITableViewHeaderFooterView class], [UITableView class], nil].backgroundColor = colorScheme ? [UIColor colorWithWhite:0.15 alpha:1.0] : [UIColor colorWithWhite:0.85 alpha:1.0];
        [UITextField appearance].keyboardAppearance = colorScheme ? UIKeyboardAppearanceDark : UIKeyboardAppearanceLight;
        [UITextField appearance].textColor = colorScheme ? [UIColor whiteColor] : [UIColor blackColor];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowContactSegue"]) {
        EditContactViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.item = [self.dataSource itemAtIndex:indexPath.row];
    }
}

- (IBAction)unwindFromEditing:(UIStoryboardSegue *)segue
{
    
}

- (void)contactDatabase:(ContactDatabase *)database didLoadData:(id)object
{
    [self.tableView reloadData];
}

@end

