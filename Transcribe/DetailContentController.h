//
//  DetailContentController.h
//  Transcribe
//
//  Created by Patrick Heneise on 6/12/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@protocol CouchDocumentDelegate;

@interface DetailContentController:UIViewController <UIScrollViewDelegate>
{   
    id<CouchDocumentDelegate> documentDelegate;
    UIScrollView *scrollView;
	UIPageControl *pageControl;
    BOOL pageControlUsed;
    NSUInteger numberOfPages;
    UIToolbar *toolbar;
    UIWebView *contentView;
    NSDictionary *doc;
    NSMutableArray *references;
    NSMutableArray *annotations;
    NSMutableString *transcription;
}
@property (nonatomic, assign) id<CouchDocumentDelegate> documentDelegate;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *annotations;
@property (nonatomic, retain) NSMutableArray *references;
@property (nonatomic, retain) NSMutableString *transcription;
@property (nonatomic, retain) NSDictionary *doc;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (retain, nonatomic) IBOutlet UIWebView *contentView;

- (void)setDoc:(NSDictionary*)newDoc;
- (void)configureView;
- (void) updatePreview;
@end
