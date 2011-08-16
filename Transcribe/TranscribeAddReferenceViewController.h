//
//  TranscribeAddReferenceViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 7/4/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranscribeLetterViewController.h"

@protocol ModalTranscribeViewDelegate;

@interface TranscribeAddReferenceViewController : UIViewController {
    id<ModalTranscribeViewDelegate> delegate;
    NSArray *attributes;
    NSString *currentAttribute;
    UIPickerView *referenceAttribute;
    UITextField *referenceKey;
    UITextView *referenceContent;
    NSDictionary *data;
    NSNumber *activeRow;
}

@property (nonatomic, assign) id<ModalTranscribeViewDelegate> delegate;
@property (nonatomic, retain) NSArray *attributes;
@property (nonatomic, retain) NSString *currentAttribute;
@property (nonatomic, retain) IBOutlet UIPickerView *referenceAttribute;
@property (nonatomic, retain) IBOutlet UITextField *referenceKey;
@property (nonatomic, retain) IBOutlet UITextView *referenceContent;
@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, retain) NSNumber *activeRow;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end
