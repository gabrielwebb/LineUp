//
//  UADeviceManager.m
//  PushTest
//
//  Created by Andy Roth on 6/16/11.
//  Copyright 2011 AKQA. All rights reserved.
//

#import "UADeviceManager.h"
#import "NSData+Base64.h"


@implementation UADeviceManager

@synthesize delegate = _delegate;
@synthesize applicationKey = _applicationKey;
@synthesize applicationSecret = _applicationSecret;

#pragma mark - Initialization

- (void) initialize
{
	
}

#pragma mark - Registration

- (void) registerDeviceToken:(NSData *)token
{
	NSString *deviceTokenString = [[[[token description]
										stringByReplacingOccurrencesOfString: @"<" withString: @""]
										stringByReplacingOccurrencesOfString: @">" withString: @""]
										stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	[self registerDeviceTokenString:deviceTokenString];
}

- (void) registerDeviceTokenString:(NSString *)token
{
	// Register the application with urban airship
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://go.urbanairship.com/api/device_tokens/%@", token]]] autorelease];
    [request setHTTPMethod:@"PUT"];
    
    // Use basic HTTP authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", _applicationKey, _applicationSecret];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
    if(connection) _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[_responseData release];
	_responseData = nil;
	
    if([_delegate respondsToSelector:@selector(manager:didFailWithError:)])
	{
		[_delegate manager:self didFailWithError:error];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *result = [[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding] autorelease];
	[_responseData release];
    _responseData = nil;
	
	if([result isEqualToString:@"OK"] || [result isEqualToString:@"Created"])
	{
		if([_delegate respondsToSelector:@selector(manager:didRegisterWithResponse:)])
		{
			[_delegate manager:self didRegisterWithResponse:result];
		}
	}
	else
	{
		if([_delegate respondsToSelector:@selector(manager:didFailWithError:)])
		{
			NSError *error = [[NSError alloc] initWithDomain:@"com.urbanairship.api" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:result, NSLocalizedDescriptionKey, nil]];
			[_delegate manager:self didFailWithError:[error autorelease]];
		}
	}
}

#pragma mark - Singleton Methods

static UADeviceManager *instance = nil;
 
+ (UADeviceManager *) sharedManager
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
        [instance initialize];
    }
    
    return instance;
}

+ (UADeviceManager *) sharedManagerWithApplicationKey:(NSString *)key applicationSecret:(NSString *)secret
{
	UADeviceManager *manager = [self sharedManager];
	manager.applicationKey = key;
	manager.applicationSecret = secret;
	
	return manager;
}
 
+ (id) allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}
 
- (id) copyWithZone:(NSZone *)zone
{
    return self;
}
 
- (id) retain
{
    return self;
}
 
- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}
 
- (oneway void) release
{

}
 
- (id) autorelease
{
    return self;
}

@end
