//
//  RCHttpRequest.m
//
//  Created by xuzepei on 09-9-8.
//

#import "RCHttpRequest.h"
#import <UIKit/UIKit.h>

@implementation RCHttpRequest

+ (RCHttpRequest*)sharedInstance
{
    static RCHttpRequest* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RCHttpRequest alloc] init];
    });

    return sharedInstance;
}

- (id)init
{
	if(self = [super init])
	{
		_isConnecting = NO;
		_expectedContentLength = 0;
		_currentLength = 0;
	}
	
	return self;
}

- (void)dealloc
{
	self.isConnecting = NO;
    self.requestingURL = nil;
    self.token = nil;
	self.dataTask = nil;
    self.uploadTask = nil;
}

- (BOOL)request:(NSString*)urlString delegate:(id)delegate resultSelector:(SEL)resultSelector token:(id)token
{
    if(0 == [urlString length] || _isConnecting)
        return NO;
    
    self.resultSelector = resultSelector;
	self.delegate = delegate;
	self.token = token;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	self.requestingURL = urlString;
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval: 20];
	[request setHTTPShouldHandleCookies:FALSE];
	[request setHTTPMethod:@"GET"];
    
    NSLog(@"request:%@",_requestingURL);
	
    _isConnecting = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSession *session = [NSURLSession sharedSession];
    self.dataTask = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      self.dataTask = nil;
                                      _isConnecting = NO;
                                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                      
                                      [self connectionDidFinish:data response:response error:error];
                                  }];
    
    [self.dataTask resume];
    
    return YES;
}


- (BOOL)post:(NSString*)urlString delegate:(id)delegate resultSelector:(SEL)resultSelector bodyData:(NSData*)bodyData token:(id)token
{
    if(0 == [urlString length] || _isConnecting || nil == bodyData)
        return NO;
    
    self.resultSelector = resultSelector;
	self.delegate = delegate;
	self.token = token;
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	self.requestingURL = urlString;
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	[request setURL:[NSURL URLWithString: urlString]];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval: 20];
	[request setHTTPShouldHandleCookies:FALSE];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"VOALearningEnglish/4.1 CFNetwork/808.2.16 Darwin/16.3.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"N4jte0H8NFatSrLVWtzTYQhkbK1NnGdOBRXtAcgU" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request setValue:@"YQAlXs7tHEea8VKnvB9FMXfeE6EGFp9drubcIiey" forHTTPHeaderField:@"X-Parse-Client-Key"];
    [request setValue:@"97a20e63-9fda-4a8a-98ec-92062035576d" forHTTPHeaderField:@"X-Parse-Installation-Id"];
    
	[request setHTTPMethod:@"POST"];
    
    NSLog(@"post:%@",_requestingURL);

    _isConnecting = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSession *session = [NSURLSession sharedSession];
    self.uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:bodyData
                                                      completionHandler:
                                          ^(NSData *data, NSURLResponse *response, NSError *error) {
                                              
                                              self.uploadTask = nil;
                                              _isConnecting = NO;
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                              
                                              [self connectionDidFinish:data response:response error:error];
                                          }];
    [self.uploadTask resume];
    
    return YES;
}

- (void)connectionDidFinish:(NSData*)data response:(NSURLResponse*)response error:(NSError*)error
{
    long statusCode = 0;
    if(response)
    {
        statusCode = (long)[(NSHTTPURLResponse*)response statusCode];
        NSLog(@"connectionDidFinish:%ld", statusCode);
    }
    
	if(200 == statusCode)
	{
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if(_resultSelector && [_delegate respondsToSelector:_resultSelector])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            if(0 == [jsonString length])
                jsonString = @"";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.token)
                {
                    NSDictionary* dict = @{@"json":jsonString,
                                           @"token":self.token};
                    [_delegate performSelector:_resultSelector withObject:dict];
                }
                else
                {
                    [_delegate performSelector:_resultSelector withObject:jsonString];
                }
            });

#pragma clang diagnostic pop
        }
        
	}
	else
	{
        if(error)
        {
            NSLog(@"connectionDidFinishWithError:%@",[error localizedDescription]);
        }
        
        if(_resultSelector && [_delegate respondsToSelector:_resultSelector])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [_delegate performSelector:_resultSelector withObject:nil];
#pragma clang diagnostic pop
            });
        }
	}
}


@end
