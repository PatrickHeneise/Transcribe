//
//  AnnotationTableViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 7/5/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnnotationTableViewController : UITableViewController <UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    NSArray *annotations;
    UISearchDisplayController *searchController;
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    UITableView *mainTable;
}

@property (nonatomic, retain) NSArray *annotations;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) IBOutlet UITableView *mainTable;

- (void)handleSearchForTerm:(NSString *)searchTerm;
- (IBAction)back:(id)sender;

@end
