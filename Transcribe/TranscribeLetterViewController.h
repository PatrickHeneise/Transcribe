//
//  TranscribeLetterViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 6/18/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@protocol CouchDocumentDelegate;

@protocol ModalTranscribeViewDelegate <NSObject>
- (void)didReceiveReference:(NSDictionary *)inData   forRow:(NSNumber*) row;
- (void)didReceiveAnnotation:(NSDictionary *)inData  forRow:(NSNumber*) row;
@end

@interface TranscribeLetterViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, ModalTranscribeViewDelegate> {
    NSDictionary *doc;
    id<CouchDocumentDelegate> documentDelegate;
    UIButton *addReference;
    UIButton *addAnnotation;
    UITableView *teiReferences;
    UITableView *teiAnnotations;
    UIImageView *teiImage;
    UITextView *teiTranscription;
    UIWebView *transcriptionPreview;
    NSMutableArray *references;
    NSMutableArray *annotations;
    int annotationsCount;
    int referenceCount;
    NSMutableString *transcription;
    UILabel *previewLabel;
    UILabel *transcriptionLabel;
    UILabel *referenceLabel;
    UILabel *annotationLabel;
    UIScrollView *imageScrollView;
    int textPosition;
}
@property (nonatomic, assign) id<CouchDocumentDelegate> documentDelegate;
@property (nonatomic, retain) NSDictionary *doc;

@property (nonatomic, retain) NSMutableArray *annotations;
@property (nonatomic, retain) NSMutableArray *references;
@property (nonatomic, retain) NSMutableString *transcription;
@property (retain, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *teiImage;
@property (nonatomic, retain) IBOutlet UITextView *teiTranscription;
@property (nonatomic, retain) IBOutlet UIWebView *transcriptionPreview;
@property (nonatomic, retain) IBOutlet UIButton *addReference;
@property (nonatomic, retain) IBOutlet UIButton *addAnnotation;
@property (nonatomic, retain) IBOutlet UITableView *teiReferences;
@property (nonatomic, retain) IBOutlet UITableView *teiAnnotations;
@property (nonatomic, retain) IBOutlet UILabel *previewLabel;
@property (nonatomic, retain) IBOutlet UILabel *transcriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *referenceLabel;
@property (nonatomic, retain) IBOutlet UILabel *annotationLabel;

- (void)registerForKeyboardNotifications;
- (IBAction)addReference:(id)sender;
- (IBAction)addAnnotation:(id)sender;
- (IBAction)viewAnnotations:(id)sender;
- (IBAction)viewReferences:(id)sender;
- (void) loadImage;
- (void) updatePreview;
- (void) saveDoc:(id)sender;
- (void) updateDoc;
- (void) cancel:(id)sender;
@end