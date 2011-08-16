//
//  TranscribeAddAnnotationViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 7/4/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranscribeLetterViewController.h"

@protocol ModalTranscribeViewDelegate;

@interface TranscribeAddAnnotationViewController : UIViewController {
    id<ModalTranscribeViewDelegate> delegate;
    NSArray *data;
    NSArray *categories;
    NSString *currentCategory;
    UITextField *annotationTitle;
    UIPickerView *annotationCategory;
    UITextView *annotationText;
    NSNumber *activeRow;
}

@property (nonatomic, assign) id<ModalTranscribeViewDelegate> delegate;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSString *currentCategory;
@property (nonatomic, retain) IBOutlet UITextField *annotationTitle;
@property (nonatomic, retain) IBOutlet UIPickerView *annotationCategory;
@property (nonatomic, retain) IBOutlet UITextView *annotationText;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSNumber *activeRow;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end
