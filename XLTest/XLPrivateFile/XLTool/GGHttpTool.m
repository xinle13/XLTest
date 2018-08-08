//  AF网络请求工具类
//  GGHttpTool.m
//  Created by xinle.


#import "GGHttpTool.h"

@interface GGHttpTool ()<NSURLSessionTaskDelegate>

@property (nonatomic, strong)AFHTTPSessionManager *mgr;

@end

@implementation GGHttpTool

static GGHttpTool *instance = nil;

+ (GGHttpTool *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GGHttpTool alloc] init];
    });
    return instance;
}

//此处是配置证书文件的代码,暂时没有用到 xinle 2017.06.05
+ (AFSecurityPolicy *)customSecurityPolicy
{
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"Admin" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

//返回自定义的request
+ (NSMutableURLRequest *)requestWithURLStr:(NSString *)url HTTPMethod:(NSString *)method Parameters:(id)parameters IsBase64Encode:(BOOL) isBase64Encode{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //设置请求头
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10.0];
    [request setHTTPMethod:method];
    //设置body体
    if ([parameters isKindOfClass:[NSData class]]) {
        
        [request setHTTPBody:parameters];//data数据
        
    }else if ([parameters isKindOfClass:[NSString class]]) {//字符串
        
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
        //字典
        if (isBase64Encode) {//参数字典转成base64字符串
            NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
            data = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [request setHTTPBody:data];
        }else{
            NSError *error;
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error]];
        }
    }
    return request;
}

-(AFHTTPSessionManager *)mgr{

    if (_mgr == nil) {
        // 获得请求管理者
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        //允许非权威机构颁发的证书
        mgr.securityPolicy.allowInvalidCertificates = YES;
        //不验证域名一致性
        mgr.securityPolicy.validatesDomainName = NO;
        
        ////HTTPS SSL的验证，在此处调用上面的代码，给这个证书验证；暂时不用 xinle 2017.06.05
        //[mgr setSecurityPolicy:[GGHttpTool customSecurityPolicy]];
        
        mgr.requestSerializer.timeoutInterval = 15.0;
        mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;//放开接口缓存

        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        //请求数据类型
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"charset=utf-8", nil];
        _mgr = mgr;
    }
    return _mgr;
}

- (void)dataTaskWithRequest:(NSURLRequest *) request success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{

    [[self.mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error == nil) {
            
            if (!responseObject) return ;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
            if (success) {
                success(dict);
            }
        }else{
            [self dealWithError:error];
            if (failure) {
                failure(error);
            }
        }

    }] resume];
}

//普通的get请求
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure{
    [self.mgr GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self dealWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}

//普通的POST请求
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure{
    [self.mgr POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self dealWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}

//封装的加密post请求
- (void)urlEncodePost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure {
    
    NSURLRequest *urlRequest = [GGHttpTool requestWithURLStr:url HTTPMethod:@"POST" Parameters:params IsBase64Encode:NO];
    [self dataTaskWithRequest:urlRequest success:^(id responseObj) {
        
        success(responseObj);
        
    } failure:^(NSError *error) {
        
        [self dealWithError:error];
        if (failure) {
            failure(error);
        }
    }];
    
}

-(void)dealWithError:(NSError *)error{

    NSDictionary *dict = error.userInfo;
    NSString *key = @"com.alamofire.serialization.response.error.data";
    if([[dict allKeys] containsObject:key]){
        NSData *data = dict[key];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        LOG(@"错误的16进制转化:%@",errorStr);
    }
}

#pragma mark -- session请求单独处理请求两秒超时

-(void)sessionDataTaskWithRequest:(NSURLRequest *)request success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    
    //推荐使用这种请求方法；
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            NSLog(@"返回正确：%@",data);
            if (success) {
                
                NSError *error;
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (error == nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(resultDic[@"Content"]);
                    });
                }
            }
            
        }else{
            //出现错误；
            LOG(@"错误信息：%@",error);
            [self dealWithError:error];
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(error);
                });
            }
        }
        
    }];
    
    [dataTask resume];
}

#pragma mark -----NSURLSessionTaskDelegate-----
//NSURLAuthenticationChallenge 中的protectionSpace对象存放了服务器返回的证书信息
//如何处理证书?(使用、忽略、拒绝。。)
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler//通过调用block，来告诉NSURLSession要不要收到这个证书
{
    //(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
    //NSURLSessionAuthChallengeDisposition （枚举）如何处理这个证书
    //NSURLCredential 授权
    
    //证书分为好几种：服务器信任的证书、输入密码的证书  。。，所以这里最好判断
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){//服务器信任证书
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];//服务器信任证书
        if(completionHandler)
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
    
    
    LOG(@"....completionHandler---:%@",challenge.protectionSpace.authenticationMethod);
    
}

@end
