//
//  APPPeoplePickerDelegate.h
//  APPContactManager
//
//  Created by LeeJay on 2017/3/22.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>

@interface APPPeoplePickerDelegate : NSObject <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, CNContactPickerDelegate, CNContactViewControllerDelegate>

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, copy) void (^completcion) (BOOL succeed);

@end
