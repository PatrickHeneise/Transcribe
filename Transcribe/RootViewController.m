//
//  RootViewController.m
//  Transcribe
//
//  Created by Patrick Heneise on 6/12/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "RootViewController.h"
#import "DetailContentController.h"
#import "DatabaseManager.h"
#import "CCouchDBDesignDocument.h"
#import "CCouchDBDatabase.h"

@implementation RootViewController

@synthesize doc;
@synthesize mainTableView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize couchbaseURL;
@synthesize searchController;
@synthesize itemLoadActivity;
@synthesize syncActivity;
@synthesize syncButton;
@synthesize syncActivityButton;

- (void)dealloc
{
    [mainTableView release], mainTableView = nil;
    [contentsList release], contentsList = nil;
    [searchResults release], searchResults = nil;
    [savedSearchTerm release], savedSearchTerm = nil;
    
    [searchController release];
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
    self.title = @"Transcribe";
    
    // Restore search term
    if ([self savedSearchTerm])
    {
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }

    // item loader activity
    itemLoadActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    itemLoadActivity.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [itemLoadActivity hidesWhenStopped];
    [itemLoadActivity startAnimating];
    [self.view addSubview:itemLoadActivity];
    
    // sync activity
    syncActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [syncActivity startAnimating];
    [syncActivity hidesWhenStopped];
    syncActivityButton = [[UIBarButtonItem alloc] initWithCustomView:syncActivity];
    [syncActivity release];
    self.navigationItem.rightBarButtonItem = syncActivityButton;
    
    syncButton = [[UIBarButtonItem alloc] initWithTitle:@"Synchronize" style:UIBarButtonItemStylePlain target:self action:@selector(sync)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // Save the state of the search UI so that it can be restored if the view is re-created.
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
    [self setSearchResults:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"Transcribe"];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setTitle:@"List"];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
	
    if (tableView == [[self searchDisplayController] searchResultsTableView])
        rows = [[self searchResults] count];
    else
        rows = [[self contentsList] count];
	
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString *callno = @"";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell.
    CCouchDBDocument *cellDoc = [self.contentsList objectAtIndex:indexPath.row];
    NSMutableArray *idnos = [cellDoc mutableArrayValueForKeyPath:@"content.header.publicationStmt.idno"];
    
    for (int i = 0; i < [idnos count]; i++) {
        CALayer *idno = (CALayer *)[idnos objectAtIndex:i];
        if ([[idno valueForKey:@"type"] isEqualToString:@"callNo"]) {
            callno = [idno valueForKey:@"content"];
        }
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Cochin" size:16.0f]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Cochin" size:12.0f]];
   	[cell.textLabel setText:callno];
    [cell.detailTextLabel setText:[cellDoc valueForKeyPath:@"content.header.sourceDesc.biblFull.titleStmt.title"]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

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
    NSLog(@"Switch to detail");
    CCouchDBDocument *selectedObject = [self.contentsList objectAtIndex:indexPath.row];
    doc = selectedObject;
    DetailContentController *detailContentController = [[DetailContentController alloc] initWithNibName:@"DetailContent" bundle:nil];
    [detailContentController setDoc: selectedObject.content];
    [detailContentController setDocumentDelegate:self];
    [self.view addSubview:detailContentController.view];
    [self.navigationController pushViewController:detailContentController animated:YES];
    [detailContentController release];
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
        /*for (NSString *currentString in [self contentsList])
        {
            if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [[self searchResults] addObject:currentString];
            }
        }*/
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];
    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setSavedSearchTerm:nil];
	
    [[self mainTableView] reloadData];
}

#pragma mark - Custom Functions
-(void)couchbaseDidStart:(NSURL *)serverURL
{
    NSLog(@"rootViewController - CouchDB did start. Server URL %@",serverURL);
	self.couchbaseURL = serverURL;
    [syncActivity stopAnimating];
    self.navigationItem.rightBarButtonItem = syncButton;
    [self loadItemsIntoView];
}
-(void)couchbaseDidStartForTheFirstTime:(NSURL *)serverURL
{
    NSLog(@"rootViewController - CouchDB did start for the first time. Server URL %@",serverURL);
	self.couchbaseURL = serverURL;
    [syncActivity stopAnimating];
    self.navigationItem.rightBarButtonItem = syncButton;
    [self loadItemsIntoView];
    [self sync];
}

-(void)loadItemsIntoView 
{
	DatabaseManager *sharedManager = [DatabaseManager sharedManager:self.couchbaseURL];
	CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
        //		NSLog(@"RVC Wooohooo! %@: %@", [inParameter class], inParameter);
		self.contentsList = inParameter;
		[self.tableView reloadData];
	};
	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
		NSLog(@"RVC D'OH! %@", error);
	};
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"descending", @"true", @"include_docs", nil];
	CURLOperation *op = [sharedManager.database operationToFetchAllDocumentsWithOptions:options withSuccessHandler:inSuccessHandler failureHandler:inFailureHandler];
	[op start];

    
   /*DatabaseManager *sharedManager = [DatabaseManager sharedManager:self.couchbaseURL];
    CCouchDBDesignDocument *dd = [[CCouchDBDesignDocument alloc] initWithDatabase:sharedManager.database identifier:@"titles"];
    CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
        NSLog(@"RVC Wooohooo! %@: %@", [inParameter class], inParameter);
		self.contentsList = inParameter;
		[self.tableView reloadData];
	};
	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
		NSLog(@"RVC D'OH! %@", error);
	};
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"descending", @"true", @"include_docs", nil];
    CURLOperation *op = [dd operationToFetchViewNamed:@"Titles" options:options withSuccessHandler:inSuccessHandler failureHandler:inFailureHandler];
    [op start];*/
    
    [itemLoadActivity stopAnimating];
    [self stopActivity];
}

-(void)sync
{
    self.navigationItem.rightBarButtonItem = syncActivityButton;
    [itemLoadActivity startAnimating];
    contentsList = nil;
    [self.tableView reloadData];
    [self startActivity];
    
	DatabaseManager *manager = [DatabaseManager sharedManager:self.couchbaseURL];
	DatabaseManagerSuccessHandler successHandler = ^() {
  	    //woot	
		NSLog(@"success handler called!");
        [self loadItemsIntoView];
        [self stopActivity];
        self.navigationItem.rightBarButtonItem = syncButton;
	};
    
	DatabaseManagerErrorHandler errorHandler = ^(id error) {
		NSLog(@"error handler called! %@", error);
	};
	
    [manager syncFrom:@"http://transcribe.iriscouch.com/transcribe" to:[NSString 
                                                              stringWithFormat:@"http://127.0.0.1:%d/transcribe", 
                                                              [[self.couchbaseURL port] intValue]] onSuccess:successHandler 
              onError:errorHandler]; 
    
	[manager syncFrom:@"transcribe" to:@"http://transcribe:ebircsnart@transcribe.iriscouch.com/transcribe" onSuccess:^() {} onError:^(id error) {}];
}

-(void)startActivity
{
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
}

-(void)stopActivity
{
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
}

#pragma mark delegate
- (void)saveDocument:(NSDictionary *)inDoc
{
    DatabaseManager *manager = [DatabaseManager sharedManager:self.couchbaseURL];
    doc.content = inDoc;
    [manager updateDocument:doc];
}
@end
