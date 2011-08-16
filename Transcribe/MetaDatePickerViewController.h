//
//  MetaDatePickerViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 6/29/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaViewController.h"

@protocol ModalViewDelegate;

@interface MetaDatePickerViewController : UIViewController {

    id<ModalViewDelegate> delegate;
    UIDatePicker *teiDate;
    NSDate *date;
}
@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIDatePicker *teiDate;
@property (nonatomic, retain) NSDate *date;

- (IBAction)saveLanguage:(id)sender;
- (IBAction)cancel:(id)sender;
@end
