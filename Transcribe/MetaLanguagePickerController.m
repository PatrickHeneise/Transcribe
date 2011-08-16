//
//  MetaLanguagePickerController.m
//  Transcribe
//
//  Created by Patrick Heneise on 6/24/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "MetaLanguagePickerController.h"


@implementation MetaLanguagePickerController
@synthesize languageIdents;
@synthesize usage;
@synthesize ident;
@synthesize delegate;
@synthesize languages;
@synthesize language;
@synthesize activeLanguageRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"SettingsPlist" ofType:@"plist"];
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
        languageIdents = [[NSArray alloc] initWithArray:[dict valueForKey:@"languages"]];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveLanguage:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [language release];
    [usage release];
    [ident release];
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

    if(activeLanguageRow) {
        [language setText:[[[languages objectAtIndex:activeLanguageRow.intValue] valueForKey:@"language"] objectAtIndex:0]];
        [usage setText:[[[languages objectAtIndex:activeLanguageRow.intValue] valueForKey:@"usage"] objectAtIndex:0]];
    
        for(int i = 0; i < [languageIdents count]; i++)
        {
            if([[languageIdents objectAtIndex:i] isEqualToString:[[[languages objectAtIndex:activeLanguageRow.intValue] objectAtIndex:0] valueForKey:@"ident"]]) 
            {
                [ident selectRow:i inComponent:0 animated:NO];
            }
        }
    }
}

- (void)viewDidUnload
{
    [self setLanguage:nil];
    [self setUsage:nil];
    [self setIdent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)saveLanguage:(id)sender {
    
    NSMutableArray *arr;
    if(activeLanguageRow)
        arr = [[languages objectAtIndex:activeLanguageRow.intValue] mutableCopy];
    else
        arr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];

    [dic setObject:[language text] forKey:@"language"];
    [dic setObject:[usage text] forKey:@"usage"];
    [dic setObject:[languageIdents objectAtIndex:[ident selectedRowInComponent:0]] forKey:@"ident"];
    
    if(activeLanguageRow)
        [arr removeObjectAtIndex:0];

    [arr addObject:dic];
    NSArray *iarr = [[NSArray alloc] initWithArray:arr];
    
    if(activeLanguageRow)
        [languages removeObjectAtIndex:activeLanguageRow.intValue];
    
    [languages addObject:iarr];
    
    [delegate didReceiveLanguage:languages];
    [self dismissModalViewControllerAnimated:YES];
    
    [iarr release];
    [arr release];
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
    currentLanguage = [languageIdents objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [languageIdents count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [languageIdents objectAtIndex:row];
}

#pragma mark - custom functions

@end
