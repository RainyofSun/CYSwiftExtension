//
//  APPAddressBookManager.m
//  APPContactManager
//
//  Created by LeeJay on 2017/3/22.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "APPContactManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "APPPerson.h"
#import "APPPeoplePickerDelegate.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "APPPickerDetailDelegate.h"
#import "NSString+APPExtension.h"

#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

@interface APPContactManager () <ABNewPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate, CNContactViewControllerDelegate, CNContactPickerDelegate>

@property (nonatomic, copy) void (^handler) (NSString *, NSString *);
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) NSArray *keys;
@property (nonatomic, strong) APPPeoplePickerDelegate *pickerDelegate;
@property (nonatomic, strong) APPPickerDetailDelegate *pickerDetailDelegate;
@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic, strong) CNContactStore *contactStore;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation APPContactManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _queue = dispatch_queue_create("com.addressBook.queue", DISPATCH_QUEUE_SERIAL);
        
        if (IOS9_OR_LATER)
        {
            _contactStore = [CNContactStore new];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(_contactStoreDidChange)
                                                         name:CNContactStoreDidChangeNotification
                                                       object:nil];
        }
        else
        {
            _addressBook = ABAddressBookCreate();
            ABAddressBookRegisterExternalChangeCallback(self.addressBook, _addressBookChange, nil);
        }
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id shared_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_instance = [[self alloc] init];
    });
    return shared_instance;
}

- (NSArray *)keys
{
    if (!_keys)
    {
        _keys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                  CNContactPhoneNumbersKey,
                  CNContactOrganizationNameKey,
                  CNContactDepartmentNameKey,
                  CNContactJobTitleKey,
                  CNContactPhoneticGivenNameKey,
                  CNContactPhoneticFamilyNameKey,
                  CNContactPhoneticMiddleNameKey,
                  CNContactImageDataKey,
                  CNContactThumbnailImageDataKey,
                  CNContactEmailAddressesKey,
                  CNContactPostalAddressesKey,
                  CNContactBirthdayKey,
                  CNContactNonGregorianBirthdayKey,
                  CNContactInstantMessageAddressesKey,
                  CNContactSocialProfilesKey,
                  CNContactRelationsKey,
                  CNContactUrlAddressesKey];
        
    }
    return _keys;
}

- (APPPeoplePickerDelegate *)pickerDelegate
{
    if (!_pickerDelegate)
    {
        _pickerDelegate = [APPPeoplePickerDelegate new];
    }
    return _pickerDelegate;
}

- (APPPickerDetailDelegate *)pickerDetailDelegate
{
    if (!_pickerDetailDelegate)
    {
        _pickerDetailDelegate = [APPPickerDetailDelegate new];
        __weak typeof(self) weakSelf = self;
        _pickerDetailDelegate.handler = ^(NSString *name, NSString *phoneNum) {
            NSString *newPhoneNum = [NSString APP_filterSpecialString:phoneNum];
            weakSelf.handler(name, newPhoneNum);
        };
    }
    return _pickerDetailDelegate;
}

#pragma mark - Public

- (void)selectContactAtController:(UIViewController *)controller
                      complection:(void (^)(NSString *, NSString *))completcion
{
    self.isAdd = NO;
    [self _presentFromController:controller];
    
    self.handler = completcion;
}

- (void)createNewContactWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller
{
    if (IOS9_OR_LATER)
    {
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        CNLabeledValue *labelValue = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile
                                                                     value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum]];
        contact.phoneNumbers = @[labelValue];
        CNContactViewController *contactController = [CNContactViewController viewControllerForNewContact:contact];
        contactController.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:contactController];
        [controller presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
        ABRecordRef newPerson = ABPersonCreate();
        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        CFErrorRef error = NULL;
        ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(phoneNum), kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiValue , &error);
        CFRelease(multiValue);
        picker.displayedPerson = newPerson;
        CFRelease(newPerson);
        picker.newPersonViewDelegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
        [controller presentViewController:nav animated:YES completion:nil];
    }
}

- (void)addToExistingContactsWithPhoneNum:(NSString *)phoneNum controller:(UIViewController *)controller
{
    self.isAdd = YES;
    self.pickerDelegate.phoneNum = phoneNum;
    self.pickerDelegate.controller = controller;
    
    [self _presentFromController:controller];
}

- (void)accessContactsComplection:(void (^)(BOOL, NSArray<APPPerson *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            if (IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:NO completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil);
            }
        }
    }];
}

- (void)accessSectionContactsComplection:(void (^)(BOOL, NSArray<APPSectionPerson *> *, NSArray<NSString *> *))completcion
{
    [self requestAddressBookAuthorization:^(BOOL authorization) {
        
        if (authorization)
        {
            if (IOS9_OR_LATER)
            {
                [self _asynAccessContactStoreWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
            else
            {
                [self _asynAccessAddressBookWithSort:YES completcion:^(NSArray *datas, NSArray *keys) {
                    
                    if (completcion)
                    {
                        completcion(YES, datas, keys);
                    }
                }];
            }
        }
        else
        {
            if (completcion)
            {
                completcion(NO, nil, nil);
            }
        }
    }];
}

#pragma mark - ABNewPersonViewControllerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person
{
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestAddressBookAuthorization:(void (^)(BOOL authorization))completion
{
    if (IOS9_OR_LATER)
    {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        
        if (status == CNAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            if (@available(iOS 18.0, *)) {
                _blockExecute(completion, status == CNAuthorizationStatusAuthorized || status == CNAuthorizationStatusLimited);
            } else {
                _blockExecute(completion, status == CNAuthorizationStatusAuthorized);
            }
        }
    }
    else
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            [self _authorizationAddressBook:^(BOOL succeed) {
                _blockExecute(completion, succeed);
            }];
        }
        else
        {
            _blockExecute(completion, ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized);
        }
    }
}

#pragma mark - Private

- (void)_authorizationAddressBook:(void (^) (BOOL succeed))completion
{
    if (IOS9_OR_LATER)
    {
        [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (completion)
            {
                completion(granted);
            }
        }];
    }
    else
    {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (completion)
            {
                completion(granted);
            }
        });
    }
}

void _blockExecute(void (^completion)(BOOL authorizationA), BOOL authorizationB)
{
    if (completion)
    {
        if ([NSThread isMainThread])
        {
            completion(authorizationB);
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(authorizationB);
            });
        }
    }
}

- (void)_presentFromController:(UIViewController *)controller
{
    if (IOS9_OR_LATER)
    {
        CNContactPickerViewController *pc = [[CNContactPickerViewController alloc] init];
        if (self.isAdd)
        {
            pc.delegate = self.pickerDelegate;
        }
        else
        {
            pc.delegate = self.pickerDetailDelegate;
        }
        
        pc.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        
        [self requestAddressBookAuthorization:^(BOOL authorization) {
            if (authorization)
            {
                [controller presentViewController:pc animated:YES completion:nil];
            }
            else
            {
                [self _showAlertFromController:controller];
            }
        }];
    }
    else
    {
        ABPeoplePickerNavigationController *pvc = [[ABPeoplePickerNavigationController alloc] init];
        pvc.displayedProperties = @[@(kABPersonPhoneProperty)];
        
        if (self.isAdd)
        {
            pvc.peoplePickerDelegate = self.pickerDelegate;
        }
        else
        {
            pvc.peoplePickerDelegate = self.pickerDetailDelegate;
        }
        
        [self requestAddressBookAuthorization:^(BOOL authorization) {
            
            if (authorization)
            {
                [controller presentViewController:pvc animated:YES completion:nil];
            }
            else
            {
                [self _showAlertFromController:controller];
            }
            
        }];
    }
}

- (void)_showAlertFromController:(UIViewController *)controller
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:@"The APP applies to access the contact list. Easily upload contact information to simplify steps and accelerate the loan application." preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }])];
    [alertControl addAction:([UIAlertAction actionWithTitle:@"Go Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                         }];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }])];
    [controller presentViewController:alertControl animated:YES completion:nil];
}

- (void)_asynAccessAddressBookWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableArray *datas = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(weakSelf.addressBook);
        CFIndex count = CFArrayGetCount(allPeople);
        
        for (int i = 0; i < count; i++)
        {
            ABRecordRef record = CFArrayGetValueAtIndex(allPeople, i);
            APPPerson *personModel = [[APPPerson alloc] initWithRecord:record];
            [datas addObject:personModel];
        }
        
        CFRelease(allPeople);
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return ;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_asynAccessContactStoreWithSort:(BOOL)isSort completcion:(void (^)(NSArray *, NSArray *))completcion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        
        NSMutableArray *datas = [NSMutableArray array];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:self.keys];
        [weakSelf.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            APPPerson *person = [[APPPerson alloc] initWithCNContact:contact];
            [datas addObject:person];
            
        }];
        
        if (!isSort)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(datas, nil);
                }
                
            });
            
            return;
        }
        
        [self _sortNameWithDatas:datas completcion:^(NSArray *persons, NSArray *keys) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (completcion)
                {
                    completcion(persons, keys);
                }
                
            });
            
        }];
        
    });
}

- (void)_sortNameWithDatas:(NSArray *)datas completcion:(void (^)(NSArray *, NSArray *))completcion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (APPPerson *person in datas)
    {
        // 拼音首字母
        NSString *firstLetter = nil;
        
        if (person.fullName.length == 0)
        {
            firstLetter = @"#";
        }
        else
        {
            NSString *pinyinString = [NSString APP_pinyinForString:person.fullName];
            person.pinyin = pinyinString;
            NSString *upperStr = [[pinyinString substringToIndex:1] uppercaseString];
            NSString *regex = @"^[A-Z]$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            firstLetter = [predicate evaluateWithObject:upperStr] ? upperStr : @"#";
        }
        
        if (dict[firstLetter])
        {
            [dict[firstLetter] addObject:person];
        }
        else
        {
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:person, nil];
            dict[firstLetter] = arr;
        }
    }
    
    NSMutableArray *keys = [[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    if ([keys.firstObject isEqualToString:@"#"])
    {
        [keys addObject:keys.firstObject];
        [keys removeObjectAtIndex:0];
    }
    
    NSMutableArray *persons = [NSMutableArray array];
    
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        APPSectionPerson *person = [APPSectionPerson new];
        person.key = key;
        
        // 组内按照拼音排序
        NSArray *personsArr = [dict[key] sortedArrayUsingComparator:^NSComparisonResult(APPPerson *person1, APPPerson *person2) {
            
            NSComparisonResult result = [person1.pinyin compare:person2.pinyin];
            return result;
        }];
        
        person.persons = personsArr;
        
        [persons addObject:person];
    }];
    
    if (completcion)
    {
        completcion(persons, keys);
    }
}

void _addressBookChange(ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    if ([APPContactManager sharedInstance].contactChangeHandler)
    {
        [APPContactManager sharedInstance].contactChangeHandler();
    }
}

- (void)_contactStoreDidChange
{
    if ([APPContactManager sharedInstance].contactChangeHandler)
    {
        [APPContactManager sharedInstance].contactChangeHandler();
    }
}

- (void)dealloc
{
    if (IOS9_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
    }
    else
    {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, _addressBookChange, nil);
        if (_addressBook)
        {
            CFRelease(_addressBook);
            _addressBook = NULL;
        }
    }
}

@end


