//
//  MetaViewController.m
//  Transcribe
//
//  Created by Patrick Heneise on 6/27/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "MetaViewController.h"
#import "MetaLanguagePickerController.h"
#import "MetaDatePickerViewController.h"
#import "MetaCorrespondentViewController.h"

@implementation MetaViewController
@synthesize documentDelegate;
@synthesize teiSummary;
@synthesize doc;
@synthesize scrollView;
@synthesize metaView;
@synthesize teiIdno;
@synthesize teiSourceLanguages;
@synthesize teiOpeningSalute;
@synthesize teiPlace;
@synthesize teiDateWritten;
@synthesize teiClosingSalute;
@synthesize teiDate;
@synthesize teiSigned;
@synthesize teiTitle;
@synthesize languages;
@synthesize teiSender;
@synthesize teiRecipient;
@synthesize sender;
@synthesize recipient;
@synthesize imageView;
@synthesize imageScrollView;
@synthesize correspondents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        languages = [[NSMutableArray alloc] init];
        
        NSMutableArray *leftButtons = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        
        UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDoc:)];
        [leftButtons addObject:bi];
        [bi release];
        
        bi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
        [leftButtons addObject:bi];
        [bi release];
        
        UIToolbar *leftBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 150, 44.01)] autorelease];
        [leftBar setItems:leftButtons animated:NO];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftBar]];
        
        [self registerForKeyboardNotifications];
        
        NSString *path=[[NSBundle mainBundle] pathForResource:@"SettingsPlist" ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        correspondents = [[NSDictionary alloc] initWithDictionary:[dict valueForKey:@"correspondents"]];
    }
    return self;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)dealloc
{
    [doc release];
    [languages release];
    [scrollView release];
    [metaView release];
    [teiIdno release];
    [teiSourceLanguages release];
    [teiOpeningSalute release];
    [teiRecipient release];
    [teiPlace release];
    [teiDateWritten release];
    [teiSigned release];
    [teiClosingSalute release];
    [teiDate release];
    [teiTitle release];
    [imageView release];
    [imageScrollView release];
    [teiSummary release];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_meta_left.png"]];
    
    [self.scrollView addSubview:self.metaView];
    self.scrollView.contentSize = self.metaView.bounds.size;
    
    [self.imageScrollView addSubview:self.imageView];
    self.imageScrollView.contentSize = self.imageView.bounds.size;
    self.imageScrollView.maximumZoomScale = 5.0;
    self.imageScrollView.minimumZoomScale = 0.1;
    self.imageScrollView.clipsToBounds = YES;
    
    // Update the view.
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDoc];
    // load images
    [self loadImages];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setMetaView:nil];
    [self setTeiIdno:nil];
    [self setTeiSourceLanguages:nil];
    [self setTeiOpeningSalute:nil];
    [self setTeiRecipient:nil];
    [self setTeiPlace:nil];
    [self setTeiDateWritten:nil];
    [self setTeiSigned:nil];
    [self setTeiClosingSalute:nil];
    [self setTeiDate:nil];
    [self setTeiTitle:nil];
    [self setImageView:nil];
    [self setImageScrollView:nil];
    [self setTeiSummary:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Custom functions
- (void) loadImages
{
    NSMutableArray *imageUrls = [doc mutableArrayValueForKeyPath:@"images"];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:[imageUrls count]];
    for (int i = 0; i < [imageUrls count]; i++) {
        CALayer *imageUrl = (CALayer *)[imageUrls objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:[imageUrl valueForKey:@"url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[[UIImage alloc] initWithData:data] autorelease];
        [images addObject:img];
    }
    
    UIImage *img = [images objectAtIndex:0];
    [self.imageView setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [self.imageView setImage:img];
    self.imageScrollView.contentSize = self.imageView.bounds.size;
    
    float scale = self.imageScrollView.frame.size.width / self.imageView.frame.size.width;
    
    [imageScrollView setZoomScale:scale];
    self.imageScrollView.minimumZoomScale = scale;
    
    [teiIdno setContentMode:UIViewContentModeScaleAspectFit];
    if([images count] > 1)
      [imageView setAnimationImages:images];
    [images release];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)sv{
    return imageView;
}

- (IBAction)showDatePicker:(id)sender 
{
    MetaDatePickerViewController *mdp = [[MetaDatePickerViewController alloc] initWithNibName:@"MetaDatePickerView" bundle:nil];
    mdp.delegate = self;
    [mdp setDate:[dateformatter dateFromString:[doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.date.value"]]];
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:mdp];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    [mdp release];
    [nc release];
}

- (void) updateDoc
{
    NSMutableDictionary *newDoc = (NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, doc, kCFPropertyListMutableContainers);
    
    NSDate *date = [displayformatter dateFromString:[teiDate titleForState:UIControlStateNormal]];
    [newDoc setValue:[dateformatter stringFromDate:date] forKeyPath:@"header.sourceDesc.biblFull.titleStmt.date.value"];
    
    // shelfmark
    NSMutableArray *idnos = [newDoc mutableArrayValueForKeyPath:@"header.publicationStmt.idno"];
    
    for (int i = 0; i < [idnos count]; i++) {
        if ([[[idnos objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"callNo"]) {
            [[idnos objectAtIndex:i] setValue:teiIdno.text forKey:@"content"];
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *d = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSMutableDictionary *editor = [[NSMutableDictionary alloc] initWithCapacity:3];
    [editor setValue:[defaults stringForKey:@"name_preference"] forKey:@"name"];
    [editor setValue:@"Edited Metadata" forKey:@"description"];
    [editor setValue:[dateFormatter stringFromDate:d] forKey:@"timestamp"];
    
    NSMutableArray *editors = [[NSMutableArray alloc] initWithArray:[newDoc mutableArrayValueForKeyPath:@"history"]];
    [editors addObject:editor];
    
    [newDoc setValue:editors forKey:@"history"];
    [newDoc setValue:[languages objectAtIndex:0] forKeyPath:@"header.profileDesc.langUsage"];
    
    [newDoc setValue:teiSender.titleLabel.text forKeyPath:@"header.sourceDesc.biblFull.titleStmt.author.name"];
    [newDoc setValue:sender forKeyPath:@"header.sourceDesc.biblFull.titleStmt.author.key"];
    [newDoc setValue:teiRecipient.titleLabel.text forKeyPath:@"header.sourceDesc.biblFull.titleStmt.recipient.name"];
    [newDoc setValue:recipient forKeyPath:@"header.sourceDesc.biblFull.titleStmt.recipient.key"];
    [newDoc setValue:[teiSummary text] forKeyPath:@"header.sourceDesc.biblFull.titleStmt.title"];
    [newDoc setValue:[teiOpeningSalute text] forKeyPath:@"diplomatic.opener.salute"];
    [newDoc setValue:[teiClosingSalute text] forKeyPath:@"diplomatic.closer.salute"];
    [newDoc setValue:[teiDateWritten text] forKeyPath:@"diplomatic.opener.dateline.date.content"];
    [newDoc setValue:[teiSigned text] forKeyPath:@"diplomatic.closer.signature"];
    [newDoc setValue:[teiPlace text] forKeyPath:@"diplomatic.opener.name.content"];
    [newDoc setValue:[teiTitle text] forKeyPath:@"header.sourceDesc.biblFull.titleStmt.title"];
    
    [doc release];
    doc = [newDoc retain];
    [newDoc release];
}

- (void) configureView
{    
    // dates
    dateformatter = [[NSDateFormatter alloc] init];
    displayformatter = [[NSDateFormatter alloc] init];
    
    [displayformatter setDateStyle:NSDateFormatterLongStyle];
    [dateformatter setDateFormat:[doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.date.format"]];
    
    // shelfmark and title
    [teiTitle setText:[doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.title"]];
    NSString *callno = @"";    
    NSMutableArray *idnos = [doc mutableArrayValueForKeyPath:@"header.publicationStmt.idno"];
    
    for (int i = 0; i < [idnos count]; i++) {
        CALayer *idno = (CALayer *)[idnos objectAtIndex:i];
        if ([[idno valueForKey:@"type"] isEqualToString:@"callNo"]) {
            callno = [idno valueForKey:@"content"];
        }
    }
    
    NSMutableArray *sourceLanguages = [doc mutableArrayValueForKeyPath:@"header.profileDesc.langUsage"];
    for (int i = 0; i < [sourceLanguages count]; i++) {
        CALayer *langItem = (CALayer *)[sourceLanguages objectAtIndex:i];
        [languages addObject:langItem];
    }
    
    [teiSender setTitle: [doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.author.name"] forState:UIControlStateNormal];
    sender = [doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.author.key"];
    [teiRecipient setTitle:[doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.recipient.name"] forState:UIControlStateNormal];
    recipient = [doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.recipient.key"];

    [teiOpeningSalute setText:[doc valueForKeyPath:@"diplomatic.opener.salute"]];
    [teiClosingSalute setText:[doc valueForKeyPath:@"diplomatic.closer.salute"]];
    [teiSummary setText:[doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.title"]];
    [teiDateWritten setText:[doc valueForKeyPath:@"diplomatic.opener.dateline.date.content"]];
    [teiPlace setText:[doc valueForKeyPath:@"diplomatic.opener.dateline.name.content"]];
    NSDate *date = [dateformatter dateFromString:[doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.date.value"]];
    [teiDate setTitle:[displayformatter stringFromDate:date] forState:UIControlStateNormal];
    
    [self setTitle:[doc valueForKeyPath:@"header.sourceDesc.biblFull.titleStmt.title"]];
    [teiIdno setText:callno];
    [teiSigned setText:[doc valueForKeyPath:@"diplomatic.closer.signature"]];
}

- (void) setDoc:(NSDictionary *)newDoc
{
    if (doc != newDoc) {
        [doc release];
        doc = [newDoc retain];
    }
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [languages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Cochin" size:16.0f]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Cochin" size:12.0f]];
    
    [cell.textLabel setText:[[[languages objectAtIndex:indexPath.row] valueForKey:@"language"] objectAtIndex:0]];
    [cell.detailTextLabel setText:[[[languages objectAtIndex:indexPath.row] valueForKey:@"usage"] objectAtIndex:0]];

    
    return cell;
}

#pragma mark Table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MetaLanguagePickerController *mlp = [[MetaLanguagePickerController alloc] initWithNibName:@"MetaLanguagePicker" bundle:nil];
    mlp.delegate = self;
    if(indexPath.row)
        [mlp setActiveLanguageRow:[NSNumber numberWithInt:indexPath.row]];
    else
        [mlp setActiveLanguageRow:[NSNumber numberWithInt:0]];
    [mlp setLanguages:languages];
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:mlp];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    [mlp release];
    [nc release];
}

- (IBAction)addLanguage:(id)sender 
{
    MetaLanguagePickerController *mlp = [[MetaLanguagePickerController alloc] initWithNibName:@"MetaLanguagePicker" bundle:nil];
    mlp.delegate = self;
    [mlp setLanguages:languages];
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:mlp];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    [mlp release];
    [nc release];
}

- (IBAction)loadRecipients:(id)sender 
{
    MetaCorrespondentViewController *mcvc = [[MetaCorrespondentViewController alloc] initWithNibName:@"MetaCorrespondentView" bundle:nil];
    [mcvc setDelegate:self];
    [mcvc setSender:@"recipient"];
    [mcvc setCorrespondents:correspondents];
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:mcvc];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    nc.view.superview.frame = CGRectMake(0, 0, 500, 550);
    nc.view.superview.center = self.view.center;
    [mcvc release];
    [nc release];
}

- (IBAction)loadSenders:(id)sender 
{
    MetaCorrespondentViewController *mcvc = [[MetaCorrespondentViewController alloc] initWithNibName:@"MetaCorrespondentView" bundle:nil];
    [mcvc setDelegate:self];
    [mcvc setSender:@"sender"];
    [mcvc setCorrespondents:correspondents];
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:mcvc];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    nc.view.superview.frame = CGRectMake(0, 0, 500, 550);
    nc.view.superview.center = self.view.center;
    [mcvc release];
    [nc release];
}

#pragma mark ModalViewDelegate
- (void)didReceiveLanguage:(NSMutableArray *)inData 
{
    self.languages = inData;
    [teiSourceLanguages reloadData];
}
- (void)didReceiveDate:(NSDate *)inData
{
    [teiDate setTitle:[displayformatter stringFromDate:inData] forState:UIControlStateNormal];
    [self updateDoc];
}

- (void)didReceiveSender:(NSString *)inData
{
    sender = inData;
    [teiSender setTitle:[correspondents valueForKey:inData] forState:UIControlStateNormal];
}

- (void)didReceiveRecipient:(NSString *)inData
{
    recipient = inData;
    [teiRecipient setTitle:[correspondents valueForKey:inData] forState:UIControlStateNormal];
}

- (void) cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) saveDoc:(id)sender
{
    [self updateDoc];
    [documentDelegate saveDocument:doc];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
