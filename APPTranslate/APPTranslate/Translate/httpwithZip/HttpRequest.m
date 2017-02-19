//
//  HttpRequest.m
//  MSC
//
//  Created by ypzhao on 13-4-8.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "HttpRequest.h"
//#import "iFlyDebugLog.h"
@implementation HttpRequest

@synthesize connection = _connection;
@synthesize url = _url;
@synthesize timeout = _timeout;
@synthesize downloadPercent=_downloadPercent;
@synthesize delegate = _delegate;


+ (id) httpRequestWithUrl:(NSString *)url
{
    //    HttpRequest *request= [[[HttpRequest alloc] initWithUrl:url] autorelease];
    HttpRequest *request= [[HttpRequest alloc] initWithUrl:url];
    
    return request;
}


- (id) initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        
        _reciveData = [[NSMutableData alloc] init];
        
        _connection = nil;
        _totalSize = 0;
        _dlSize = 0;
        _downloadPercent=0;
        
        self.url = url;
    }
    
    return self;
}

- (void) sendData:(NSData *)data
{
    _reciveData.length=0;
    _downloadPercent=0;
    NSURL *selfURL = [NSURL URLWithString: _url];
    NSMutableURLRequest  *theRequest = [NSMutableURLRequest requestWithURL:selfURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:_timeout];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:data];
    
    NSURLConnection *URLConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    if (!URLConnection) {
//        [SPLog log:@"create URLConnection error"];
        NSLog(@"create URLConnection error");
    }
    
    _connection = URLConnection;
}

- (void) reciveData:(NSData *)data
{
    [_reciveData appendData: data];
}

- (void) cancel
{
    if(_connection)
    {
        [_connection cancel];
    }
    _reciveData.length=0;//数据清空
    _downloadPercent=0;
    
}

#pragma mark delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(_delegate)
    {
        //        [_delegate onErrorWithMsg:connection msg:error];
       
        [_delegate onErrorWithMsg:self msg:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)])
    {
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        _totalSize = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        
//        [SPLog log:@"didReceiveResponse connection=%d,_totalSize=%lf"];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self reciveData: data];
    
    _dlSize += data.length;
    
    //    [SPLog log:@"_dlSize=%lf",_dlSize];
    
    if(_delegate)
        //    if ([_delegate respondsToSelector:@selector(onDLProgress:progress:)])
    {
        if(_totalSize > 0)
        {
            //            [_delegate onDLProgress:connection progress:(int)(_dlSize*100/_totalSize)];
//            [_delegate onDLProgress:self progress:(int)(_dlSize*100/_totalSize)];
            int tmpPercent=(int)(_reciveData.length*100/_totalSize);
            if( tmpPercent > _downloadPercent ){
                _downloadPercent=tmpPercent;
                [_delegate onDLProgress:self progress:_downloadPercent];
            }

        }
    }
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_delegate)
        //    if ([_delegate respondsToSelector:@selector(onResultWithMsg:)])
    {
        //        [_delegate onResultWithData:connection data:_reciveData];
        [_delegate onResultWithData:self data:_reciveData];
    }
}

-(void) dealloc
{
    _delegate = nil;
    
    //    if(_reciveData)
    //    {
    //        [_reciveData release];
    //        _reciveData = nil;
    //    }
    
    //    [super dealloc];
}
@end
