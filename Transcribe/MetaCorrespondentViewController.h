//
//  MetaCorrespondentViewController.h
//  Transcribe
//
//  Created by Patrick Heneise on 7/9/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetaViewController.h"

@protocol ModalViewDelegate;

@interface MetaCorrespondentViewController : UITableViewController <UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
    id<ModalViewDelegate> delegate;
    UISearchDisplayController *searchController;
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    UITableView *mainTable;
    NSMutableArray *correspondentsList;
    NSString *sender;
}

@property (nonatomic, assign) id<ModalViewDelegate> delegate;
@property (nonatomic, retain) NSDictionary *correspondents;
@property (nonatomic, retain) NSMutableArray *correspondentsList;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) IBOutlet UITableView *mainTable;
@property (nonatomic, retain) NSString *sender;

- (void)handleSearchForTerm:(NSString *)searchTerm;
- (IBAction)back:(id)sender;

@end
