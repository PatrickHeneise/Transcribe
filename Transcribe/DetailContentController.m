//
//  DetailContentController.m
//  Transcribe
//
//  Created by Patrick Heneise on 6/12/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "DetailContentController.h"
#import "TranscribeAppDelegate.h"
#import "MetaViewController.h"
#import "TranscribeLetterViewController.h"

@interface DetailContentController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
@end

@implementation DetailContentController
@synthesize scrollView, pageControl;
@synthesize doc;
@synthesize toolbar;
@synthesize contentView;
@synthesize documentDelegate;
@synthesize transcription;
@synthesize references;
@synthesize annotations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *buttons = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithTitle:@"Transcribe" style:UIBarButtonItemStyleBordered target:self action:@selector(loadTranscriptionView:)];
        [buttons addObject:bi];
        [bi release];
        bi = [[UIBarButtonItem alloc] initWithTitle:@"Meta Data" style:UIBarButtonItemStyleBordered target:self action:@selector(loadMetaView:)];
        [buttons addObject:bi];
        [bi release];
        UIToolbar *tools = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44.01)] autorelease];
        [tools setItems:buttons animated:NO];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:tools];
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
    return self;
}

- (void)dealloc
{
    [references release];
    [transcription release];
    [annotations release];
    [scrollView release];
    [pageControl release];
    [doc release];
    [toolbar release];
    [contentView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.references = [[[NSMutableArray alloc] initWithArray:[doc valueForKeyPath:@"references"]] retain];
    self.annotations = [[[NSMutableArray alloc] initWithArray:[doc valueForKeyPath:@"annotations"]] retain];
    self.transcription = [[[NSMutableString alloc] initWithString:[doc valueForKeyPath:@"transcription.text"]] retain];

    
    numberOfPages = 4;
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * numberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = numberOfPages;
    pageControl.currentPage = 0;
    
    [self.contentView setFrame:CGRectMake(0,0,scrollView.frame.size.width, scrollView.frame.size.height)];
    [self.scrollView addSubview:self.contentView];
    [self updatePreview];
}

- (void) updatePreview
{
    NSString *input = [doc valueForKeyPath:@"transcription.text"];
    
    NSMutableString * strToMakeReplacements = [[NSMutableString alloc] initWithString:input];
    
    NSError * error = nil;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\}\\}" options:NSRegularExpressionCaseInsensitive    error:&error];
    
    NSArray * matches = [regex matchesInString:input options:NSMatchingReportProgress range:NSMakeRange(0, [input length])];
    
    for (int i = [matches count]-1; i>=0 ; i--) {
        NSTextCheckingResult * match = [matches objectAtIndex:i];
        
        NSRange matchRange = match.range;
        NSString * numString = [input substringWithRange:NSMakeRange(matchRange.location+2, matchRange.length-4)];
        NSInteger num = [numString intValue];
        
#pragma warning - check num
        NSMutableString * replacementValue = [[NSMutableString alloc] init];
        [replacementValue setString:[[references objectAtIndex:num] valueForKey:@"content"]];
        [replacementValue insertString:@"<span class=\"ref\">" atIndex:0];
        [replacementValue appendString:@"</span>"];
        
        [strToMakeReplacements replaceCharactersInRange:match.range withString:replacementValue];
        [replacementValue release];
    }
    
    NSMutableString * strToMakeReplacements2 = [[NSMutableString alloc] initWithString:strToMakeReplacements];
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\[([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\]\\]" options:NSRegularExpressionCaseInsensitive    error:&error];
    
    matches = [regex matchesInString:strToMakeReplacements options:NSMatchingReportProgress range:NSMakeRange(0, [strToMakeReplacements length])];
    
    for (int i = [matches count]-1; i>=0 ; i--) {
        NSTextCheckingResult * match = [matches objectAtIndex:i];
        
        NSRange matchRange = match.range;
        NSString * numString = [strToMakeReplacements substringWithRange:NSMakeRange(matchRange.location+2, matchRange.length-4)];
        NSInteger num = [numString intValue];
        
#pragma warning - check num
        NSMutableString * replacementValue = [[NSMutableString alloc] init];
        [replacementValue setString:[[references objectAtIndex:num] valueForKey:@"content"]];
        [replacementValue insertString:@"<span class=\"ano\">" atIndex:0];
        [replacementValue appendString:@"</span>"];
        
        [strToMakeReplacements2 replaceCharactersInRange:match.range withString:replacementValue];
        [replacementValue release];
    }
    [transcription setString:@"<html><head><style type=\"text/css\">span.ref {background-color:#6676A1;} span.ano {background-color:#687B7A;}</style></head><body>"];
    [transcription appendString:strToMakeReplacements2];
    [transcription appendString:@"</body></html>"];
    [contentView loadHTMLString:transcription baseURL:nil];
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setTitle:@"Back"];
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTitle:[doc valueForKeyPath:@"header.fileDesc.titleStmt.title"]];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Custom Functions
- (void)setDoc:(NSDictionary*)newDoc
{
    if (doc != newDoc) {
        [doc release];
        doc = [newDoc retain];
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    [self setTitle:[doc valueForKeyPath:@"header.fileDesc.titleStmt.title"]];
}

- (IBAction)loadMetaView:(id)sender {
    MetaViewController *metaViewController = [[MetaViewController alloc] initWithNibName:@"MetaView" bundle:nil];
    [metaViewController setDocumentDelegate:documentDelegate];
    [metaViewController setDoc:doc];
    [self.navigationController pushViewController:metaViewController animated:YES];
    [metaViewController release];
}

- (IBAction)loadTranscriptionView:(id)sender {
    TranscribeLetterViewController *transcriptionViewController = [[TranscribeLetterViewController alloc] initWithNibName:@"TranscribeLetterView" bundle:nil];
    [transcriptionViewController setDoc:doc];
    [transcriptionViewController setDocumentDelegate:documentDelegate];
    [self.navigationController pushViewController:transcriptionViewController animated:YES];
    [transcriptionViewController release];
}
@end