//
//  MetaLanguagePickerController.h
//  Transcribe
//
//  Created by Patrick Heneise on 6/24/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaViewController.h"

@protocol ModalViewDelegate;

@interface MetaLanguagePickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    id<ModalViewDelegate> delegate;
    NSArray *languageIdents;
    UITextField *language;
    UITextField *usage;
    UIPickerView *ident;
    NSMutableArray *languages;
    NSString *currentLanguage;
    NSNumber *activeLanguageRow;
}
@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic, retain) NSArray *languageIdents;
@property (nonatomic, retain) IBOutlet UITextField *language;
@property (nonatomic, retain) IBOutlet UITextField *usage;
@property (nonatomic, retain) IBOutlet UIPickerView *ident;
@property (nonatomic, retain) NSMutableArray *languages;
@property (nonatomic, retain) NSNumber *activeLanguageRow;

- (IBAction)saveLanguage:(id)sender;
- (IBAction)cancel:(id)sender;
@end
