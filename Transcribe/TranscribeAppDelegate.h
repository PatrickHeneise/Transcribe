//
//  TranscribeAppDelegate.h
//  Transcribe
//
//  Created by Patrick Heneise on 6/12/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Couchbase/CouchbaseEmbeddedServer.h>

@class RootViewController;

@interface TranscribeAppDelegate : NSObject <UIApplicationDelegate, CouchbaseDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain)NSURL *serverURL;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

-(void)isReady:(BOOL)firstTimeLaunch;
-(void)createCouch;
-(void)couchExists;
@end
