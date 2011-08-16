//
//  RootViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 6/12/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCouchDBDocument;

@protocol CouchDocumentDelegate <NSObject>
- (void)saveDocument:(NSDictionary *)inDoc;
@end

@interface RootViewController : UITableViewController <UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, CouchDocumentDelegate> {
    CCouchDBDocument *doc;
    UITableView *mainTableView;
    NSMutableArray *contentsList;
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    UISearchDisplayController *searchController;
    UIActivityIndicatorView *itemLoadActivity;
    UIActivityIndicatorView *syncActivity;
    UIBarButtonItem *syncButton;
    UIBarButtonItem *syncActivityButton;
}

@property (nonatomic, retain) CCouchDBDocument *doc;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) NSURL *couchbaseURL;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, retain) UIActivityIndicatorView *itemLoadActivity;
@property (nonatomic, retain) UIActivityIndicatorView *syncActivity;
@property (nonatomic, retain) UIBarButtonItem *syncButton;
@property (nonatomic, retain) UIBarButtonItem *syncActivityButton;


-(void)loadItemsIntoView;
-(void)couchbaseDidStart:(NSURL *)serverURL;
-(void)couchbaseDidStartForTheFirstTime:(NSURL *)serverURL;
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)sync;

// synchronise activity button controls
-(void)startActivity;
-(void)stopActivity;
@end