//
//  ViewController.h
//  MyFirstApp
//
//  Created by admin on 17/09/16.
//  Copyright © 2016 admin. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface RootViewController : UIViewController {
    int buttonPressCount;
}

@property (nonatomic, retain) IBOutlet UILabel *buttonPressLabel;
@property (nonatomic, retain) IBOutlet UILabel *echoLabel;

- (IBAction)simpleButtonPressed:(id)sender;
- (IBAction)textFieldTextDidChange:(id)sender;
@end