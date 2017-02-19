//
//  DownloadHtmlFile.m
//  iFlySpeechPlusPhaseA
//
//  Created by wangdan on 15-1-19.
//  Copyright (c) 2015年 iFlytek. All rights reserved.
//

#import "DownloadHtmlFile.h"
#import "SSZipArchive.h"



#pragma  mark  网页zip地址和时间戳网址
#define  ZIP_RES_TEST_URL   @"http://172.16.154.106:8022/speech/html/speakersetting_download_ios.php"
#define  TIMESTAMP__TEST_RUL @"http://172.16.154.106:8022/speech/html/speakersetting_ios_modify.php"

#define  ZIP_RES_URL   @"http://iss.openspeech.cn/speech/html/speakersetting_download_ios.php"
#define  TIMESTAMP_RUL @"http://iss.openspeech.cn/speech/html/speakersetting_ios_modify.php"

#pragma mark 保存的html文件名称和文件夹名称
#define  HTML_ZIP           @"html.zip"
#define  HTML_DIRECTORY     @"htmlDirectory"


#pragma mark 时间戳key
#define TIMESTAMP_KEY       @"timekey"

#pragma mark 发送请求的字符串
#define SEND_STRING         @"hi"


#pragma mark 回调时发送的字符串
#define  SUCCESS_DOMAIN     @"ok"
#define  FAIL_DOMAIN        @"error"
#define  SUCCESS_DIC_KEY    @"result"
#define  SUCCESS_DIC_STRING @"success"
#define  FAIL_DIC_KEY       @"fail"
#define  FAIL_DIC_NET       @"neterror"
#define  FAIL_DIC_FILE      @"fileerror"
#define  SUC_DIC_TIME_KEY   @"timestamp"
#define  SUC_DIC_TIME_NEW   @"newest"





@interface DownloadHtmlFile()
{
    
    HttpRequest *ypHttpRequest;//网页下载请求
    
    HttpRequest *timestampRequest;//时间戳请求
    
    HttpRequest *ignoreRequest;//不管时间戳，绝对下载请求
    
    NSString *timestampString;//时间戳字符串
    
    NSString *htmlZipFilePath;//文件名称
    
    NSString *htmlDirectoryPath;//文件夹路径
    
}

@end

@implementation DownloadHtmlFile


-(instancetype)init
{
    self=[super init];
    if( self )
    {
        ypHttpRequest=[[HttpRequest alloc]initWithUrl:ZIP_RES_URL];
        ypHttpRequest.delegate=self;
        
        timestampRequest=[[HttpRequest alloc]initWithUrl:TIMESTAMP_RUL];
        timestampRequest.delegate=self;
        
        ignoreRequest=[[HttpRequest alloc]initWithUrl:TIMESTAMP_RUL];
        ignoreRequest.delegate=self;
        
        NSString *directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        htmlZipFilePath=[NSString stringWithFormat:@"%@/%@",directory,HTML_ZIP];
        
        htmlDirectoryPath=[NSString stringWithFormat:@"%@/%@",directory,HTML_DIRECTORY];
        
    }
    return self;
}


+(DownloadHtmlFile*)sharedHtmlDownloader
{
    
    static DownloadHtmlFile *sharedDownloader = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDownloader = [[self alloc] init];
    });
    return sharedDownloader;
    
}


#pragma  mark 下载
/**检查是否有更新
 */
-(void)checkoutToDownloadHtmlZip
{
    [timestampRequest sendData:[SEND_STRING dataUsingEncoding:NSUTF8StringEncoding]];
}



/**在UIWebView不检查并下载
 */
-(void)downloadNomaterHow
{
    [ignoreRequest sendData:[SEND_STRING dataUsingEncoding:NSUTF8StringEncoding]];
}



/**下载html.zip压缩包
 */
-(void)downloadZipRes
{
    [ypHttpRequest sendData:[SEND_STRING dataUsingEncoding:NSUTF8StringEncoding]];
}



#pragma mark 文件操作


/**删除文件
 */
-(void)removeFileAtPath:(NSString *)path
{
    if( path == nil || path.length == 0 ){
        NSLog(@"in %s,path param error",__func__);
    }
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:path] ){
        [fileManager removeItemAtPath:path error:nil];
    }
}

/**写数据到文件中
 */
-(void)writeFile:(NSData *)writedata toUri:(NSString *)uri
{
    if( uri==nil ){
        NSLog(@"fileName is nil");
        return;
    }
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:uri] == NO ){
        NSLog(@"file does not exist");
        return;
    }
    NSFileHandle *writer=[NSFileHandle fileHandleForWritingAtPath:uri ];
    [writer writeData:writedata];
    [writer closeFile];
    
}


/**创建文件
 */
-(BOOL)createFile:(NSString *)uri
{
    NSFileManager *homeFimeManager=[NSFileManager defaultManager];
    
    if( uri == nil ){
        NSLog(@"uri is nil");
        return NO;
    }

    if( [homeFimeManager fileExistsAtPath:uri] ){
        if( [homeFimeManager removeItemAtPath:uri error:nil] ){
            NSLog(@"remove file success");
        }
    }
    
    if( [homeFimeManager createFileAtPath:uri contents:nil attributes:nil] ){
        NSLog(@"create file success");
        return YES;
    }
    
    NSLog(@"create file fail");
    return NO;
}


/**创建文件夹
 */
-(BOOL)createDirectory:(NSString *)directory
{
    NSFileManager *homeFileManager=[NSFileManager defaultManager];
    if( directory == nil ){
        NSLog(@"uri is nil");
        return NO;
    }

    if( [homeFileManager fileExistsAtPath:directory]){
        if( [homeFileManager removeItemAtPath:directory error:nil] ){
            NSLog(@"remove directory Success");
        }
    }
    
    if( [homeFileManager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil] )
    {
        NSLog(@"create directory Success");
        return YES;
    }

    NSLog(@"create directory fail");
    return NO;
}




/**保存下载的数据并解压
 */
-(BOOL)saveDownloadHtmlFile:(NSData*)recievedData
{
    if( [self createFile:htmlZipFilePath] && [self createDirectory:htmlDirectoryPath] )
    {
        NSLog(@"create file and directory success");
        [self writeFile:recievedData toUri:htmlZipFilePath];
        if( [SSZipArchive unzipFileAtPath:htmlZipFilePath toDestination:htmlDirectoryPath] )
        {
            NSLog(@"save and unZip file success!");
            [self removeFileAtPath:htmlZipFilePath];//删除压缩包
            return YES;
        }
    }
    NSLog(@"save and unZip file fail!");
    return NO;
}




/**更新下载的时间戳到本地
 */
-(void)updateLocalTimestamp:(NSString *)time
{
    if( time == nil ){
        NSLog(@"in %s,timestamp is nil",__func__);
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:TIMESTAMP_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"updataLocalTimestamp success");
}



#pragma mark 调用回调返回
/**调用回调接口
 */
-(void) callDelegate:(BOOL)yesOrNot withError:(NSError*)error
{
    if( self.delegate && [self.delegate respondsToSelector:@selector(onCheckoutDownloadHtmlZip:withError:)] )
    {
        [self.delegate onCheckoutDownloadHtmlZip:yesOrNot withError:error];
    }
}



#pragma  mark  处理下载完的数据以及http 

-(void)processTimerstampRequest:(HttpRequest *)request withData:(NSData*)data
{
    NSUserDefaults *localUser=[NSUserDefaults standardUserDefaults];
    NSLog(@"data length is %ld",(unsigned long)data.length);
    if( request == timestampRequest ){//请求时间戳
        NSString *timetampLocal=[localUser objectForKey:TIMESTAMP_KEY];
        NSString *downloadTimestamp=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"local timestamp is %@,download timestamp is %@",timetampLocal,downloadTimestamp);
        
        if( [timetampLocal isEqualToString:downloadTimestamp] ){//时间戳相等
            if( [[NSFileManager defaultManager] fileExistsAtPath:htmlDirectoryPath] ){
                NSDictionary *resultDic=[[NSDictionary alloc]initWithObjectsAndKeys:SUC_DIC_TIME_NEW ,SUC_DIC_TIME_KEY, nil];
                NSError *resultError=[[NSError alloc]initWithDomain:SUCCESS_DOMAIN code:0 userInfo:resultDic];
                [self callDelegate:NO withError:resultError];//文件存在，不需要下载
            }else{
                timestampString=downloadTimestamp;//保存时间戳
                [self downloadZipRes];//时间戳存在，但是文件不存在，就需要下载
            }
        }else{
            timestampString=downloadTimestamp;
            [self downloadZipRes];//下载数据
        }
    }
}


-(void)processDownloadRequest:(HttpRequest *)request withData:(NSData*)data
{
    NSLog(@"data length is %ld",(unsigned long)data.length);
    if(  request == ypHttpRequest ){//下载资源
        if( [self saveDownloadHtmlFile:data] ){
            [self updateLocalTimestamp:timestampString];
            NSDictionary *resultDic=[[NSDictionary alloc]initWithObjectsAndKeys:SUCCESS_DIC_STRING ,SUCCESS_DIC_KEY, nil];
            NSError *resultError=[[NSError alloc]initWithDomain:SUCCESS_DOMAIN code:0 userInfo:resultDic];
            [self callDelegate:YES withError:resultError];//成功下载并更新
        }else{
            NSDictionary *resultDic=[[NSDictionary alloc]initWithObjectsAndKeys:FAIL_DIC_FILE ,FAIL_DIC_KEY, nil];
            NSError *resultError=[[NSError alloc]initWithDomain:FAIL_DOMAIN code:-1 userInfo:resultDic];
            [self callDelegate:NO withError:resultError];
        }
    }
}


-(void)processIgnoreRequest:(HttpRequest *)request withData:(NSData*)data
{
    NSLog(@"data length is %ld",(unsigned long)data.length);
    if(  request == ignoreRequest ){//下载资源
        timestampString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self downloadZipRes];//下载数据
    }
}

#pragma mark  HTTP 回调


//
//-(void) onResultWithData:(HttpRequest *)request data:(NSData*) data
//{
//    NSUserDefaults *localUser=[NSUserDefaults standardUserDefaults];
//    NSLog(@"data length is %ld",(unsigned long)data.length);
//    if( request == timestampRequest ){//请求时间戳
//        NSString *timetampLocal=[localUser objectForKey:TIMESTAMP_KEY];
//        NSString *downloadTimestamp=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"local timestamp is %@,download timestamp is %@",timetampLocal,downloadTimestamp);
//        
//        if( [timetampLocal isEqualToString:downloadTimestamp] ){//时间戳相等
//            if( [[NSFileManager defaultManager] fileExistsAtPath:htmlDirectoryPath] ){
//                NSDictionary *resultDic=[[NSDictionary alloc]initWithObjectsAndKeys:SUC_DIC_TIME_NEW ,SUC_DIC_TIME_KEY, nil];
//                NSError *resultError=[[NSError alloc]initWithDomain:SUCCESS_DOMAIN code:0 userInfo:resultDic];
//                [self callDelegate:NO withError:resultError];//文件存在，不需要下载
//            }else{
//                timestampString=downloadTimestamp;
//                [self downloadZipRes];//时间戳存在，但是文件不存在，就需要下载
//            }
//        }else{
//            timestampString=downloadTimestamp;
//            [self downloadZipRes];//下载数据
//        }
//        
//    }else if(  request == ypHttpRequest ){//下载资源
//        if( [self saveDownloadHtmlFile:data] ){
//            [self updateLocalTimestamp:timestampString];
//             NSDictionary *resultDic=[[NSDictionary alloc]initWithObjectsAndKeys:SUCCESS_DIC_STRING ,SUCCESS_DIC_KEY, nil];
//             NSError *resultError=[[NSError alloc]initWithDomain:SUCCESS_DOMAIN code:0 userInfo:resultDic];
//            [self callDelegate:YES withError:resultError];//成功下载并更新
//        }else{
//            NSDictionary *resultDic=[[NSDictionary alloc]initWithObjectsAndKeys:FAIL_DIC_FILE ,FAIL_DIC_KEY, nil];
//            NSError *resultError=[[NSError alloc]initWithDomain:FAIL_DOMAIN code:-1 userInfo:resultDic];
//            [self callDelegate:NO withError:resultError];
//        }
//    }else if( request == ignoreRequest ){//绝对下载请求
//        NSString *timetampLocal=[localUser objectForKey:TIMESTAMP_KEY];
//        NSString *downloadTimestamp=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"local timestamp is %@,download timestamp is %@",timetampLocal,downloadTimestamp);
//
//        timestampString=downloadTimestamp;
//        [self downloadZipRes];//下载数据
//    }
//}



-(void) onDLProgress:(HttpRequest *)request progress:(int) progress
{
    NSLog(@"in DownloadHtmlFile.m downloadProgress is %d",progress);
}


-(void) onResultWithData:(HttpRequest *)request data:(NSData*) data
{
     if( request == timestampRequest ){//请求时间戳
         [self processTimerstampRequest:request withData:data];
     }else if( request == ignoreRequest ){//强制下载
         [self processIgnoreRequest:request withData:data];
     }else if( request == ypHttpRequest ){//请求下载html压缩包
         [self processDownloadRequest:request withData:data];
     }
}

-(void) onErrorWithMsg:(HttpRequest *)request msg:(NSError*) msg
{
    NSLog(@"in DownloadHtmlFile.m %s,error is %ld",__func__,(long)msg.code);
    if( request == timestampRequest ){
        NSLog(@"download timestmp fail,error is %d",msg.code);
    }else if( request == ypHttpRequest ){
        NSLog(@"download htmlFile fail,error is %d",msg.code);
    }
    
    NSDictionary *resultDic=[[NSDictionary alloc] initWithObjectsAndKeys:FAIL_DIC_NET ,FAIL_DIC_KEY, nil];
    NSError *resultError=[[NSError alloc]initWithDomain:FAIL_DOMAIN code:-1 userInfo:resultDic];
    [self callDelegate:NO withError:resultError];
    
}





@end
