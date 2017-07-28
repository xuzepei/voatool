//
//  RCHttpRequest.h
//
//  Created by xuzepei on 09-9-8.
//

#import <Foundation/Foundation.h>

@protocol RCHttpRequestDelegate <NSObject>
@optional
- (void) willStartHttpRequest: (id)token;
- (void) didFinishHttpRequest: (id)result token: (id)token;
- (void) didFailHttpRequest: (id)token;
- (void) updatePercentage: (float)percentage token: (id)token;
@end


@interface RCHttpRequest : NSObject {

}

@property (assign)BOOL isConnecting;
@property (nonatomic, weak)id delegate;
@property (nonatomic, strong)NSString* requestingURL;
@property (nonatomic, strong)id token;
@property (assign)long long expectedContentLength;
@property (assign)long long currentLength;
@property (nonatomic, strong)NSURLSessionDataTask* dataTask;
@property (nonatomic, strong)NSURLSessionUploadTask* uploadTask;
@property(assign)SEL resultSelector;

+ (RCHttpRequest*)sharedInstance;
- (BOOL)request:(NSString*)urlString
	   delegate:(id)delegate
 resultSelector:(SEL)resultSelector //结果返回方法,仅限一个参数
		  token:(id)token;
- (BOOL)post:(NSString*)urlString delegate:(id)delegate resultSelector:(SEL)resultSelector bodyData:(NSData*)bodyData token:(id)token;


@end
