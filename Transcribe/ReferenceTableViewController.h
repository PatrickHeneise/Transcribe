//
//  ReferenceTableViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 7/6/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReferenceTableViewController :  UITableViewController <UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
        NSArray *references;
        UISearchDisplayController *searchController;
        NSMutableArray *searchResults;
        NSString *savedSearchTerm;
        UITableView *mainTable;
    UISearchBar *searchBar;
    }

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar; 
@property (nonatomic, retain) NSArray *references;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) IBOutlet UITableView *mainTable;

- (void)handleSearchForTerm:(NSString *)searchTerm;
- (IBAction)back:(id)sender;
@end