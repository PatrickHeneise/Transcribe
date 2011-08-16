//
//  TranscribeAddReferenceViewController.m
//  Transcribe
//
//  Created by Patrick Heneise on 7/4/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "TranscribeAddReferenceViewController.h"


@implementation TranscribeAddReferenceViewController
@synthesize delegate;
@synthesize attributes;
@synthesize currentAttribute;
@synthesize referenceAttribute;
@synthesize referenceKey;
@synthesize referenceContent;
@synthesize data;
@synthesize activeRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"SettingsPlist" ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        attributes = [[NSArray alloc] initWithArray:[dict valueForKey:@"referenceAttributes"]];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [attributes release];
    [referenceAttribute release];
    [referenceKey release];
    [referenceContent release];
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
        [referenceContent setText:[data valueForKey:@"content"]];
        [referenceKey setText:[data valueForKey:@"key"]];
        for(int i = 0; i < [attributes count]; i++)
        {
            if([[attributes objectAtIndex:i] isEqualToString:[data valueForKey:@"attribute"]]) 
            {
                [referenceAttribute selectRow:i inComponent:0 animated:NO];
                currentAttribute = [attributes objectAtIndex:i];
            } 
        }
    }
    else
    {
        [referenceContent setText:@""];
        [referenceKey setText:@""];
        currentAttribute = [attributes objectAtIndex:0];
    }
}

- (void)viewDidUnload
{
    [self setReferenceAttribute:nil];
    [self setReferenceKey:nil];
    [self setReferenceContent:nil];
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
    
    [dic setObject:[referenceContent text] forKey:@"content"];
    [dic setObject:[referenceKey text] forKey:@"key"];
    [dic setObject:currentAttribute forKey:@"attribute"];
    
    [delegate didReceiveReference:dic forRow:activeRow];
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
    currentAttribute = [attributes objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [attributes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [attributes objectAtIndex:row];
}
@end
