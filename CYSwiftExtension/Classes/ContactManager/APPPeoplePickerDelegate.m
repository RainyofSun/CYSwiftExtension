//
//  APPPeoplePickerDelegate.m
//  APPContactManager
//
//  Created by LeeJay on 2017/3/22.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "APPPeoplePickerDelegate.h"

@implementation APPPeoplePickerDelegate

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        [self _addToExistingContactsWithPhoneNum:self.phoneNum person:person controller:self.controller];
    }];
}

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact;
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self _addToExistingContactsWithPhoneNum:self.phoneNum contact:contact controller:self.controller];
    }];
}

#pragma mark - ABNewPersonViewControllerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person
{
    if (self.completcion)
    {
        self.completcion(YES);
    }
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    if (self.completcion)
    {
        self.completcion(NO);
    }
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact
{
    if (self.completcion)
    {
        self.completcion(YES);
    }
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    if (self.completcion)
    {
        self.completcion(NO);
    }
}

#pragma mark - Private

/**
 将号码添加某人的通讯录 (iOS 9 以下)

 @param phoneNum 号码
 @param person 联系人
 @param controller 控制器
 */
- (void)_addToExistingContactsWithPhoneNum:(NSString *)phoneNum
                                    person:(ABRecordRef)person
                                controller:(UIViewController *)controller
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSMutableArray *labels = [NSMutableArray array];
    NSMutableArray *phones = [NSMutableArray array];
    
    for (CFIndex i = 0; i < ABMultiValueGetCount(phoneMulti); i++)
    {
        NSString *phone = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneMulti, i));
        [phones addObject:phone];
        [labels addObject:label];
    }
    CFRelease(phoneMulti);
    
    ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    CFErrorRef error = NULL;
    
    for (int i = 0; i < phones.count; i++)
    {
        ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phones[i]), (__bridge CFStringRef)(labels[i]), NULL);
    }

    ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phoneNum), kABPersonPhoneMobileLabel, NULL);
    
    ABRecordSetValue(person, kABPersonPhoneProperty, multiValue, &error);
    
    CFRelease(multiValue);
    
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.displayedPerson = person;
    picker.newPersonViewDelegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [controller presentViewController:nav animated:YES completion:nil];
}

/**
 将号码添加某人的通讯录 (iOS 9 以上)

 @param phoneNum 号码
 @param contact 联系人
 @param controller 控制器
 */
- (void)_addToExistingContactsWithPhoneNum:(NSString *)phoneNum
                                   contact:(CNContact *)contact
                                controller:(UIViewController *)controller
{
    CNMutableContact *mutableContact = [contact mutableCopy];
    
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                                  value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum]];
    
    if (mutableContact.phoneNumbers.count > 0)
    {
        NSMutableArray *phoneNumbers = [mutableContact.phoneNumbers mutableCopy];
        [phoneNumbers addObject:phoneNumber];
        mutableContact.phoneNumbers = phoneNumbers;
    }
    else
    {
        mutableContact.phoneNumbers = @[phoneNumber];
    }

    CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:mutableContact];
    contactController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
    [controller presentViewController:nav animated:YES completion:nil];
}

@end
