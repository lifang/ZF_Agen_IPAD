//
//  NetworkInterface.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NetworkInterface.h"
#import "EncryptHelper.h"

static NSString *HTTP_POST = @"POST";
static NSString *HTTP_GET  = @"GET";

@implementation NetworkInterface

#pragma mark - 公用方法
// 热卖
+ (void)hotget:(NSString *)tolen
      finished:(requestDidFinished)finish
{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_hot_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_POST
                        finished:finish];
}
+ (void)requestWithURL:(NSString *)urlString
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)method
              finished:(requestDidFinished)finish {
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:method
                                                                finished:finish];
//    NSLog(@"url = %@,params = %@",urlString,params);
    if ([method isEqualToString:HTTP_POST] && params)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:postData];
    }
    [request start];
}

#pragma mark - 接口方法
+ (void)getGoodImageWithGoodID:(NSString *)goodID
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodImage_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//1.
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         isAlreadyEncrypt:(BOOL)encrypt
                 finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:username forKey:@"username"];
    NSString *encryptPassword = password;
    if (!encrypt) {
        encryptPassword = [EncryptHelper MD5_encryptWithString:password];
    }
    [paramDict setObject:encryptPassword forKey:@"password"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_login_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//2.
+ (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
            isAlreadyEncrypt:(BOOL)encrypt
                   agentType:(AgentType)agentType
                 companyName:(NSString *)companyName
                   licenseID:(NSString *)licenseID
                       taxID:(NSString *)taxID
             legalPersonName:(NSString *)legalPersonName
               legalPersonID:(NSString *)legalPersonID
                mobileNumber:(NSString *)mobileNumber
                       email:(NSString *)email
                      cityID:(NSString *)cityID
               detailAddress:(NSString *)address
               cardImagePath:(NSString *)cardImagePath
            licenseImagePath:(NSString *)licenseImagePath
                taxImagePath:(NSString *)taxImagePath
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:username forKey:@"username"];
    NSString *encryptPassword = password;
    if (!encrypt) {
        encryptPassword = [EncryptHelper MD5_encryptWithString:password];
    }
    [paramDict setObject:encryptPassword forKey:@"password"];
    [paramDict setObject:[NSNumber numberWithInt:agentType] forKey:@"types"];
    if (agentType == AgentTypeCompany) {
        if (companyName) {
            [paramDict setObject:companyName forKey:@"companyName"];
        }
        if (licenseID) {
            [paramDict setObject:licenseID forKey:@"businessLicense"];
        }
        if (taxID) {
            [paramDict setObject:taxID forKey:@"taxRegisteredNo"];
        }
        if (licenseImagePath) {
            [paramDict setObject:licenseImagePath forKey:@"licenseNoPicPath"];
        }
        if (taxImagePath) {
            [paramDict setObject:taxImagePath forKey:@"taxNoPicPath"];
        }
    }
    if (legalPersonName) {
        [paramDict setObject:legalPersonName forKey:@"name"];
    }
    if (legalPersonID) {
        [paramDict setObject:legalPersonID forKey:@"cardId"];
    }
    if (mobileNumber) {
        [paramDict setObject:mobileNumber forKey:@"phone"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"email"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    if (cardImagePath) {
        [paramDict setObject:cardImagePath forKey:@"cardIdPhotoPath"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_register_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//4.
+ (void)sendValidateWithMobileNumber:(NSString *)mobileNumber
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (mobileNumber) {
        [paramDict setObject:mobileNumber forKey:@"codeNumber"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_sendRegisterValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

+ (void)sendFindValidateWithMobileNumber:(NSString *)mobileNumber
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (mobileNumber) {
        [paramDict setObject:mobileNumber forKey:@"codeNumber"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_sendValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//5.
+ (void)sendEmailValidateWithEmail:(NSString *)email
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (email) {
        [paramDict setObject:email forKey:@"codeNumber"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_emailValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//6.
+ (void)findPasswordWithUsername:(NSString *)username
                        password:(NSString *)password
                    validateCode:(NSString *)validateCode
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (username) {
        [paramDict setObject:username forKey:@"username"];
    }
    if (password) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:password] forKey:@"password"];
    }
    if (validateCode) {
        [paramDict setObject:validateCode forKey:@"code"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_findPassword_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//7.
+ (void)uploadRegisterImageWithImage:(UIImage *)image
                            finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_uploadRegisterImage_method];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    [request uploadImageData:UIImagePNGRepresentation(image)
                   imageName:nil
                         key:@"img"];
    [request start];
}
//8.
+ (void)getApplyListWithToken:(NSString *)token
                      agentId:(NSString *)agentId
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//9
+ (void)searchApplyListWithToken:(NSString *)token
                         agentId:(NSString *)agentId
                            page:(int)page
                            rows:(int)rows
                       serialNum:(NSString *)serialNum
                        finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [paramDict setObject:serialNum forKey:@"serialNum"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_searchapplyList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}




//10.
+ (void)beginToApplyWithToken:(NSString *)token
                      agentId:(NSString *)agentId
                  applyStatus:(OpenApplyType)applyStatus
                   terminalId:(NSString *)terminalId
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[terminalId intValue]] forKey:@"terminalsId"];
    [paramDict setObject:[NSNumber numberWithInt:applyStatus] forKey:@"status"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_Intoapply_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//11
+ (void)getMerchantDetailWithToken:(NSString *)token
                    merchantId:(NSString *)merchantId
                    finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[merchantId intValue]] forKey:@"merchantId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_getMerchant_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}


//12.
+ (void)getChannelsWithToken:(NSString *)token
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_getChannels_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//13.
+ (void)chooseBankWithToken:(NSString *)token
                    keyword:(NSString *)keyword
                       page:(int)page
                   pageSize:(int)pageSize
                 terminalId:(NSString *)terminalId
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    if (keyword) {
        [paramDict setObject:keyword forKey:@"keyword"];
    }
    //[paramDict setObject:[NSNumber numberWithInt:[terminalId intValue]] forKey:@"terminalId"];
     if (terminalId) {
    [paramDict setObject:terminalId forKey:@"terminalId"];
     }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_chooseBank_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


//14
+ (void)getMaterinalNameWithToken:(NSString *)token
                       terminalId:(NSString *)terminalId
                           status:(int)status
                         finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[terminalId intValue]] forKey:@"terminalsId"];
    [paramDict setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applySubmit_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}



//15
+ (void)submitApplyWithToken:(NSString *)token
                      params:(NSArray *)paramList
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:paramList forKey:@"paramMap"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applySubmit_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    }

//16.
+ (void)uploadImageWithImage:(UIImage *)image
                  terminalId:(NSString *)terminalId
                    finished:(requestDidFinished)finish {
    //url
    //NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_uploadApplyImage_method,terminalId];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d",kServiceURL,s_uploadApplyImage_method,[terminalId intValue]];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    [request uploadImageData:UIImagePNGRepresentation(image)
                   imageName:nil
                         key:@"img"];
    [request start];
}

//17
+ (void)getTerminalDetailsWithToken:(NSString *)token
                         terminalId:(NSString *)terminalId
                           finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[terminalId intValue]] forKey:@"terminalId"];
   
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_termainlDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}

//18.
+ (void)getMerchantListWithToken:(NSString *)token
                      terminalID:(NSString *)terminalID
                         keyword:(NSString *)merchantName
                            page:(int)page rows:(int)rows
                        finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[terminalID intValue]] forKey:@"terminalId"];
    if (merchantName) {
        [paramDict setObject:merchantName forKey:@"title"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_merchantList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

+ (void)getMerchantListWithToken:(NSString *)token
                          terminalId:(NSString *)terminalId
                              page:(int)page
                              rows:(int)rows
                           title:(NSString *)title
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[terminalId intValue]] forKey:@"terminalId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [paramDict setObject:title forKey:@"title"];
    
       //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_merchantList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


//19.

+ (void)getTerminalManagerListWithToken:(NSString *)token
                                agentID:(NSString *)agentId
                                   page:(int)page
                                   rows:(int)rows
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//20
+ (void)searchApplyListWithToken:(NSString *)token
                         agentID:(NSString *)agentId
                            page:(int)page
                            rows:(int)rows
                       serialNum:(NSString *)serialNum
                        finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [paramDict setObject:serialNum forKey:@"serialNum"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalSearch_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];



}


//21.

+ (void)getTerminalStatusListWithToken:(NSString *)token
                               agentID:(NSString *)agentId
                                  page:(int)page
                                  rows:(int)rows
                                status:(int)status
                              finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [paramDict setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalStatus_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//21
+ (void)searchTerminalsListWithToken:(NSString *)token
                               agentID:(NSString *)agentId
                                  page:(int)page
                                  rows:(int)rows
                                serialNum:(NSString*)serialNum
                              finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    [paramDict setObject:serialNum forKey:@"serialNum"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalStatus_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


//22.

+ (void)getTerminalDetailWithToken:(NSString *)token
                       terminalsId:(NSString *)terminalsId
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[terminalsId intValue]] forKey:@"terminalsId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalDetails_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//23
+ (void)getApplyDetailsWithToken:(NSString *)token
                      customerId:(NSString *)customerId
                     terminalsId:(NSString *)terminalsId
                          status:(int)status
                        finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[customerId intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[terminalsId intValue]] forKey:@"terminalsId"];
    [paramDict setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_getapply_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}

//24
+ (void)getTerminalSynchronousWithToken:(NSString *)token
                            terminalId:(NSString *)terminalId
                               finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[terminalId intValue]] forKey:@"terminalId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalsynchronous_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//25.
+ (void)sendBindingValidateWithMobileNumber:(NSString *)mobileNumber
                                   finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (mobileNumber) {
        [paramDict setObject:mobileNumber forKey:@"codeNumber"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addUserValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//25
+ (void)getUserTerminalListWithtoken:(NSString *)token
                          customerId:(NSString *)customerId
                                page:(int)page
                                rows:(int)rows
                            finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[customerId intValue]]forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalgetMerchants_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}



//26.
+ (void)addUserWithtoken:(NSString *)token
                     AgentId:(NSString *)agentId
                  username:(NSString *)name
                  password:(NSString *)password
                codeNumber:(NSString *)codeNumber
                    cityId:(NSString *)cityId
                    code:(NSString *)code
                  finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    if (name) {
        [paramDict setObject:name forKey:@"name"];
    }
    if (password) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:password] forKey:@"password"];
       // [paramDict setObject:password forKey:@"password"];
    }
    if (codeNumber) {
        [paramDict setObject:codeNumber forKey:@"codeNumber"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[cityId intValue]] forKey:@"cityId"];
    //[paramDict setObject:[NSNumber numberWithInt:[code intValue]] forKey:@"code"];
    [paramDict setObject:code forKey:@"code"];
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addUser_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//27.
+ (void)addUserWithtoken:(NSString *)token
                   phoneyanzheng:(NSString*)phoneyangzheng
                 AgentId:(NSString *)agentId
                username:(NSString *)name
                password:(NSString *)password
              codeNumber:(NSString *)codeNumber
                  cityId:(NSString *)cityId
                finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    if (name) {
        [paramDict setObject:name forKey:@"name"];
    }
    if (password) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:password] forKey:@"password"];
    }
    if (codeNumber) {
        [paramDict setObject:codeNumber forKey:@"code"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[cityId intValue]] forKey:@"cityId"];
    [paramDict setObject:phoneyangzheng forKey:@"codeNumber"];

    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addUser_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}



//26
+ (void)bindingTerminalWithtoken:(NSString *)token
                         AgentId:(NSString *)agentId
                    terminalsNum:(NSString *)terminalsNum
                          userId:(NSString *)userId
                        finished:(requestDidFinished)finish{

    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:terminalsNum forKey:@"terminalsNum"];
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];

    [paramDict setObject:[NSNumber numberWithInt:[userId intValue]] forKey:@"userId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_bindingterminal_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}

//26
+ (void)findPOSpwdWithtoken:(NSString *)token
                 terminalid:(NSString *)terminalid
                   finished:(requestDidFinished)finish{


    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    //[paramDict setObject:terminalid forKey:@"terminalid"];
    [paramDict setObject:[NSNumber numberWithInt:[terminalid intValue]] forKey:@"terminalid"];
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_findPOSpwd_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];



}





//27
+ (void)batchTerminalNumWithtoken:(NSString *)token
                          agentId:(NSString *)agentId
                     serialNum:(NSArray *)serialNum
                         finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    [paramDict setObject:serialNum forKey:@"serialNum"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_batchterminalnum_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}
//28
+ (void)screeningTerminalNumWithtoken:(NSString *)token
                              agentId:(NSString *)agentId
                             POStitle:(NSString *)POStitle
                           channelsId:(int)channelsId
                             minPrice:(int)minPrice
                             maxPrice:(int)maxPrice
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    if (agentId) {
     [paramDict setObject:[NSNumber numberWithInt:[agentId intValue]] forKey:@"agentId"];
    }
    if (POStitle) {
    [paramDict setObject:POStitle forKey:@"title"];
    }
    if (channelsId) {
    [paramDict setObject:[NSNumber numberWithInt:channelsId] forKey:@"channelsId"];
    }
    if (minPrice>0) {
     [paramDict setObject:[NSNumber numberWithInt:minPrice] forKey:@"minPrice"];
    }
    if (maxPrice>0) {
    [paramDict setObject:[NSNumber numberWithInt:maxPrice] forKey:@"maxPrice"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_screeningterminalnum_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
    
}

//29
+ (void)screeningPOSNameWithtoken:(NSString *)token
                           customerId:(NSString *)customerId
                             finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
  
    [paramDict setObject:[NSNumber numberWithInt:[customerId intValue]] forKey:@"customerId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_screeningPOSnum_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];



}

//30
+ (void)getchannelsWithtoken:(NSString *)token
                    finished:(requestDidFinished)finish{

    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_getChannels_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}

//31
+ (void)getAddresseeWithtoken:(NSString *)token
                   customerId:(NSString *)customerId
                     finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    
    [paramDict setObject:[NSNumber numberWithInt:[customerId intValue]] forKey:@"customerId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_getAddressee_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//32
+ (void)submitAgentWithtoken:(NSString *)token
                   customerId:(NSString *)customerId
            terminalsQuantity:(int)terminalQuantity
                      address:(NSString *)address
                       reason:(NSString *)reason
                terminalsList:(NSString *)terminalsList
                      reciver:(NSString *)reciver
                        phone:(NSString *)phone
                     finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (token && ![token isEqualToString:@""]) {
        [paramDict setObject:token forKey:@"token"];
    }
    
    [paramDict setObject:[NSNumber numberWithInt:[customerId intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:terminalQuantity]forKey:@"terminalsQuantity"];
    /*
    [paramDict setObject:address forKey:@"address"];
    [paramDict setObject:reason forKey:@"reason"];
    [paramDict setObject:terminalsList forKey:@"terminalsList"];
    [paramDict setObject:reciver forKey:@"reciver"];
    [paramDict setObject:phone forKey:@"phone"];
     */
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    if (reciver) {
        [paramDict setObject:reciver forKey:@"reciver"];
    }
    if (phone) {
        [paramDict setObject:phone forKey:@"phone"];
    }
    if (reason) {
        [paramDict setObject:reason forKey:@"reason"];
    }
    if (terminalsList) {
        [paramDict setObject:terminalsList forKey:@"terminalsList"];
    }

    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_submitAgent_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];


}

//32.
+ (void)submitAfterSaleApplyWithUserID:(NSString *)userID
                                 token:(NSString *)token
                         terminalCount:(NSInteger)count
                               address:(NSString *)address
                              receiver:(NSString *)receiver
                           phoneNumber:(NSString *)phoneNumber
                                reason:(NSString *)reason
                          terminalList:(NSString *)terminalList
                              finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInteger:count] forKey:@"terminalsQuantity"];
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    if (receiver) {
        [paramDict setObject:receiver forKey:@"reciver"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"phone"];
    }
    if (reason) {
        [paramDict setObject:reason forKey:@"reason"];
    }
    if (terminalList) {
        [paramDict setObject:terminalList forKey:@"terminalsList"];
    }
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_submitAgent_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}




//31.
+ (void)getUserListWithAgentID:(NSString *)agentID
                         token:(NSString *)token
                          page:(int)page
                          rows:(int)rows
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_userList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//32.
+ (void)deleteUserWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                      userIDs:(NSArray *)userIDs
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (userIDs) {
        [paramDict setObject:userIDs forKey:@"customerArrayId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_userDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


//33.
+ (void)getUserTerminalListWithUserID:(NSString *)userID
                                token:(NSString *)token
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (userID) {
        [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_userTerminal_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//34.
+ (void)getGoodSearchInfoWithCityID:(NSString *)cityID
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodSearch_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//35.
+ (void)getGoodListWithCityID:(NSString *)cityID
                      agentID:(NSString *)agentID
                   supplyType:(SupplyGoodsType)supplyType
                     sortType:(OrderFilter)filterType
                      brandID:(NSArray *)brandID
                     category:(NSArray *)category
                    channelID:(NSArray *)channelID
                    payCardID:(NSArray *)cardID
                      tradeID:(NSArray *)tradeID
                       slipID:(NSArray *)slipID
                         date:(NSArray *)date
                     maxPrice:(CGFloat)maxPrice
                     minPrice:(CGFloat)minPrice
                      keyword:(NSString *)keyword
                     onlyRent:(BOOL)rent
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:supplyType] forKey:@"type"];
    if (filterType != OrderFilterNone) {
        [paramDict setObject:[NSNumber numberWithInt:filterType] forKey:@"orderType"];
    }
    if (brandID) {
        [paramDict setObject:brandID forKey:@"brandsId"];
    }
    if (category) {
        if(category.count>0)
        {
            [paramDict setObject:[category objectAtIndex:0] forKey:@"category"];
            
            
        }    }
    if (channelID) {
        [paramDict setObject:channelID forKey:@"payChannelId"];
    }
    if (cardID) {
        [paramDict setObject:cardID forKey:@"payCardId"];
    }
    if (tradeID) {
        [paramDict setObject:tradeID forKey:@"tradeTypeId"];
    }
    if (slipID) {
        [paramDict setObject:slipID forKey:@"saleSlipId"];
    }
    if (date) {
        [paramDict setObject:date forKey:@"tDate"];
    }
    if (maxPrice >= 0) {
        [paramDict setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
    }
    if (minPrice >= 0) {
        [paramDict setObject:[NSNumber numberWithFloat:minPrice] forKey:@"minPrice"];
    }
    if (keyword) {
        [paramDict setObject:keyword forKey:@"keys"];
    }
    [paramDict setObject:[NSNumber numberWithInt:rent] forKey:@"hasLease"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//36.
+ (void)getGoodDetailWithCityID:(NSString *)cityID
                        agentID:(NSString *)agentID
                         goodID:(NSString *)goodID
                     supplyType:(SupplyGoodsType)supplyType
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    [paramDict setObject:[NSNumber numberWithInt:supplyType] forKey:@"type"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+ (void)getTradeDetailWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                          tradeID:(NSString *)tradeID
                        hasProfit:(int)profit
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (tradeID) {
        [paramDict setObject:[NSNumber numberWithInt:[tradeID intValue]] forKey:@"id"];
    }
    [paramDict setObject:[NSNumber numberWithInt:profit] forKey:@"isHaveProfit"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//37.
+ (void)getTradeRecordid:(NSString *)isHaveProfit
                 agentID:(NSString *)agentID
           tradeRecordId:(NSString *)tradeRecordId
                finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[isHaveProfit intValue]] forKey:@"isHaveProfit"];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:[tradeRecordId intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_TradeRecord];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//38.
+ (void)getTradeStatistics:(NSString *)tradeTypeId
                 agentID:(NSString *)agentID
           tradeRecordId:(NSString *)sonagentId
            terminalNumber:(NSString *)terminalNumber
                 startTime:(NSString *)startTime
                   endTime:(NSString *)endTime
                   isHaveProfit:(NSString *)isHaveProfit
                finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[tradeTypeId intValue]] forKey:@"tradeTypeId"];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:[sonagentId intValue]] forKey:@"sonagentId"];
    [paramDict setObject:terminalNumber forKey:@"terminalNumber"];
    [paramDict setObject:endTime forKey:@"endTime"];
    [paramDict setObject:startTime forKey:@"startTime"];
    [paramDict setObject:[NSNumber numberWithInt:[isHaveProfit intValue]] forKey:@"isHaveProfit"];

    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_TradeStatistics];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//40.
+ (void)getStockListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//40.
+ (void)getChannelDetailWithToken:(NSString *)token
                        channelID:(NSString *)channelID
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (channelID) {
        [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"pcid"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_channelDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


//41.
+ (void)getCommentListWithToken:(NSString *)token
                         goodID:(NSString *)goodID
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (goodID) {
        [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_commentList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//41.
+ (void)renameStockGoodWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                            goodID:(NSString *)goodID
                          goodName:(NSString *)goodName
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    if (goodName) {
        [paramDict setObject:goodName forKey:@"goodname"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockRename_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//42
+ (void)createOrderFromGoodBuyWithAgentID:(NSString *)agentID
                                    token:(NSString *)token
                                   userID:(NSString *)userID
                             createUserID:(NSString *)createUserID
                                 belongID:(NSString *)belongID
                              confirmType:(int)confirmType
                                   goodID:(NSString *)goodID
                                channelID:(NSString *)channelID
                                    count:(int)count
                                addressID:(NSString *)addressID
                                  comment:(NSString *)comment
                              needInvoice:(int)needInvoice
                              invoiceType:(int)invoiceType
                              invoiceInfo:(NSString *)invoiceTitle
                                 finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[createUserID intValue]] forKey:@"creatid"];
    [paramDict setObject:[NSNumber numberWithInt:[belongID intValue]] forKey:@"belongId"];
    
    [paramDict setObject:[NSNumber numberWithInt:confirmType] forKey:@"orderType"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    [paramDict setObject:[NSNumber numberWithInt:count] forKey:@"quantity"];
    [paramDict setObject:[NSNumber numberWithInt:[addressID intValue]] forKey:@"addressId"];
    if (comment) {
        [paramDict setObject:comment forKey:@"comment"];
    }
    [paramDict setObject:[NSNumber numberWithInt:needInvoice] forKey:@"isNeedInvoice"];
    if (needInvoice == 1) {
        [paramDict setObject:[NSNumber numberWithInt:invoiceType] forKey:@"invoiceType"];
        if (invoiceTitle) {
            [paramDict setObject:invoiceTitle forKey:@"invoiceInfo"];
        }
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_createOrder_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

//42.
+ (void)getStockDetailWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        channelID:(NSString *)channelID
                           goodID:(NSString *)goodID
                        agentName:(NSString *)agentName
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    if (agentName) {
        [paramDict setObject:agentName forKey:@"agentname"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//43.
+ (void)getStockTerminalWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                          channelID:(NSString *)channelID
                             goodID:(NSString *)goodID
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockTerminal_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//47.
+ (void)getGoodSubAgentWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgent_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//48.
+ (void)getPrepareGoodListWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                           subAgentID:(NSString *)subAgentID
                            startTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (subAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentId"];
    }
    if (startTime) {
        [paramDict setObject:startTime forKey:@"startTime"];
    }
    if (endTime) {
        [paramDict setObject:endTime forKey:@"endTime"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_prepareGoodList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//49.
+ (void)getPrepareGoodDetailWithToken:(NSString *)token
                            prapareID:(NSString *)prepareID
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (prepareID) {
        [paramDict setObject:[NSNumber numberWithInt:[prepareID intValue]] forKey:@"id"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_prepareGoodDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}
//50.
+ (void)getPrepareGoodPOSWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_prepareGoodPOS_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//51.
+ (void)getPrepareGoodChannelWithAgentID:(NSString *)agentID
                                   token:(NSString *)token
                                finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_prepareGoodChannel_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//52.
+ (void)getPrepareGoodTerminalListWithAgentID:(NSString *)agentID
                                        token:(NSString *)token
                                    channelID:(NSString *)channelID
                                       goodID:(NSString *)goodID
                              terminalNumbers:(NSArray *)terminalNumbers
                                         page:(int)page
                                         rows:(int)rows
                                       serialNum:(NSString *)serialNum
                                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (serialNum) {
        [paramDict setObject:serialNum forKey:@"serialNum"];
    }
    if (channelID) {
        [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    }
    if (goodID) {
        [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    }
    if (terminalNumbers) {
        [paramDict setObject:terminalNumbers forKey:@"serialNums"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_prepareGoodFilter_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//53.
+ (void)prepareGoodWithUserID:(NSString *)userID
                        token:(NSString *)token
                   subAgentID:(NSString *)subAgentID
                    channelID:(NSString *)channelID
                       goodID:(NSString *)goodID
                 terminalList:(NSArray *)terminalList
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (userID) {
        [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    }
    if (subAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentId"];
    }
    if (channelID) {
        [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    }
    if (goodID) {
        [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    }
    if (terminalList) {
        [paramDict setObject:terminalList forKey:@"serialNums"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_prepareGood_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//54.
+ (void)getTransferGoodListWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                            subAgentID:(NSString *)subAgentID
                             startTime:(NSString *)startTime
                               endTime:(NSString *)endTime
                                  page:(int)page
                                  rows:(int)rows
                              finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (subAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentId"];
    }
    if (startTime) {
        [paramDict setObject:startTime forKey:@"startTime"];
    }
    if (endTime) {
        [paramDict setObject:endTime forKey:@"endTime"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_transferGoodList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//55.
+ (void)getTransferGoodDetailWithToken:(NSString *)token
                            transferID:(NSString *)transferID
                              finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (transferID) {
        [paramDict setObject:[NSNumber numberWithInt:[transferID intValue]] forKey:@"id"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_transferGoodDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//55.
+ (void)getTradeTerminalListWithAgentID:(NSString *)agentID
                                  token:(NSString *)token
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeTerminalList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//57.
+ (void)transferGoodWithUserID:(NSString *)userID
                         token:(NSString *)token
                   fromAgentID:(NSString *)fromAgentID
                     toAgentID:(NSString *)toAgentID
                  terminalList:(NSArray *)terminalList
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (userID) {
        [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    }
    if (fromAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[fromAgentID intValue]] forKey:@"fromAgentId"];
    }
    if (toAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[toAgentID intValue]] forKey:@"toAgentId"];
    }
    if (terminalList) {
        [paramDict setObject:terminalList forKey:@"serialNums"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_transferGood_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//58.
+ (void)getTradeAgentListWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeAgentList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//59.
+ (void)getTradeRecordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        tradeType:(TradeType)tradeType
                   terminalNumber:(NSString *)terminalNumber
                       subAgentID:(NSString *)subAgentID
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:tradeType] forKey:@"tradeTypeId"];
    if (terminalNumber) {
        [paramDict setObject:terminalNumber forKey:@"terminalNumber"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonagentId"];
    if (startTime) {
        [paramDict setObject:startTime forKey:@"startTime"];
    }
    if (endTime) {
        [paramDict setObject:endTime forKey:@"endTime"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeRecord_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//60.
+ (void)getMyMessageListWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//61.
+ (void)getMyMessageDetailWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                            messageID:(NSString *)messageID
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[messageID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//62.
+ (void)getTradeStatistWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                         tradeType:(TradeType)tradeType
                        subAgentID:(NSString *)subAgentID
                    terminalNumber:(NSString *)terminalNumber
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endTime
                         hasProfit:(int)profit
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:tradeType] forKey:@"tradeTypeId"];
    if (terminalNumber) {
        [paramDict setObject:terminalNumber forKey:@"terminalNumber"];
    }
    if (subAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonagentId"];
    }
    if (startTime) {
        [paramDict setObject:startTime forKey:@"startTime"];
    }
    if (endTime) {
        [paramDict setObject:endTime forKey:@"endTime"];
    }
    [paramDict setObject:[NSNumber numberWithInt:profit] forKey:@"isHaveProfit"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeStatist_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//62.
+ (void)deleteSingleMessageWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                             messageID:(NSString *)messageID
                              finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[messageID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageSingleDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//63.
+ (void)deleteMultiMessageWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                           messageIDs:(NSArray *)messageIDs
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:messageIDs forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageMultiDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//64.
+ (void)readMultiMessageWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                         messageIDs:(NSArray *)messageIDs
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:messageIDs forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageMultiRead_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//67.
+ (void)getOrderListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                      orderType:(OrderType)orderType
                        keyword:(NSString *)keyword
                         status:(int)status
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    if (orderType > 0) {
        [paramDict setObject:[NSNumber numberWithInt:orderType] forKey:@"p"];
    }
    if (keyword) {
        [paramDict setObject:keyword forKey:@"search"];
    }
    if (status > 0) {
        [paramDict setObject:[NSString stringWithFormat:@"%d",status] forKey:@"q"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//68、71.
+ (void)getOrderDetailWithToken:(NSString *)token
                      orderType:(SupplyGoodsType)supplyType
                        orderID:(NSString *)orderID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *method = s_orderDetailWholesale_method;
    if (supplyType == SupplyGoodsProcurement) {
        method = s_orderDetailProcurement_method;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//69.
+ (void)cancelWholesaleOrderWithToken:(NSString *)token
                              orderID:(NSString *)orderID
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderCancelWholesale_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//72.
+ (void)cancelProcurementOrderWithToken:(NSString *)token
                                orderID:(NSString *)orderID
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderCancelProcurement_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//73. 76. 80.
+ (void)getCSListWithAgentID:(NSString *)agentID
                       token:(NSString *)token
                      csType:(CSType)type
                     keyword:(NSString *)keyword
                      status:(int)status
                        page:(int)page
                        rows:(int)rows
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    if (keyword) {
        [paramDict setObject:keyword forKey:@"search"];
    }
    if (status > 0) {
        [paramDict setObject:[NSNumber numberWithInt:status] forKey:@"q"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *method = nil;
    switch (type) {
        case CSTypeAfterSale:
            method = s_afterSaleList_method;
            break;
        case CSTypeUpdate:
            method = s_updateList_method;
            break;
        case CSTypeCancel:
            method = s_cancelList_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

//74. 77. 82.
+ (void)csCancelApplyWithToken:(NSString *)token
                        csType:(CSType)type
                          csID:(NSString *)csID
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *method = nil;
    switch (type) {
        case CSTypeAfterSale:
            method = s_afterSaleCancel_method;
            break;
        case CSTypeUpdate:
            method = s_updateCancel_method;
            break;
        case CSTypeCancel:
            method = s_cancelCancel_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//75. 79. 81.
+ (void)getCSDetailWithToken:(NSString *)token
                      csType:(CSType)type
                        csID:(NSString *)csID
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *method = nil;
    switch (type) {
        case CSTypeAfterSale:
            method = s_afterSaleDetail_method;
            break;
        case CSTypeUpdate:
            method = s_updateDetail_method;
            break;
        case CSTypeCancel:
            method = s_cancelDetail_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//78.
+ (void)csRepeatAppleyWithToken:(NSString *)token
                           csID:(NSString *)csID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_cancelApply_mehtod];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}


//80.
+ (void)getPersonDetailWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_personDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//81.
+ (void)getPersonModifyMobileValidateWithAgentID:(NSString *)agentID
                                           token:(NSString *)token
                                     phoneNumber:(NSString *)phoneNumber
                                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"phone"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyPhoneValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//82.
+ (void)modifyPersonMobileWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                       newPhoneNumber:(NSString *)phoneNumber
                             validate:(NSString *)validate
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"phone"];
    }
    if (validate) {
        [paramDict setObject:validate forKey:@"dentcode"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyPhone_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//83.
+ (void)getPersonModifyEmailValidateWithAgentID:(NSString *)agentID
                                          token:(NSString *)token
                                          email:(NSString *)email
                                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"email"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyEmailValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//84.
+ (void)modifyPersonEmailWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            newEmail:(NSString *)email
                            validate:(NSString *)validate
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"email"];
    }
    if (validate) {
        [paramDict setObject:validate forKey:@"dentcode"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyEmail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//88.
+ (void)modifyPasswordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                  primaryPassword:(NSString *)primaryPassword
                      newPassword:(NSString *)newPassword
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (primaryPassword) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:primaryPassword] forKey:@"passwordOld"];
    }
    if (newPassword) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:newPassword] forKey:@"password"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyPassword_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//89.
+ (void)getAddressListWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//90.
+ (void)addAddressWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                       cityID:(NSString *)cityID
                 receiverName:(NSString *)receiverName
                  phoneNumber:(NSString *)phoneNumber
                      zipCode:(NSString *)zipCode
                      address:(NSString *)address
                    isDefault:(AddressType)addressType
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (cityID) {
        [paramDict setObject:cityID forKey:@"cityId"];
    }
    if (receiverName) {
        [paramDict setObject:receiverName forKey:@"receiver"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"moblephone"];
    }
    if (zipCode) {
        [paramDict setObject:zipCode forKey:@"zipCode"];
    }
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    [paramDict setObject:[NSNumber numberWithInt:addressType] forKey:@"isDefault"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressAdd_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//91.
+ (void)deleteAddressWithToken:(NSString *)token
                    addressIDs:(NSArray *)addressIDs
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:addressIDs forKey:@"ids"];
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//91.a.
+ (void)updateAddressWithToken:(NSString *)token
                     addressID:(NSString *)addressID
                        cityID:(NSString *)cityID
                  receiverName:(NSString *)receiverName
                   phoneNumber:(NSString *)phoneNumber
                       zipCode:(NSString *)zipCode
                       address:(NSString *)address
                     isDefault:(AddressType)addressType
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[addressID intValue]] forKey:@"id"];
    if (cityID) {
        [paramDict setObject:cityID forKey:@"cityId"];
    }
    if (receiverName) {
        [paramDict setObject:receiverName forKey:@"receiver"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"moblephone"];
    }
    if (zipCode) {
        [paramDict setObject:zipCode forKey:@"zipCode"];
    }
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    [paramDict setObject:[NSNumber numberWithInt:addressType] forKey:@"isDefault"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressUpdate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//92.
+ (void)getSubAgentListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//94.
+ (void)createSubAgentWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                         username:(NSString *)username
                         password:(NSString *)password
                          confirm:(NSString *)confirm
                        agentType:(AgentType)agentType
                      companyName:(NSString *)companyName
                        licenseID:(NSString *)licenseID
                            taxID:(NSString *)taxID
                  legalPersonName:(NSString *)legalPersonName
                    legalPersonID:(NSString *)legalPersonID
                     mobileNumber:(NSString *)mobileNumber
                            email:(NSString *)email
                           cityID:(NSString *)cityID
                    detailAddress:(NSString *)address
                    cardImagePath:(NSString *)cardImagePath
                 licenseImagePath:(NSString *)licenseImagePath
                     taxImagePath:(NSString *)taxImagePath
                        hasPorfit:(int)hasProfit
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    if (username) {
        [paramDict setObject:username forKey:@"loginId"];
    }
    if (password) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:password] forKey:@"pwd"];
    }
    if (confirm) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:confirm] forKey:@"pwd1"];
    }
    [paramDict setObject:[NSNumber numberWithInt:agentType] forKey:@"agentType"];
    if (companyName) {
        [paramDict setObject:companyName forKey:@"companyName"];
    }
    else {
        [paramDict setObject:@"" forKey:@"companyName"];
    }
    if (licenseID) {
        [paramDict setObject:licenseID forKey:@"companyId"];
    }
    else {
        [paramDict setObject:@"" forKey:@"companyId"];
    }
    if (agentType == AgentTypeCompany) {
        if (taxID) {
            [paramDict setObject:taxID forKey:@"taxNumStr"];
        }
        if (licenseImagePath) {
            [paramDict setObject:licenseImagePath forKey:@"licensePhotoPath"];
        }
        if (taxImagePath) {
            [paramDict setObject:taxImagePath forKey:@"taxPhotoPath"];
        }
    }
    if (legalPersonName) {
        [paramDict setObject:legalPersonName forKey:@"agentName"];
    }
    if (legalPersonID) {
        [paramDict setObject:legalPersonID forKey:@"agentCardId"];
    }
    if (mobileNumber) {
        [paramDict setObject:mobileNumber forKey:@"phoneNum"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"emailStr"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    if (address) {
        [paramDict setObject:address forKey:@"addressStr"];
    }
    if (cardImagePath) {
        [paramDict setObject:cardImagePath forKey:@"cardPhotoPath"];
    }
    [paramDict setObject:[NSNumber numberWithInt:hasProfit] forKey:@"isProfit"];
    
    //已加密传递
    [paramDict setObject:[NSNumber numberWithBool:YES] forKey:@"isEncrypt"];


    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentCreate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}

//95.
+ (void)setDefaultBenefitWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                             precent:(CGFloat)precent
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    [paramDict setObject:[NSNumber numberWithFloat:precent] forKey:@"defaultProfit"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentDefaultBenefit_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//提交物流
+(void)submitLogistWithAgentID:(NSString *)agentID csID:(NSString *)csID logistName:(NSString *)logistname logistNum:(NSString *)logistnum finished:(requestDidFinished)finish
{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    [paramDict setObject:logistname forKey:@"computer_name"];
    [paramDict setObject:logistnum forKey:@"track_number"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_submitLogist_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+ (void)getStaffListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_staffList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+(void)deleteStaffWithAgentID:(NSString *)agentID
                        Token:(NSString *)token
                      loginID:(NSString *)loginID
                      staffID:(NSString *)staffID
                     finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    [paramDict setObject:[NSNumber numberWithInt:[staffID intValue]] forKey:@"customerId"];
    [paramDict setObject:loginID forKey:@"loginId"];
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_deletedstaff_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}
+(void)createStaffWithAgentID:(NSString *)agentID
                        Token:(NSString *)token
                      LoginID:(NSString *)loginID
                     UserName:(NSString *)userName
                        Roles:(NSMutableString *)roles
                     Password:(NSString *)password
                 MakePassword:(NSString *)makepassword
                     finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (userName) {
        [paramDict setObject:userName forKey:@"userName"];
    }
    if (loginID) {
        [paramDict setObject:loginID forKey:@"loginId"];
    }
    if (password) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:password] forKey:@"pwd"];
    }
    if (makepassword) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:makepassword] forKey:@"pwd1"];
    }
    if (roles) {
        [paramDict setObject:roles forKey:@"roles"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_createstaff_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+(void)getStaffDetailWithAgentID:(NSString *)agentID
                           Token:(NSString *)token
                         staffID:(NSString *)staffID
                        finished:(requestDidFinished)finish{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    [paramDict setObject:[NSNumber numberWithInt:[staffID intValue]] forKey:@"customerId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_getstaffdetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+(void)changeStaffWithAgentID:(NSString *)agentID Token:(NSString *)token LoginID:(NSString *)loginID Roles:(NSMutableString *)roles Password:(NSString *)password finished:(requestDidFinished)finish
{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:roles forKey:@"roles"];
//    [paramDict setObject:loginID forKey:@"loginId"];
    if (password) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:password] forKey:@"pwd"];

    }
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_changestaffdetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//93.
+ (void)getSubAgentDetailWithToken:(NSString *)token
                        subAgentID:(NSString *)subAgentID
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentsId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//96.
+ (void)getBenefitListWithToken:(NSString *)token
                     subAgentID:(NSString *)subAgentID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentsId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentBenefitList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//98.
+ (void)deleteBenefitWithAgentID:(NSString *)agentID
                           token:(NSString *)token
                      subAgentID:(NSString *)subAgentID
                       channelID:(NSString *)channelID
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (subAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentsId"];
    }
    if (channelID) {
        [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"payChannelId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentBenefitDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
//97.
+ (void)submitBenefitWithAgentID:(NSString *)agentID
                           token:(NSString *)token
                      subAgentID:(NSString *)subAgentID
                       channelID:(NSString *)channelID
                          profit:(NSString *)profit
                            type:(int)benefitType
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    }
    if (subAgentID) {
        [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentsId"];
    }
    if (channelID) {
        [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"payChannelId"];
    }
    if (profit) {
        [paramDict setObject:profit forKey:@"profitPercent"];
    }
    [paramDict setObject:[NSNumber numberWithInt:benefitType] forKey:@"sign"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentBenefitSet_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//99.
+ (void)getAgentChannelListWithToken:(NSString *)token
                            finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentChannelList_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_POST
                        finished:finish];
}

+ (void)getTradeTypeWithToken:(NSString *)token
                    channelID:(NSString *)channelID
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentTradeList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+ (void)orderConfirmWithOrderID:(NSString *)orderID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderConfirm_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

+ (void)getDefaultBenefitWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentGetDefault_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+ (void)getHomeImageListFinished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_homeImageList_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_POST
                        finished:finish];
}
//100.
+ (void)uploadSubAgentImageWithAgentID:(NSString *)agentID
                                 image:(UIImage *)image
                              finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kServiceURL,s_subAgentUpload_method,agentID];
    
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    
    [request uploadImageData:UIImagePNGRepresentation(image)
                   imageName:nil
                         key:@"img"];
    [request start];
}
+ (void)payProcurementWithOrderID:(NSString *)orderID
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_procurementPay_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+ (void)setHasBenefitWithAgentID:(NSString *)agentID
                      subAgentID:(NSString *)subAgentID
                      hasBenefit:(int)benefit
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonAgentsId"];
    [paramDict setObject:[NSNumber numberWithInt:benefit] forKey:@"isProfit"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_setHasBenefit_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

+(void)applyRegisterWithName:(NSString *)name Phone:(NSString *)phone AgentType:(NSString *)agentType Address:(NSString *)address finished:(requestDidFinished)finish
{
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:name forKey:@"name"];
    [paramDict setObject:phone forKey:@"phone"];
    [paramDict setObject:agentType forKey:@"agentType"];
    [paramDict setObject:address forKey:@"address"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyRigister_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

+ (void)getAllUserWithAgentID:(NSString *)agentID
                      keyword:(NSString *)keyword
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    if (keyword) {
        [paramDict setObject:keyword forKey:@"title"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_AllUserList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
    
}


+ (void)checkVersionFinished:(requestDidFinished)finish
{
    //参数
    NSMutableDictionary *paramDict=[[NSMutableDictionary alloc]init];
    [paramDict setObject:[NSNumber numberWithInt:kAppVersionType] forKey:@"types"];
    NSString *urlString=[NSString stringWithFormat:@"%@/%@",kServiceURL,s_appVersion_method];
    [[self class]requestWithURL:urlString params:paramDict httpMethod:HTTP_POST finished:finish];
}

+ (void)uploadPushInfoWithUserID:(NSString *)userID
                     channelInfo:(NSString *)channelInfo
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"id"];
    if (channelInfo) {
        [paramDict setObject:channelInfo forKey:@"deviceCode"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_push_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}
+ (void)beginVideoAuthWithTerminalID:(NSString *)terminalID
                            finished:(requestDidFinished)finish {
    //参数
    NSString *param = [NSString stringWithFormat:@"terminalId=%@",terminalID];
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:kVideoServiceURL
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    [request setFormPostBody:postData];
    [request start];
}

@end
