//
//  MetaDatePickerViewController.m
//  Transcribe
//
//  Created by Patrick Heneise on 6/29/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "MetaDatePickerViewController.h"


@implementation MetaDatePickerViewController
@synthesize teiDate;
@synthesize date;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveLanguage:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [teiDate release];
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
    if(date)
        [teiDate setDate:date animated:NO];
}

- (void)viewDidUnload
{
    [self setTeiDate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

#pragma mark custom functions
- (IBAction)saveLanguage:(id)sender {
    [delegate didReceiveDate:[teiDate date]];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
