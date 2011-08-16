//
//  MetaCorrespondentViewController.m
//  Transcribe
//
//  Created by Patrick Heneise on 7/9/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "MetaCorrespondentViewController.h"

@implementation MetaCorrespondentViewController
@synthesize correspondents;
@synthesize searchController;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize mainTable;
@synthesize delegate;
@synthesize correspondentsList;
@synthesize sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)] autorelease];
    }
    return self;
}

- (void)dealloc
{
    [searchController release];
    [mainTable release];
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
    
    // Restore search term
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchController:nil];
    [self setMainTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // Save the state of the search UI so that it can be restored if the view is re-created.
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
    [self setSearchResults:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [correspondents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Cochin" size:16.0f]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Cochin" size:12.0f]];
    [cell.detailTextLabel setText:[[correspondentsList objectAtIndex:indexPath.row] valueForKey:@"value"]];
    [cell.textLabel setText:[[correspondentsList objectAtIndex:indexPath.row] valueForKey:@"key"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}*/

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([sender isEqualToString:@"sender"])
       [delegate didReceiveSender:[[correspondentsList objectAtIndex:indexPath.row] valueForKey:@"key"]];
    else
        [delegate didReceiveRecipient:[[correspondentsList objectAtIndex:indexPath.row] valueForKey:@"key"]];
       
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Search delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];
    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setSavedSearchTerm:nil];
	
    [[self mainTable] reloadData];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self setSavedSearchTerm:searchTerm];
	
    if ([self searchResults] == nil)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [self setSearchResults:array];
        [array release], array = nil;
    }
	
    [[self searchResults] removeAllObjects];
	
    if ([[self savedSearchTerm] length] != 0)
    {
        /*for (NSString *currentString in [self correspondentsList])
         {
         if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
         {
         [[self searchResults] addObject:currentString];
         }
         }*/
    }
}
- (IBAction)back:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) setCorrespondents:(NSDictionary *)newCorrespondents
{
    if (correspondents != newCorrespondents) {
        [correspondents release];
        correspondents = [newCorrespondents retain];        
        
        NSSortDescriptor *titleSorter= [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
        correspondentsList = [[NSMutableArray alloc] init];
        for (id key in correspondents) {
            NSMutableDictionary *tmpd = [[NSMutableDictionary alloc] initWithCapacity:2];
            [tmpd setObject:key forKey:@"key"];
            [tmpd setObject:[correspondents valueForKey:key] forKey:@"value"];
            [correspondentsList addObject:tmpd];
            [tmpd release];
        }
        [correspondentsList sortUsingDescriptors:[NSArray arrayWithObject:titleSorter]];
    }
}
@end
