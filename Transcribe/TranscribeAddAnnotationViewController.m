//
//  TranscribeAddAnnotationViewController.m
//  Transcribe
//
//  Created by Patrick Heneise on 7/4/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "TranscribeAddAnnotationViewController.h"


@implementation TranscribeAddAnnotationViewController
@synthesize delegate;
@synthesize categories;
@synthesize currentCategory;
@synthesize annotationTitle;
@synthesize annotationCategory;
@synthesize annotationText;
@synthesize activeRow;
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"SettingsPlist" ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        categories = [[NSArray alloc] initWithArray:[dict valueForKey:@"annotationCategories"]];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [categories release];
    [annotationTitle release];
    [annotationCategory release];
    [annotationText release];
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
    if(data != nil)
    {
        [annotationTitle setText:[data valueForKey:@"title"]];
        [annotationText setText:[data valueForKey:@"content"]];
        for(int i = 0; i < [categories count]; i++)
        {
            if([[categories objectAtIndex:i] isEqualToString:[data valueForKey:@"category"]]) 
            {
                [annotationCategory selectRow:i inComponent:0 animated:NO];
            }
        }
    }
    else
    {
        [annotationText setText:@""];
        [annotationTitle setText:@""];
        currentCategory = [categories objectAtIndex:0];
    }
}

- (void)viewDidUnload
{
    [self setAnnotationTitle:nil];
    [self setAnnotationCategory:nil];
    [self setAnnotationText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)save:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [dic setValue:[defaults stringForKey:@"name_preference"] forKey:@"author"];
    [dic setValue:currentCategory forKey:@"category"];
    [dic setValue:annotationText.text forKey:@"content"];
    [dic setValue:annotationTitle.text forKey:@"title"];

    [delegate didReceiveAnnotation:dic forRow:activeRow];
    [self dismissModalViewControllerAnimated:YES];
    
    [dic release];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - picker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentCategory = [categories objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [categories count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [categories objectAtIndex:row];
}

@end
