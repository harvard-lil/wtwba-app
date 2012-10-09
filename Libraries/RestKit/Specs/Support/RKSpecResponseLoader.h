//
//  RKSpecResponseLoader.h
//  RestKit
//
//  Created by Blake Watters on 1/14/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectLoader.h"

@interface RKSpecResponseLoader : NSObject <RKObjectLoaderDelegate> {
	BOOL _awaitingResponse;
	BOOL _success;
	id _response;
	NSError* _failureError;
	NSString* _errorMessage;
	NSTimeInterval _timeout;
}

// The object that was loaded from the web request
@property (nonatomic, readonly) id response;

// True when the response is success
@property (nonatomic, readonly) BOOL success;

// The error that was returned from a failure to connect
@property (nonatomic, readonly) NSError* failureError;

// The error message returned by the server
@property (nonatomic, readonly) NSString* errorMessage;

@property (nonatomic, assign)	NSTimeInterval timeout;

// Wait for a response to load
- (void)waitForResponse;
- (void)loadResponse:(id)response;

@end
