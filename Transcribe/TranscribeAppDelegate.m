//
//  TranscribeAppDelegate.m
//  Transcribe
//
//  Created by Patrick Heneise on 6/12/11.
//  Copyright 2011 Leiden University. All rights reserved.
//

#import "TranscribeAppDelegate.h"
#import "RootViewController.h"

#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "DatabaseManager.h"

@implementation TranscribeAppDelegate

@synthesize window;
@synthesize rootViewController;
@synthesize navigationController;
@synthesize serverURL;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize CouchDB:
    CouchbaseEmbeddedServer* cb = [[CouchbaseEmbeddedServer alloc] init];
    cb.delegate = self;
    NSAssert([cb start], @"Couchbase couldn't start! Error = %@", cb.error);
    
    // Override point for customization after application launch.
    rootViewController = [[RootViewController alloc] initWithNibName:@"RootView" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)couchbaseDidStart:(NSURL *)url {
    NSAssert(url != nil, @"Couchbase failed to initialize");
	NSLog(@"CouchDB is Ready, go!");
    self.serverURL = url;
    
    NSLog(@"Everything works!");
    
    [self couchExists];
}

-(void)isReady:(BOOL)firstTimeLaunch
{
    
    // Tell RootViewController to stop spinning
    UIViewController* vc = self.rootViewController;
    if(firstTimeLaunch)
    {
        if ([vc respondsToSelector:@selector(couchbaseDidStartForTheFirstTime:)]) {
            [self.rootViewController performSelector:@selector(couchbaseDidStartForTheFirstTime:) withObject:self.serverURL];
        }
    } 
    else 
    {
        if ([vc respondsToSelector:@selector(couchbaseDidStart:)]) {
            [self.rootViewController performSelector:@selector(couchbaseDidStart:) withObject:self.serverURL];
        }
    }
}

-(void)couchExists
{
    NSLog(@"Checking to see if the CouchDB database exists"); 
    DatabaseManager *sharedManager = [DatabaseManager 
                                      sharedManager:self.serverURL];
    //sharedManager.database.server.URLCredential = [NSURLCredential credentialWithUser: @"admin" password: @"admin" persistence:NSURLCredentialPersistenceForSession]; 
    CouchDBSuccessHandler successHandler = ^(id inParameter) { 
        NSLog(@"Database exists! %@: %@", [inParameter class], inParameter);
        [self isReady:false];
    }; 
    CouchDBFailureHandler failureHandler = ^(NSError *error) { 
        NSLog(@"Database does not exist! %@", error); 
        [self createCouch]; 
    }; 
    CURLOperation *checkDatabaseExistsOperation = 
    [sharedManager.database.server 
     operationToFetchDatabaseNamed:@"transcribe" 
     withSuccessHandler:successHandler failureHandler:failureHandler]; 
    [checkDatabaseExistsOperation start];
}

-(void)createCouch
{
    NSLog(@"Trying to create the CouchDB database"); 
    DatabaseManager *sharedManager = [DatabaseManager 
                                      sharedManager:self.serverURL]; 
    CouchDBSuccessHandler successHandler = ^(id inParameter) { 
        NSLog(@"Database created! %@: %@", [inParameter class], inParameter);
        [self isReady:true];
    }; 
    CouchDBFailureHandler failureHandler = ^(NSError *error) { 
        NSLog(@"Database could not be created! %@", error); 
        abort(); 
    }; 
    CURLOperation *createDatabaseOperation = 
    [sharedManager.database.server 
     operationToCreateDatabaseNamed:@"transcribe" 
     withSuccessHandler:successHandler failureHandler:failureHandler]; 
    [createDatabaseOperation start]; 
}

- (void)dealloc
{
    [window release];
    [rootViewController release];
    [navigationController release];
    [super dealloc];
}

@end
