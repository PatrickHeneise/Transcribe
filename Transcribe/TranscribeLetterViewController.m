//
//  TranscribeLetterViewController.m
//  Transcribe
//
//  Created by Patrick Heneise on 6/18/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "TranscribeLetterViewController.h"
#import "TranscribeAddAnnotationViewController.h"
#import "TranscribeAddReferenceViewController.h"
#import "AnnotationTableViewController.h"
#import "ReferenceTableViewController.h"

@implementation TranscribeLetterViewController
@synthesize imageScrollView;
@synthesize documentDelegate;
@synthesize teiImage;
@synthesize teiTranscription;
@synthesize transcriptionPreview;
@synthesize transcription;
@synthesize doc;
@synthesize addReference;
@synthesize addAnnotation;
@synthesize teiReferences;
@synthesize teiAnnotations;
@synthesize references;
@synthesize annotations;
@synthesize previewLabel;
@synthesize transcriptionLabel;
@synthesize referenceLabel;
@synthesize annotationLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *rightButtons = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        NSMutableArray *leftButtons = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
        
        UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [rightButtons addObject:bi];
        [bi release];
        
        bi = [[UIBarButtonItem alloc] initWithTitle:@"Annotations" style:UIBarButtonItemStyleBordered target:self action:@selector(viewAnnotations:)];
        [rightButtons addObject:bi];
        [bi release];
        bi = [[UIBarButtonItem alloc] initWithTitle:@"References" style:UIBarButtonItemStyleBordered target:self action:@selector(viewReferences:)];
        [rightButtons addObject:bi];
        [bi release];
       
        UIToolbar *rightBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44.01)] autorelease];
        [rightBar setItems:rightButtons animated:NO];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBar]];
        
        bi = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDoc:)];
        [leftButtons addObject:bi];
        [bi release];
        
        bi = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
        [leftButtons addObject:bi];
        [bi release];
        
        UIToolbar *leftBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44.01)] autorelease];
        [leftBar setItems:leftButtons animated:NO];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftBar]];
        
        [self registerForKeyboardNotifications];
    }
    return self;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (IBAction)addReference:(id)sender 
{
    TranscribeAddReferenceViewController *tarvc = [[TranscribeAddReferenceViewController alloc] initWithNibName:@"TranscribeAddReferenceView" bundle:nil];
    tarvc.delegate = self;
    if (teiTranscription.selectedRange.location != NSNotFound) {
        textPosition = teiTranscription.selectedRange.location;
    }
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:tarvc];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    nc.view.superview.frame = CGRectMake(0, 0, 500, 550);
    nc.view.superview.center = self.view.center;
    [tarvc release];
    [nc release];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updatePreview];
}

- (IBAction)addAnnotation:(id)sender 
{
    TranscribeAddAnnotationViewController *taavc = [[TranscribeAddAnnotationViewController alloc] initWithNibName:@"TranscribeAddAnnotationView" bundle:nil];
    taavc.delegate = self;
    if (teiTranscription.selectedRange.location != NSNotFound) {
        textPosition = teiTranscription.selectedRange.location;
    }
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:taavc];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    nc.view.superview.frame = CGRectMake(0, 0, 500, 550);
    nc.view.superview.center = self.view.center;
    [taavc release];
    [nc release];
}

- (IBAction)viewAnnotations:(id)sender
{
    AnnotationTableViewController *atvc = [[AnnotationTableViewController alloc] initWithNibName:@"AnnotationTableView" bundle:nil];
    [atvc setAnnotations:annotations];
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:atvc];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    nc.view.superview.frame = CGRectMake(0, 0, 400, 700);
    nc.view.superview.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    [atvc release];
    [nc release];
}

- (IBAction)viewReferences:(id)sender
{
    ReferenceTableViewController *rtvc = [[ReferenceTableViewController alloc] initWithNibName:@"ReferenceTableView" bundle:nil];
    [rtvc setReferences:references];
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:rtvc];
    [nc setModalInPopover:YES];
    [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [nc setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:nc animated:YES];
    nc.view.superview.frame = CGRectMake(0, 0, 400, 700);
    nc.view.superview.center = CGPointMake(self.view.center.x + 100, self.view.center.y - 100);
    [rtvc release];
    [nc release];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect textFrame = teiTranscription.frame;
    textFrame.size.height = textFrame.size.height - 100;
    textFrame.origin.y = textFrame.origin.y - 135;
    [teiTranscription setFrame:textFrame];
    
    textFrame = transcriptionPreview.frame;
    textFrame.size.height = textFrame.size.height - 50;
    textFrame.origin.y = textFrame.origin.y - 85;
    [transcriptionPreview setFrame:textFrame];
    
    CGRect imageFrame = imageScrollView.frame;
    imageFrame.size.height = imageFrame.size.height - 85;
    [imageScrollView setFrame:imageFrame];
    
    CGRect labelFrame = transcriptionLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y - 135;
    [transcriptionLabel setFrame:labelFrame];
    labelFrame = referenceLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y - 85;
    [referenceLabel setFrame:labelFrame];
    labelFrame = previewLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y - 85;
    [previewLabel setFrame:labelFrame];
    labelFrame = annotationLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y - 135;
    [annotationLabel setFrame:labelFrame];
    
    CGRect buttonFrame = addReference.frame;
    buttonFrame.origin.y = buttonFrame.origin.y - 235;
    [addReference setFrame:buttonFrame];
    buttonFrame = addAnnotation.frame;
    buttonFrame.origin.y = buttonFrame.origin.y - 235;
    [addAnnotation setFrame:buttonFrame];
    
    CGRect tableFrame = teiReferences.frame;
    tableFrame.origin.y = tableFrame.origin.y - 85;
    tableFrame.size.height = tableFrame.size.height - 50;
    [teiReferences setFrame:tableFrame];
    tableFrame = teiAnnotations.frame;
    tableFrame.origin.y = tableFrame.origin.y - 135;
    tableFrame.size.height = tableFrame.size.height - 50;
    [teiAnnotations setFrame:tableFrame];
    
    [UIView commitAnimations];
    NSLog(@"Views resized");
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect textFrame = teiTranscription.frame;
    textFrame.size.height = textFrame.size.height + 100;
    textFrame.origin.y = textFrame.origin.y + 135;
    [teiTranscription setFrame:textFrame];
    
    textFrame = transcriptionPreview.frame;
    textFrame.size.height = textFrame.size.height + 50;
    textFrame.origin.y = textFrame.origin.y + 85;
    [transcriptionPreview setFrame:textFrame];
    
    CGRect imageFrame = imageScrollView.frame;
    imageFrame.size.height = imageFrame.size.height + 85;
    [imageScrollView setFrame:imageFrame];
    
    CGRect labelFrame = transcriptionLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y + 135;
    [transcriptionLabel setFrame:labelFrame];
    labelFrame = referenceLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y + 85;
    [referenceLabel setFrame:labelFrame];
    labelFrame = previewLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y + 85;
    [previewLabel setFrame:labelFrame];
    labelFrame = annotationLabel.frame;
    labelFrame.origin.y = labelFrame.origin.y + 135;
    [annotationLabel setFrame:labelFrame];
    
    CGRect buttonFrame = addReference.frame;
    buttonFrame.origin.y = buttonFrame.origin.y + 235;
    [addReference setFrame:buttonFrame];
    buttonFrame = addAnnotation.frame;
    buttonFrame.origin.y = buttonFrame.origin.y + 235;
    [addAnnotation setFrame:buttonFrame];
    
    CGRect tableFrame = teiReferences.frame;
    tableFrame.origin.y = tableFrame.origin.y + 85;
    tableFrame.size.height = tableFrame.size.height + 50;
    [teiReferences setFrame:tableFrame];
    tableFrame = teiAnnotations.frame;
    tableFrame.origin.y = tableFrame.origin.y + 135;
    tableFrame.size.height = tableFrame.size.height + 50;
    [teiAnnotations setFrame:tableFrame];
    
    [UIView commitAnimations];
    NSLog(@"Views resized");
}


- (void)dealloc
{
    [references release];
    [transcription release];
    [annotations release];
    [teiImage release];
    [teiTranscription release];
    [transcriptionPreview release];
    [addReference release];
    [addAnnotation release];
    [teiReferences release];
    [teiAnnotations release];
    [previewLabel release];
    [transcriptionLabel release];
    [referenceLabel release];
    [annotationLabel release];
    [imageScrollView release];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.references = [[[NSMutableArray alloc] initWithArray:[doc valueForKeyPath:@"references"]] retain];
    self.annotations = [[[NSMutableArray alloc] initWithArray:[doc valueForKeyPath:@"annotations"]] retain];
    
    self.transcription = [[[NSMutableString alloc] initWithString:[doc valueForKeyPath:@"transcription.text"]] retain];
    [self.teiTranscription setText:self.transcription];
    
    [self.imageScrollView addSubview:self.teiImage];
    self.imageScrollView.contentSize = self.teiImage.bounds.size;
    self.imageScrollView.maximumZoomScale = 5.0;
    self.imageScrollView.minimumZoomScale = 0.1;
    self.imageScrollView.clipsToBounds = YES;
    
    referenceCount = 0;
    annotationsCount = 0;
    
    [self updatePreview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadImage];
}

- (void)viewDidUnload
{
    [self setTeiImage:nil];
    [self setTeiTranscription:nil];
    [self setTranscriptionPreview:nil];
    [self setAddReference:nil];
    [self setAddAnnotation:nil];
    [self setTeiReferences:nil];
    [self setTeiAnnotations:nil];
    [self setPreviewLabel:nil];
    [self setTranscriptionLabel:nil];
    [self setReferenceLabel:nil];
    [self setAnnotationLabel:nil];
    [self setImageScrollView:nil];
    [self setTranscriptionPreview:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.teiReferences)
        return [references count];
    else
        return [annotations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(tableView == self.teiReferences)
    {
        
        NSString *cellTitle = [NSString stringWithFormat:@"%d", indexPath.row];
        cellTitle = [cellTitle stringByAppendingString:@": "];
        cellTitle = [cellTitle stringByAppendingString:[[references objectAtIndex:indexPath.row] valueForKey:@"attribute"]];
        
        [cell.textLabel setFont:[UIFont fontWithName:@"Cochin" size:16.0f]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Cochin" size:12.0f]];
        
        [cell.textLabel setText:cellTitle];
        [cell.detailTextLabel setText:[[references objectAtIndex:indexPath.row] valueForKey:@"content"]];
    } 
    else
    {
        NSString *cellTitle = [NSString stringWithFormat:@"%d", indexPath.row];
        cellTitle = [cellTitle stringByAppendingString:@": "];
        cellTitle = [cellTitle stringByAppendingString:[[annotations objectAtIndex:indexPath.row] valueForKey:@"author"]];
        
        [cell.textLabel setFont:[UIFont fontWithName:@"Cochin" size:16.0f]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Cochin" size:12.0f]];
        
        [cell.textLabel setText:cellTitle];
        [cell.detailTextLabel setText:[[annotations objectAtIndex:indexPath.row] valueForKey:@"content"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.teiAnnotations)
    {
        TranscribeAddAnnotationViewController *taavc = [[TranscribeAddAnnotationViewController alloc] initWithNibName:@"TranscribeAddAnnotationView" bundle:nil];
        [taavc setDelegate:self];
        [taavc setActiveRow:[NSNumber numberWithInt:indexPath.row]];
        [taavc setData:[annotations objectAtIndex:indexPath.row]];
        UINavigationController *nc = [[UINavigationController alloc]
                                      initWithRootViewController:taavc];
        [nc setModalInPopover:YES];
        [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [nc setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentModalViewController:nc animated:YES];
        nc.view.superview.frame = CGRectMake(0, 0, 500, 550);
        nc.view.superview.center = self.view.center;
        [taavc release];
        [nc release];
    } else {
        TranscribeAddReferenceViewController *tarvc = [[TranscribeAddReferenceViewController alloc] initWithNibName:@"TranscribeAddReferenceView" bundle:nil];
        [tarvc setDelegate:self];
        [tarvc setActiveRow:[NSNumber numberWithInt:indexPath.row]];
        [tarvc setData:[references objectAtIndex:indexPath.row]];
        UINavigationController *nc = [[UINavigationController alloc]
                                      initWithRootViewController:tarvc];
        [nc setModalInPopover:YES];
        [nc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [nc setModalPresentationStyle:UIModalPresentationFormSheet];
        [self presentModalViewController:nc animated:YES];
        nc.view.superview.frame = CGRectMake(0, 0, 500, 550);
        nc.view.superview.center = self.view.center;
        [tarvc release];
        [nc release];
    }
    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

#pragma mark Custom functions
- (void) loadImage
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
    [self.teiImage setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [self.teiImage setImage:img];
    self.imageScrollView.contentSize = self.teiImage.bounds.size;
    
    float scale = self.imageScrollView.frame.size.width / self.teiImage.frame.size.width;
    
    [self.imageScrollView setZoomScale:scale];
    self.imageScrollView.minimumZoomScale = scale;

    if([images count] > 1)
        [teiImage setAnimationImages:images];
    [images release];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)sv{
    return teiImage;
}

#pragma mark Protocol functions
- (void)didReceiveReference:(NSDictionary *)inData forRow:(NSNumber*) row
{
    if(row == nil)
    {
        [references addObject:inData];
        NSMutableString *newText = [[NSMutableString alloc] initWithString:teiTranscription.text];
        [newText insertString:[NSString stringWithFormat:@"{{%d}}", referenceCount] atIndex:textPosition];
        [teiTranscription setText:newText];
    } else {
        [references replaceObjectAtIndex:[row intValue] withObject:inData];
    }
    [teiReferences reloadData];
    
    [self updatePreview];
    
}

- (void)didReceiveAnnotation:(NSDictionary *)inData forRow:(NSNumber*) row
{
    if(row == nil)
    {
        [annotations addObject:inData];
        NSMutableString *newText = [[NSMutableString alloc] initWithString:teiTranscription.text];
        [newText insertString:[NSString stringWithFormat:@"[[%d]]", annotationsCount] atIndex:textPosition];
        [teiTranscription setText:newText];
    } else {
        [annotations replaceObjectAtIndex:[row intValue] withObject:inData];
    }
    [teiAnnotations reloadData];
    
    [self updatePreview];

}

- (void) updateDoc
{
    NSMutableDictionary *newDoc = (NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, doc, kCFPropertyListMutableContainers);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    NSMutableDictionary *editor = [[NSMutableDictionary alloc] initWithCapacity:3];
    [editor setValue:[defaults stringForKey:@"name_preference"] forKey:@"name"];
    [editor setValue:@"Edited Transcription" forKey:@"description"];
    [editor setValue:[dateFormatter stringFromDate:date] forKey:@"timestamp"];
    
    NSMutableArray *editors = [[NSMutableArray alloc] initWithArray:[newDoc mutableArrayValueForKeyPath:@"history"]];
    [editors addObject:editor];
    
    [newDoc setValue:editors forKey:@"history"];
    [newDoc setValue:annotations forKey:@"annotations"];
    [newDoc setValue:references forKey:@"references"];
    [newDoc setValue:teiTranscription.text forKeyPath:@"transcription.text"];
    
    [editor release];
    [editors release];
    [dateFormatter release];
    [date release];
    [doc release];
    doc = [newDoc retain];
    [newDoc release];
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

- (void) updatePreview
{
    NSString *input = teiTranscription.text;
    
    NSMutableString * strToMakeReplacements = [[NSMutableString alloc] initWithString:input];
    
    NSError * error = nil;
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\}\\}" options:NSRegularExpressionCaseInsensitive    error:&error];
    
    NSArray * matches = [regex matchesInString:input options:NSMatchingReportProgress range:NSMakeRange(0, [input length])];
    
    referenceCount = [matches count];
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
    [transcriptionPreview loadHTMLString:transcription baseURL:nil];
}
@end
