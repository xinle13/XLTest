

#import <Foundation/Foundation.h>
#import "AFNetworking.h"



@interface GGHttpTool : NSObject

+ (GGHttpTool *)shareInstance ;

/**返回自定义的request*/
+(NSMutableURLRequest *)requestWithURLStr:(NSString *)url HTTPMethod:(NSString *)method Parameters:(id)parameters IsBase64Encode:(BOOL) isBase64Encode;

-(AFHTTPSessionManager *)mgr;

/** get */
- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure;
/** post 等效urlEncodePost: */
- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id obj))success failure:(void (^)(NSError *error))failure;

/** 处理特殊的request请求 */
-(void)dataTaskWithRequest:(NSURLRequest *) request success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/** 封装的加密post请求*/
- (void)urlEncodePost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

#pragma mark -- session请求单独处理请求两秒超时

-(void)sessionDataTaskWithRequest:(NSURLRequest *)request success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;


@end
