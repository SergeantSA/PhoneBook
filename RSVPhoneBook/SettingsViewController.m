//
//  SettingsViewController.m
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/19/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import "SettingsViewController.h"
#import "ContactsListViewController.h"
#import "ContactDatabase.h"

NSString *const kUserSettingsSortOrder = @"sortOrder";
NSString *const kUserSettingsColorScheme = @"colorScheme";

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSchemeSegment;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    self.sortOrderSegment.selectedSegmentIndex = [_userDefaults integerForKey:kUserSettingsSortOrder];
    self.colorSchemeSegment.selectedSegmentIndex = [_userDefaults integerForKey:kUserSettingsColorScheme];
    [self setColorScheme:self.colorSchemeSegment.selectedSegmentIndex];
}

- (IBAction)sortOrderChanged {
    [self.userDefaults setInteger:self.sortOrderSegment.selectedSegmentIndex forKey:kUserSettingsSortOrder];
}

- (IBAction)colorShemeChanged {
    NSInteger colorScheme = self.colorSchemeSegment.selectedSegmentIndex;
    [self.userDefaults setInteger:colorScheme forKey:kUserSettingsColorScheme];
    [UIView animateWithDuration:0.25 animations:^{
        [self setColorScheme:colorScheme];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.userDefaults synchronize];
    UIViewController *topController = [self navigationController].topViewController;
    if ([topController isKindOfClass:[ContactsListViewController class]]) {
        ContactsListViewController *controller = (ContactsListViewController *)topController;
        controller.sortOrder = self.sortOrderSegment.selectedSegmentIndex;
        controller.colorScheme = self.colorSchemeSegment.selectedSegmentIndex;
    }
}

- (void)setColorScheme:(NSInteger)colorScheme
{
    [[UIApplication sharedApplication] keyWindow].tintColor = colorScheme ? [UIColor whiteColor] : [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = colorScheme ? UIBarStyleBlack : UIBarStyleDefault;
    self.view.backgroundColor = colorScheme ? [UIColor blackColor] : [UIColor whiteColor];
}

@end
