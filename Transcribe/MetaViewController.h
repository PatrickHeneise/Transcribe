//
//  MetaViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 6/27/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@protocol CouchDocumentDelegate;

@protocol ModalViewDelegate <NSObject>
- (void)didReceiveLanguage:(NSMutableArray *)inData;
- (void)didReceiveDate:(NSDate *)inData;
- (void)didReceiveSender:(NSString *)inData;
- (void)didReceiveRecipient:(NSString *)inData;
@end

@interface MetaViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITabBarDelegate, ModalViewDelegate> {
    
    id<CouchDocumentDelegate> documentDelegate;
    UITextView *teiSummary;
    NSDictionary *doc;
    
    UIScrollView *scrollView;
    UIView *metaView;

    NSMutableArray *languages;
    NSDictionary *correspondents;
    NSString *sender;
    NSString *recipient;
    UIImageView *imageView;
    UIScrollView *imageScrollView;
    
    UITextField *teiIdno;
    UITableView *teiSourceLanguages;
    UITextField *teiOpeningSalute;
    UITextField *teiPlace;
    UITextField *teiDateWritten;
    UITextView *teiClosingSalute;
    UIButton *teiDate;
    UITextField *teiSigned;
    UITextField *teiTitle;
    UIButton *teiSender;
    UIButton *teiRecipient;
    UITextField *activeField;
    
    NSDateFormatter *dateformatter;
    NSDateFormatter *displayformatter;
}
@property (nonatomic, assign) id<CouchDocumentDelegate> documentDelegate;
@property (retain, nonatomic) IBOutlet UITextView *teiSummary;
@property (nonatomic, retain) NSDictionary *doc;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *metaView;
@property (nonatomic, retain) IBOutlet UITextField *teiIdno;
@property (nonatomic, retain) IBOutlet UITableView *teiSourceLanguages;
@property (nonatomic, retain) IBOutlet UITextField *teiOpeningSalute;
@property (nonatomic, retain) IBOutlet UITextField *teiPlace;
@property (nonatomic, retain) IBOutlet UITextField *teiDateWritten;
@property (nonatomic, retain) IBOutlet UITextView *teiClosingSalute;
@property (nonatomic, retain) IBOutlet UIButton *teiDate;
@property (nonatomic, retain) IBOutlet UITextField *teiSigned;
@property (nonatomic, retain) IBOutlet UITextField *teiTitle;
@property (nonatomic, retain) IBOutlet UIButton *teiSender;
@property (nonatomic, retain) IBOutlet UIButton *teiRecipient;
@property (nonatomic, retain) NSMutableArray *languages;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSString *recipient;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) NSDictionary *correspondents;

- (IBAction)showDatePicker:(id)sender;
- (void) configureView;
- (void) updateDoc;
- (IBAction)addLanguage:(id)sender;
- (void) saveDoc:(id)sender;
- (void) cancel:(id)sender;
- (void) loadImages;
- (IBAction)loadRecipients:(id)sender;
- (void)registerForKeyboardNotifications;
- (IBAction)loadSenders:(id)sender;
@end
