//
//  EditContactViewController.m
//  RSVPhoneBook
//
//  Created by SergeantSA on 10/19/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

#import "EditContactViewController.h"
#import "ContactDatabase.h"
#import "ContactItem.h"

@interface EditContactViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *addPictureButton;
@property (weak, nonatomic) UIBarButtonItem *rightButton;
@property (nonatomic, assign) BOOL needSavePhoto;
@property (nonatomic, assign, getter=isEditingEnabled) BOOL editingEnabled;

@end


@implementation EditContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Contact Info";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.rightButton = self.navigationItem.rightBarButtonItem;
    self.rightButton.action = @selector(enableEditing);
    if (self.item != nil) {
        self.nameTextField.text = self.item.contactName;
        self.lastnameTextField.text = self.item.contactLastname;
        self.phoneTextField.text = self.item.contactPhone;
        self.emailTextField.text = self.item.contactEmail;
        self.photoImageView.image = [[ContactDatabase sharedInstance] imageForItem:self.item];
        if (self.photoImageView.image) {
            self.backgroundLabel.text = @"";
        }
        self.editingEnabled = NO;
    } else {
        self.editingEnabled = YES;
        self.rightButton.enabled = NO;
    }
}

- (IBAction)selectPhoto {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)setEditingEnabled:(BOOL)editingEnabled
{
    _editingEnabled = editingEnabled;
    if (editingEnabled) {
        self.navigationItem.title = self.item ? @"Edit Contact" : @"Add Contact";
        self.rightButton.title = @"Save";
        self.rightButton.action = @selector(saveItem);
        if (!self.photoImageView.image) {
            self.backgroundLabel.text = @"Add Picture";
        }
        self.addPictureButton.enabled = YES;
        [self.nameTextField becomeFirstResponder];
    }
}

- (void)enableEditing {
    self.editingEnabled = YES;
}

- (void)saveItem {
    BOOL needReorderDatabase = NO;
    if (self.item) {
        if (![self.item.contactName isEqualToString:self.nameTextField.text] ||
            ![self.item.contactLastname isEqualToString:self.lastnameTextField.text]) {
            needReorderDatabase = YES;
        }
        self.item.contactName = self.nameTextField.text;
        self.item.contactLastname = self.lastnameTextField.text;
        self.item.contactPhone = self.phoneTextField.text;
        self.item.contactEmail = self.emailTextField.text;
    } else {
        ContactItem *item = [[ContactItem alloc] initWithName:self.nameTextField.text lastname:self.lastnameTextField.text phone:self.phoneTextField.text email:self.emailTextField.text itemFileName:[NSString stringWithFormat:@"%lu.plist", [NSDate date].hash]];
        self.item = item;
    }
    [[ContactDatabase sharedInstance] saveItem:self.item
                                     withPhoto:self.needSavePhoto ? self.photoImageView.image : nil];
    if (needReorderDatabase) {
        [[ContactDatabase sharedInstance] reorder];
    }
    [self performSegueWithIdentifier:@"SaveContactSegue" sender:self];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    CGFloat width = self.photoImageView.bounds.size.height * originalImage.size.width / originalImage.size.height;
    UIImage *contactPhoto = [self scaleImage:originalImage toSize:CGSizeMake(width, self.photoImageView.bounds.size.height)];
    self.photoImageView.image = contactPhoto;
    self.backgroundLabel.text = @"";
    self.needSavePhoto = YES;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [self.tableView viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return self.isEditingEnabled;
}

- (IBAction)editingChanged
{
    if (self.nameTextField.text.length != 0 && self.lastnameTextField.text.length != 0) {
        self.rightButton.enabled = YES;
    } else {
        self.rightButton.enabled = NO;
    }
}

@end
