//
//  NetworkInterface.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "NetworkRequest.h"

typedef enum {
    RequestTokenOverdue = -3,   //token失效
//    RequestShortInventory = -2, //库存不足
    RequestFail = -1,           //请求错误
    RequestSuccess = 1,         //请求成功
}RequestCode;

typedef enum {
    AgentTypeNone = 0,
    AgentTypeCompany,     //公司
    AgentTypePerson,      //个人
}AgentType; //代理商类型

typedef enum {
    SupplyGoodsNone = 0,
    SupplyGoodsWholesale,    //批购
    SupplyGoodsProcurement,  //代购
}SupplyGoodsType;

typedef enum {
    OrderStatusAll = -1,
    OrderStatusUnPaid = 1,//未付款
    OrderStatusPaid,      //已付款
    OrderStatusSend,      //已发货
    OrderStatusReview,    //已评价
    OrderStatusCancel,    //已取消
    OrderStatusClosed,    //交易关闭
}OrderStatus;

typedef enum {
    OrderTypeProcurement = -1,      //不传默认查询3，4
    OrderTypeProcurementBuy = 3,    //代理商代购
    OrderTypeProcurementRent,       //代理商代租赁
    OrderTypeWholesale,            //代理商批购
}OrderType;

typedef enum {
    OrderFilterNone = -1,
    OrderFilterDefault,       //商品默认排序
    OrderFilterSales,         //销量排序
    OrderFilterPriceDown,     //价格降序
    OrderFilterPriceUp,       //价格升序
    OrderFilterScore,         //评分排序
}OrderFilter;

typedef enum {
    TradeTypeNone = -1,
    TradeTypeConsume = 1,    //消费
    TradeTypeTransfer,       //转账
    TradeTypeRepayment,        //还款
    TradeTypeTelephoneFare,    //话费充值
    TradeTypeLife,      //生活充值
}TradeType;

typedef enum {
    CSTypeNone = 0,
    CSTypeAfterSale,   //售后单记录
    CSTypeUpdate,      //更新资料记录
    CSTypeCancel,      //注销记录
}CSType;

typedef enum {
    OpenApplyNone = 0,
    OpenApplyPublic,    //对公
    OpenApplyPrivate,   //对私
    OpenApplyAll,
}OpenApplyType;  //开通类型

typedef enum {
    AddressNone = 0,
    AddressDefault,    //默认地址
    AddressOther,      //非默认地址
}AddressType;
//下级代理商管理——获取默认分润
static NSString *s_subAgentGetDefault_method = @"lowerAgent/getDefaultProfit";
//1.登录
static NSString *s_login_method = @"agent/agentLogin";

//2.注册
static NSString *s_register_method = @"agent/userRegistration";

//4.发送手机验证码——找回密码
static NSString *s_sendValidate_method = @"agent/sendPhoneVerificationCode";

//5.邮箱验证——找回密码
static NSString *s_emailValidate_method = @"agent/sendEmailVerificationCode";

//6.找回密码
static NSString *s_findPassword_method = @"agent/updatePassword";

//7.注册图片上传
static NSString *s_uploadRegisterImage_method = @"agent/upload/register";

//8.开通申请列表--根据代理商ID获得开通申请列表
static NSString *s_applyList_method = @"apply/getApplyList";

//9.申请开通—根据终端号查询-获得开通申请列表
static NSString *s_searchapplyList_method = @"apply/searchApplyList";

//10.申请开通--进入开通/重新申请
static NSString *s_Intoapply_method = @"apply/getApplyDetails";

//11.申请开通--根据商户id获得商户详细信息
static NSString *s_getMerchant_method = @"apply/getMerchant";

//12.申请开通--获得支付通道
static NSString *s_applyChannel_method = @"apply/getChannels";

//13.申请开通--选择银行
static NSString *s_chooseBank_method = @"apply/chooseBank";

//14.申请开通--对公对私材料名称
static NSString *s_applyMaterial_method = @"apply/getMaterialName";

//15.申请开通--添加申请信息
static NSString *s_applySubmit_method = @"apply/addOpeningApply";

//16.申请开通--图片资料上传
static NSString *s_loadImage_method = @"comment/upload/tempImage";
//16.申请开通--图片资料上传
static NSString *s_loadImage_methodls = @"lowerAgent/uploadImg";

static NSString *s_uploadApplyImage_method = @"apply/upload/tempOpenImg";


//17.申请开通—查看终端详情
static NSString *s_termainlDetail_method = @"terminal/getTernimalDetails";

//18.申请开通—获得所有商户分页列表
static NSString *s_merchantList_method = @"terminal/getMerchants";



//19.终端管理——获取终端列表
static NSString *s_terminalList_method = @"terminal/getApplyList";

//20.终端管理——根据终端号模糊查询得到相关终端
static NSString *s_terminalSearch_method = @"apply/searchApplyList";

//21.终端管理——根据状态选择查询
static NSString *s_terminalStatus_method = @"terminal/getTerminalList";

//22.终端管理——进入终端详情
static NSString *s_terminalDetails_method = @"terminal/getApplyDetails";

//23.终端管理——开通申请/重新开通
static NSString *s_getapply_method = @"apply/getApplyDetails";

//24.终端管理——同步
static NSString *s_terminalsynchronous_method = @"terminal/synchronous";

//25.终端管理--获取代理商下面的用户
static NSString *s_terminalgetMerchants_method = @"terminal/getMerchants";

//25.终端管理--为用户绑定终端—添加用户发送短信
static NSString *s_sendPhoneVerification_method = @"terminal/sendPhoneVerificationCodeReg";

//26.找回POS密码
static NSString *s_findPOSpwd_method = @"terminal/encryption";

//26.终端管理——添加用户
static NSString *s_addUser_method = @"terminal/addCustomer";

//26.终端管理——为用户绑定终端号
static NSString *s_bindingterminal_method = @"terminal/bindingTerminals";

//27.终端管理——申请售后批量终端号筛选
static NSString *s_batchterminalnum_method = @"terminal/batchTerminalNum";

//28.终端管理——pos机,通道,价格,筛选终端
static NSString *s_screeningterminalnum_method = @"terminal/screeningTerminalNum";

//29.终端管理——pos机选择
static NSString *s_screeningPOSnum_method = @"terminal/screeningPosName";

//30.终端管理——通道列表
static NSString *s_getChannels_method = @"terminal/getChannels";

//31.终端管理——收件人信息
static NSString *s_getAddressee_method = @"terminal/getAddressee";

//32.终端管理——提交申请售后
static NSString *s_submitAgent_method = @"terminal/submitAgent";




//31.用户管理——获取用户列表
static NSString *s_userList_method = @"user/getUser";

//32.用户管理——删除用户
static NSString *s_userDelete_method = @"user/delectAgentUser";

//33.用户管理——获取终端
static NSString *s_userTerminal_method = @"user/getTerminals";

//34.商品搜索条件
static NSString *s_goodSearch_method = @"good/search";

//35.商品列表
static NSString *s_goodList_method = @"good/list";



//36.商品详细
static NSString *s_goodDetail_method = @"good/goodinfo";
//36.交易流水详情
static NSString *s_TradeRecord = @"trade/getTradeRecord";
//36.交易流水统计
static NSString *s_TradeStatistics = @"trade/getTradeStatistics";
//获取交易流水终端列表
//static NSString *s_terminalList_method = @"trade/record/getTerminals";
//40.库存管理列表
static NSString *s_stockList_method = @"stock/list";
//40.支付通道详细
static NSString *s_channelDetail_method = @"paychannel/info";
//41.库存管理重命名
static NSString *s_stockRename_method = @"stock/rename";
//41.评论列表
static NSString *s_commentList_method = @"comment/list";
//42.库存管理详情——下级代理商列表
static NSString *s_stockDetail_method = @"stock/info";

//43.库存管理详情——下级代理商终端列表
static NSString *s_stockTerminal_method = @"stock/terminallist";
//47.选择代理商
static NSString *s_subAgent_method = @"preparegood/getsonagent";
//48.配货列表
static NSString *s_prepareGoodList_method = @"preparegood/list";

//49.配货详情
static NSString *s_prepareGoodDetail_method = @"preparegood/info";

//54.调货列表
static NSString *s_transferGoodList_method = @"exchangegood/list";

//55.交易流水——获取终端
static NSString *s_tradeTerminalList_method = @"trade/record/getTerminals";
//55.调货详情
static NSString *s_transferGoodDetail_method = @"exchangegood/info";
//58.交易流水——获取代理商列表
static NSString *s_tradeAgentList_method = @"trade/record/getAgents";
//59.交易流水——查询交易流水
static NSString *s_tradeRecord_method = @"trade/record/getTradeRecords";
//60.我的消息——列表
static NSString *s_messageList_method = @"message/receiver/getAll";

//61.我的消息——详情
static NSString *s_messageDetail_method = @"message/receiver/getById";

//62.我的消息——单个删除
static NSString *s_messageSingleDelete_method = @"message/receiver/deleteById";

//63.我的消息——批量删除
static NSString *s_messageMultiDelete_method = @"message/receiver/batchDelete";

//64.我的消息——批量已读
static NSString *s_messageMultiRead_method = @"message/receiver/batchRead";

//67.订单管理——列表
static NSString *s_orderList_method = @"order/orderSearch";
//68.订单管理——批购详情
//71.订单管理——代购详情
static NSString *s_orderDetailProcurement_method = @"order/getProxyById";
static NSString *s_orderDetailWholesale_method = @"order/getWholesaleById";
//69.订单管理——批购取消订单
static NSString *s_orderCancelWholesale_method = @"order/cancelWholesale";
//72.订单管理——代购取消订单
static NSString *s_orderCancelProcurement_method = @"order/cancelProxy";
//73.售后记录——售后单列表
static NSString *s_afterSaleList_method = @"cs/agents/search";

//74.售后记录——售后单取消申请
static NSString *s_afterSaleCancel_method = @"cs/agents/cancelApply";

//75.售后记录——售后单详情
static NSString *s_afterSaleDetail_method = @"cs/agents/getById";

//76.售后记录——注销记录列表
static NSString *s_cancelList_method = @"cs/cancels/search";

//77.售后记录——注销记录取消申请
static NSString *s_cancelCancel_method = @"cs/cancels/cancelApply";

//78.售后记录——注销记录重新提交
static NSString *s_cancelApply_mehtod = @"cs/cancels/resubmitCancel";

//79.售后记录——注销记录详情
static NSString *s_cancelDetail_method = @"cs/cancels/getCanCelById";

//80.售后记录——更新资料列表
static NSString *s_updateList_method = @"update/info/search";

//81.售后记录——更新资料详情
static NSString *s_updateDetail_method = @"update/info/getInfoById";

//82.售后记录——更新资料取消申请
static NSString *s_updateCancel_method = @"update/info/cancelApply";

//80.我的信息——获取详情
static NSString *s_personDetail_method = @"agents/getOne";

//81.我的信息——获取修改手机验证码
static NSString *s_modifyPhoneValidate_method = @"agents/getUpdatePhoneDentcode";

//82.我的信息——修改手机
static NSString *s_modifyPhone_method = @"agents/updatePhone";

//83.我的信息——获取修改邮箱验证码
static NSString *s_modifyEmailValidate_method = @"agents/getUpdateEmailDentcode";

//84.我的信息——修改邮箱
static NSString *s_modifyEmail_method = @"agents/updateEmail";
//88.我的信息——修改密码
static NSString *s_modifyPassword_method = @"agents/updatePassword";

//89.我的信息——地址列表
static NSString *s_addressList_method = @"agents/getAddressList";

//90.我的信息——新增地址
static NSString *s_addressAdd_method = @"agents/insertAddress";

//91.我的信息——删除地址
static NSString *s_addressDelete_method = @"agents/batchDeleteAddress";
//91.a.我的信息——更新收货地址
static NSString *s_addressUpdate_method = @"agents/updateAddress";
//92.下级代理商管理——列表
static NSString *s_subAgentList_method = @"lowerAgent/list";
//95.下级代理商管理——设置默认分润
static NSString *s_subAgentDefaultBenefit_method = @"lowerAgent/changeProfit";
//热卖
static NSString *s_hot_method = @"index/pos_list";
//提交物流信息
static NSString *s_submitLogist_method = @"/cs/agents/addMark";
//员工列表
static NSString *s_staffList_method = @"/customerManage/getList";
//删除员工
static NSString *s_deletedstaff_method = @"/customerManage/deleteOne";
//创建员工
static NSString *s_createstaff_method = @"/customerManage/insert";
//获得员工详情
static NSString *s_getstaffdetail_method = @"/customerManage/getInfo";
//修改员工信息
static NSString *s_changestaffdetail_method = @"/customerManage/edit";
//53.配货
static NSString *s_prepareGood_method = @"preparegood/add";
//52.配货筛选终端
static NSString *s_prepareGoodFilter_method = @"preparegood/getterminalslist";

//51.配货支付通道列表
static NSString *s_prepareGoodChannel_method = @"preparegood/getpaychannellist";
//57.调货
static NSString *s_transferGood_method = @"exchangegood/add";
//42.创建订单
static NSString *s_createOrder_method = @"order/agent";
//93.下级代理商管理——详情
static NSString *s_subAgentDetail_method = @"lowerAgent/info";
//94.下级代理商管理——创建
static NSString *s_subAgentCreate_method = @"lowerAgent/createNew";
//96.下级代理商管理——获取分润列表
static NSString *s_subAgentBenefitList_method = @"lowerAgent/getProfitlist";
//97.下级代理商管理——设置分润
static NSString *s_subAgentBenefitSet_method = @"lowerAgent/saveOrEdit";
//98.下级代理商管理——删除分润
static NSString *s_subAgentBenefitDelete_method = @"lowerAgent/delChannel";
//99.下级代理商管理——获取支付通道列表
static NSString *s_subAgentChannelList_method = @"lowerAgent/getChannellist";

//下级代理商管理——根据支付通道获取消费类型
static NSString *s_subAgentTradeList_method = @"lowerAgent/getTradelist";
//订单信息
static NSString *s_orderConfirm_method = @"order/payOrder";

//25.终端管理——添加用户验证码
static NSString *s_addUserValidate_method = @"terminal/sendPhoneVerificationCodeReg";
//首页轮播
static NSString *s_homeImageList_method = @"index/sysshufflingfigure";
//100.下级代理商管理——上传图片
static NSString *s_subAgentUpload_method = @"lowerAgent/uploadImg";
//代购订单支付
static NSString *s_procurementPay_method = @"shop/payOrder";

//50.配货POS列表
static NSString *s_prepareGoodPOS_method = @"preparegood/getgoodlist";
//设置是否分润
static NSString *s_setHasBenefit_method = @"lowerAgent/setDefaultProfit";
//62.交易流水——统计交易流水
static NSString *s_tradeStatist_method = @"trade/getTradeStatistics";

//62.交易流水——统计交易流水
static NSString *s_applyRigister_method = @"agent/getJoin";

static NSString *s_sendRegisterValidate_method = @"agent/sendPhoneVerificationCodeReg";
//商品图片
static NSString *s_goodImage_method = @"good/getGoodImgUrl";

//获取所有用户
static NSString *s_AllUserList_method = @"terminal/getCustomer";
//获取app版本
static NSString *s_appVersion_method = @"index/getVersion";



//推送
static NSString *s_push_method = @"agents/sendDeviceCode";
@interface NetworkInterface : NSObject




+ (void)uploadPushInfoWithUserID:(NSString *)userID
                     channelInfo:(NSString *)channelInfo
                        finished:(requestDidFinished)finish;
+ (void)getMerchantListWithToken:(NSString *)token
                      terminalID:(NSString *)terminalID
                         keyword:(NSString *)merchantName
                            page:(int)page
                            rows:(int)rows
                        finished:(requestDidFinished)finish;
+ (void)getGoodImageWithGoodID:(NSString *)goodID
                      finished:(requestDidFinished)finish;
/*!
 @abstract 1.热卖
 
 
 */

/*!
@abstract 62.交易流水——统计
@param agentID  代理商id
@param token    登录返回
@param tradeType  交易类型
@param terminalNumber  终端号
@param subAgentID  下级代理商
@param startTime   开始时间
@param endTime     结束时间
@param profit   1.无分润  2.有分润
@result finish  请求回调结果
*/
+ (void)getTradeStatistWithAgentID:(NSString *)agentID
                             token:(NSString *)token
tradeType:(TradeType)tradeType
subAgentID:(NSString *)subAgentID
terminalNumber:(NSString *)terminalNumber
startTime:(NSString *)startTime
endTime:(NSString *)endTime
hasProfit:(int)profit
finished:(requestDidFinished)finish;

+ (void)hotget:(NSString *)tolen
      finished:(requestDidFinished)finish;
+ (void)addUserWithtoken:(NSString *)token
           phoneyanzheng:(NSString*)phoneyangzheng
                 AgentId:(NSString *)agentId
                username:(NSString *)name
                password:(NSString *)password
              codeNumber:(NSString *)codeNumber
                  cityId:(NSString *)cityId
                finished:(requestDidFinished)finish;
/*!
 @abstract 代购订单信息
 @result finish  请求回调结果
 */
+ (void)payProcurementWithOrderID:(NSString *)orderID
                         finished:(requestDidFinished)finish;

/*!


 @abstract 1.登录
 @param username      用户名
 @param password      密码
 @param encrypt       是否已加密
 @result finish  请求回调结果
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         isAlreadyEncrypt:(BOOL)encrypt
                 finished:(requestDidFinished)finish;

/*!
 @abstract 2.注册
 @param username      用户名
 @param password      密码
 @param encrypt       是否已加密
 @param agentType     1.公司  2.个人
 @param companyName   公司名称
 @param licenseID     公司营业执照号
 @param taxID         公司税务证号
 @param legalPersonName  负责人姓名
 @param legalPersonID    负责人身份证号
 @param mobileNumber     手机
 @param email            邮箱
 @param cityID        城市id
 @param address       详细地址
 @param cardImagePath    身份证照片
 @param licenseImagePath 营业执照照片
 @param taxImagePath     税务证照片
 @result finish  请求回调结果
 */
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
                    finished:(requestDidFinished)finish;

+(void)applyRegisterWithName:(NSString *)name Phone:(NSString *)phone AgentType:(NSString *)agentType Address:(NSString *)address finished:(requestDidFinished)finish;

/*!
 @abstract 4.手机验证码
 @param mobileNumber  手机号
 @result finish  请求回调结果
 */
+ (void)sendValidateWithMobileNumber:(NSString *)mobileNumber
                            finished:(requestDidFinished)finish;

/*!
 @abstract 5.邮箱验证
 @param email  邮箱
 @result finish  请求回调结果
 */
+ (void)sendEmailValidateWithEmail:(NSString *)email
                          finished:(requestDidFinished)finish;

/*!
 @abstract 6.找回密码
 @param username      用户名
 @param password      密码
 @param validateCode  验证码
 @result finish  请求回调结果
 */
+ (void)findPasswordWithUsername:(NSString *)username
                        password:(NSString *)password
                    validateCode:(NSString *)validateCode
                        finished:(requestDidFinished)finish;

/*!
 @abstract 7.上传图片
 @param image       图片
 @result finish  请求回调结果
 */
+ (void)uploadRegisterImageWithImage:(UIImage *)image
                            finished:(requestDidFinished)finish;


/*!
 @abstract 8.申请开通--根据代理商ID获得开通申请列表
 @param token       登录返回
 @param agentID      代理商ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getApplyListWithToken:(NSString *)token
                      agentId:(NSString *)agentId
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 9.申请开通—根据终端号查询-获得开通申请列表
 @param token       登录返回
 @param agentID      代理商ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @param serialNum     终端号
 @result finish  请求回调结果
 */
+ (void)searchApplyListWithToken:(NSString *)token
                      agentId:(NSString *)agentId
                         page:(int)page
                         rows:(int)rows
                       serialNum:(NSString *)serialNum
                     finished:(requestDidFinished)finish;





/*!
 @abstract 10.申请开通--进入开通/重新申请
 @param token       登录返回
 @param agentID      代理商ID
 @param applyStatus   对公对私
 @param terminalsId   终端ID
 @result finish  请求回调结果
 */
+ (void)beginToApplyWithToken:(NSString *)token
                      agentId:(NSString *)agentId
                  applyStatus:(OpenApplyType)applyStatus
                   terminalId:(NSString *)terminalId
                     finished:(requestDidFinished)finish;



/*
 @abstract 11.申请开通--根据商户id获得商户详细信息
 @param token       登录返回
 @result finish  请求回调结果
*/
+ (void)getMerchantDetailWithToken:(NSString *)token
                        merchantId:(NSString *)merchantId
                    finished:(requestDidFinished)finish;


/*!
 @abstract 12.申请开通--获得支付通道
 @param token       登录返回
 @result finish  请求回调结果
 */
+ (void)getChannelsWithToken:(NSString *)token
                    finished:(requestDidFinished)finish;

/*!
 @abstract 13.申请开通--选择银行
 @param token       登录返回
 @param terminalID  终端号
 @param keyword  关键字
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)chooseBankWithToken:(NSString *)token
                    keyword:(NSString *)keyword
                       page:(int)page
                       pageSize:(int)pageSize
                     terminalId:(NSString *)terminalId
                   finished:(requestDidFinished)finish;




/*!
 @abstract 14.申请开通--对公对私材料名称
 @param token       登录返回
 @param terminalID  终端ID
 @param status     对公对私
 @result finish  请求回调结果
 */
+ (void)getMaterinalNameWithToken:(NSString *)token
                   terminalId:(NSString *)terminalId
                   status:(int)status
                   finished:(requestDidFinished)finish;


/*!
 @abstract 15.申请开通--添加申请信息
 @param token       登录返回
 @param paramList   参数数组
 @result finish  请求回调结果
 */
+ (void)submitApplyWithToken:(NSString *)token
                      params:(NSArray *)paramList
                    finished:(requestDidFinished)finish;



/*!
 @abstract 16.申请开通--图片资料上传
 @param image       图片
 @param terminalId      终端ID
 @result finish  请求回调结果
 */
+ (void)uploadImageWithImage:(UIImage *)image
             terminalId:(NSString *)terminalId
                    finished:(requestDidFinished)finish;

/*!
 @abstract 17.申请开通—查看终端详情
 @param Token       登录返回
 @param terminalId      终端ID
 @result finish  请求回调结果
 */

+ (void)getTerminalDetailsWithToken:(NSString *)token
                                terminalId:(NSString *)terminalId
                               finished:(requestDidFinished)finish;


/*!
 @abstract 18.申请开通——获取商户列表
 @param agentID     代理商ID
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getMerchantListWithToken:(NSString *)token
                           terminalId:(NSString *)terminalId
                              page:(int)page
                              rows:(int)rows
                           title:(NSString *)title
                          finished:(requestDidFinished)finish;

/*!
 @abstract 19.终端管理--根据用户ID获得终端列表
 @param Token       登录返回
 @param agentID     代理商ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */

+ (void)getTerminalManagerListWithToken:(NSString *)token
                                agentID:(NSString *)agentId
                                   page:(int)page
                                   rows:(int)rows
                               finished:(requestDidFinished)finish;


/*!
 @abstract 20.终端管理—根据终端号模糊查询得到相关终端
 @param Token       登录返回
 @param agentID     代理商ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @param serialNum    模糊查询终端号
 @result finish  请求回调结果
 */

+ (void)searchApplyListWithToken:(NSString *)token
                                agentID:(NSString *)agentId
                                   page:(int)page
                                   rows:(int)rows
                                serialNum:(NSString *)serialNum
                               finished:(requestDidFinished)finish;





/*!
 @abstract 21.终端管理--根据状态选择查询
 @param Token       登录返回
 @param agentID     代理商ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */

+ (void)getTerminalStatusListWithToken:(NSString *)token
                               agentID:(NSString *)agentId
                                  page:(int)page
                                  rows:(int)rows
                                status:(int)status
                              finished:(requestDidFinished)finish;

/*!
 @abstract 21.终端管理--根据状态选择查询
 @param Token       登录返回
 @param agentID     代理商ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */

+ (void)searchTerminalsListWithToken:(NSString *)token
                               agentID:(NSString *)agentId
                                  page:(int)page
                                  rows:(int)rows
                              serialNum:(NSString*)serialNum
                              finished:(requestDidFinished)finish;




/*!
 @abstract 22.终端管理--终端详情
 @param Token       登录返回
 @param terminalsId     代理商ID
 @result finish  请求回调结果
 */

+ (void)getTerminalDetailWithToken:(NSString *)token
                       terminalsId:(NSString *)terminalsId
                          finished:(requestDidFinished)finish;



/*!
 @abstract 23.终端管理—开通申请/重新开通
 @param Token       登录返回
 @param customerId     用户ID
 @param terminalsId     代理商ID
 @param status     对公对私
 @result finish  请求回调结果
 */

+ (void)getApplyDetailsWithToken:(NSString *)token
                        customerId:(NSString *)customerId
                        terminalsId:(NSString *)terminalsId
                        status:(int)status
                          finished:(requestDidFinished)finish;

/*!
 @abstract 24.终端管理--同步
 @param Token       登录返回
 @result finish  请求回调结果
 */

+ (void)getTerminalSynchronousWithToken:(NSString *)token
                       terminalId:(NSString *)terminalId
                        finished:(requestDidFinished)finish;



/*!
 @abstract 25.添加用户手机验证码
 @param mobileNumber  手机号
 @result finish  请求回调结果
 */
+ (void)sendBindingValidateWithMobileNumber:(NSString *)mobileNumber
                                   finished:(requestDidFinished)finish;


/*!
 @abstract 25.终端管理--获取代理商下面的用户
 @param token    登录返回
 @param customerId   用户id
 @result finish  请求回调结果
 */
+ (void)getUserTerminalListWithtoken:(NSString *)token
                          customerId:(NSString *)customerId
                                page:(int)page
                                rows:(int)rows
                            finished:(requestDidFinished)finish;



/*!
 @abstract 26.终端管理——添加用户
 @param agentId     代理商ID
 @param token    登录返回
 @param name     用户名
 @param password 密码
 @param codeNumber   验证码
 @param cityID   城市id
 @result finish  请求回调结果
 */
+ (void)addUserWithtoken:(NSString *)token
                     AgentId:(NSString *)agentId
                  username:(NSString *)name
                  password:(NSString *)password
                codeNumber:(NSString *)codeNumber
                    cityId:(NSString *)cityId
                    code:(NSString *)code
                  finished:(requestDidFinished)finish;



/*!
 @abstract 26.终端管理--为用户绑定终端号
 
 @param token    登录返回
 @param terminalsNum   终端号
 @param userId   代理商下面的用户ID
 @result finish  请求回调结果
 */
+ (void)bindingTerminalWithtoken:(NSString *)token
                         AgentId:(NSString *)agentId
                    terminalsNum:(NSString *)terminalsNum
                          userId:(NSString *)userId
                        finished:(requestDidFinished)finish;


/*!
@abstract 26.终端管理--为用户绑定终端号

@param token    登录返回
@param terminalid   终端号
@result finish  请求回调结果
*/
+ (void)findPOSpwdWithtoken:(NSString *)token
                    terminalid:(NSString *)terminalid
                        finished:(requestDidFinished)finish;



/*!
 @abstract 27.终端管理—申请售后批量终端号筛选
 @param token    登录返回
 @param serialNum   所有终端号数组
 @result finish  请求回调结果
 */
+ (void)batchTerminalNumWithtoken:(NSString *)token
                          agentId:(NSString *)agentId
                      serialNum:(NSArray *)serialNum
                        finished:(requestDidFinished)finish;

/*!
 @abstract 28.终端管理—pos机,通道,价格,筛选终端
 @param token    登录返回
 @param title   Pos机名称
 @param channelsId   通道ID
 @param minPrice   最低价
 @param maxPrice  最高价
 @result finish  请求回调结果
 */
+ (void)screeningTerminalNumWithtoken:(NSString *)token
                              agentId:(NSString *)agentId
                             POStitle:(NSString *)POStitle
                           channelsId:(int)channelsId
                             minPrice:(int)minPrice
                             maxPrice:(int)maxPrice
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish;


/*!
 @abstract 29.终端管理--Pos机选择
 @param token    登录返回
 @param customerId   通道ID
 @result finish  请求回调结果
 */
+ (void)screeningPOSNameWithtoken:(NSString *)token
                           customerId:(NSString *)customerId
                             finished:(requestDidFinished)finish;


/*!
 @abstract 30.终端管理--通道列表
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getchannelsWithtoken:(NSString *)token
                             finished:(requestDidFinished)finish;


/*!
 @abstract 31.终端管理--收件人信息
 @param token    登录返回
 @param customerId    用户ID
 @result finish  请求回调结果
 */
+ (void)getAddresseeWithtoken:(NSString *)token
                   customerId:(NSString *)customerId
                    finished:(requestDidFinished)finish;


/*!
 @abstract 32.终端管理--提交申请售后
 @param token    登录返回
 @param customerId    用户ID
 @param terminalsQuantity    终端数量
 @param address    收件地址
 @param reason    售后原因
 @param terminalsList    终端号数组集合
 @param reciver    收件人
 @param phone    电话
 @result finish  请求回调结果
 */
+ (void)submintAgentWithtoken:(NSString *)token
                   customerId:(NSString *)customerId
            terminalsQuantity:(int)terminalQuantity
                      address:(NSString *)address
                       reason:(NSString *)reason
                terminalsList:(NSString *)terminalsList
                      reciver:(NSString *)reciver
                        phone:(NSString *)phone
                     finished:(requestDidFinished)finish;



/*!
 @abstract 32.终端管理——提交申请售后
 @param userID   登录用户id
 @param token    登录返回
 @param count    终端数量
 @param address  地址
 @param receiver 收件人
 @param phoneNumber 手机号
 @param reason   售后原因
 @param terminalList   终端列表字符串
 @result finish  请求回调结果
 */
+ (void)submitAfterSaleApplyWithUserID:(NSString *)userID
                                 token:(NSString *)token
                         terminalCount:(NSInteger)count
                               address:(NSString *)address
                              receiver:(NSString *)receiver
                           phoneNumber:(NSString *)phoneNumber
                                reason:(NSString *)reason
                          terminalList:(NSString *)terminalList
                              finished:(requestDidFinished)finish;







/*!
 @abstract 31.用户管理——获取用户列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getUserListWithAgentID:(NSString *)agentID
                         token:(NSString *)token
                          page:(int)page
                          rows:(int)rows
                      finished:(requestDidFinished)finish;

/*!
 @abstract 32.用户管理——删除用户
 @param agentID  代理商id
 @param token    登录返回
 @param userID   删除用户的id
 @result finish  请求回调结果
 */
+ (void)deleteUserWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                       userIDs:(NSArray *)userIDs
                     finished:(requestDidFinished)finish;

/*!
 @abstract 33.用户管理——获取用户终端
 @param token    登录返回
 @param userID   用户id
 @result finish  请求回调结果
 */
+ (void)getUserTerminalListWithUserID:(NSString *)userID
                                token:(NSString *)token
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish;
/*!
 @abstract 34.商品搜索条件
 @param cityID      城市ID
 @result finish  请求回调结果
 */
+ (void)getGoodSearchInfoWithCityID:(NSString *)cityID
                           finished:(requestDidFinished)finish;

/*!
 @abstract 35.商品列表
 @param cityID      城市ID
 @param agentID     代理商ID
 @param supplyType  1.批购 2.代购
 @param filterType  排序类型
 @param brandID     POS机品牌ID
 @param category    POS机类型
 @param channelID   支付通道
 @param cardID      支付卡类型
 @param tradeID     支持交易类型
 @param slipID      签单方式
 @param date        对账日期
 @param maxPrice    最高价
 @param minPrice    最低价
 @param keyword     搜索关键字
 @param rent        是否只支持租赁
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
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
                     finished:(requestDidFinished)finish;

/*!
 @abstract 36.商品详细
 @param cityID      城市ID
 @param agentID     代理商ID
 @param goodID      商品ID
 @param supplyType  1.批购 2.代购
 @result finish  请求回调结果
 */
+ (void)getGoodDetailWithCityID:(NSString *)cityID
                        agentID:(NSString *)agentID
                         goodID:(NSString *)goodID
                     supplyType:(SupplyGoodsType)supplyType
                       finished:(requestDidFinished)finish;
//37.
+ (void)getTradeRecordid:(NSString *)isHaveProfit agentID:(NSString *)agentID tradeRecordId:(NSString *)tradeRecordId finished:(requestDidFinished)finish;

/*!
 @abstract 37.获取终端列表
 @param token       登录返回
 @param userID      登录用户id
 @result finish  请求回调结果
 */
+ (void)getTerminalListWithagentId:(NSString *)agentId
                        finished:(requestDidFinished)finish;



//38.
+ (void)getTradeStatistics:(NSString *)tradeTypeId
                   agentID:(NSString *)agentID
             tradeRecordId:(NSString *)sonagentId
            terminalNumber:(NSString *)terminalNumber
                 startTime:(NSString *)startTime
                   endTime:(NSString *)endTime
              isHaveProfit:(NSString *)isHaveProfit
                  finished:(requestDidFinished)finish;


/*!
 @abstract 40.支付通道详细
 @param token     登录返回
 @param channelID   支付通道id
 @result finish  请求回调结果
 */
+ (void)getChannelDetailWithToken:(NSString *)token
                        channelID:(NSString *)channelID
                         finished:(requestDidFinished)finish;


/*!
 @abstract 40.库存管理列表
 @param agentID     代理商ID
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getStockListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;

/*!
 @abstract 41.商品评论列表
 @param token     登录返回
 @param goodID   商品id
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getCommentListWithToken:(NSString *)token
                         goodID:(NSString *)goodID
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;


/*!
 @abstract 41.库存管理重命名
 @param agentID     代理商ID
 @param token    登录返回
 @param goodID   商品id
 @param goodName 商品名
 @result finish  请求回调结果
 */
+ (void)renameStockGoodWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                            goodID:(NSString *)goodID
                          goodName:(NSString *)goodName
                          finished:(requestDidFinished)finish;
/*!
 @abstract 42.创建订单
 @param agentID     代理商id
 @param token       登录返回
 @param userID      选择的用户id，默认为登录返回的agentUserID
 @param createUserID  登录返回的id
 @param belongID    agentUserID
 @param confirmType  OrderConfirmType类型
 @param goodID     商品id
 @param channelID  支付通道id
 @param count      数量
 @param addressID   地址id
 @param comment     留言
 @param needInvoice 是否需要发票 0.不要 1.要
 @param invoiceType 发票类型 0.公司 1.个人
 @param invoiceTitle  发票抬头
 @result finish  请求回调结果
 */
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
                                 finished:(requestDidFinished)finish;


/*!
 @abstract 42.库存管理详情——下级代理商列表
 @param agentID     代理商ID
 @param token    登录返回
 @param channelID   支付通道ID
 @param goodID   商品ID
 @param agentName   代理商名称
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getStockDetailWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        channelID:(NSString *)channelID
                           goodID:(NSString *)goodID
                        agentName:(NSString *)agentName
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish;

/*!
 @abstract 43.库存管理详情——下级代理商终端列表
 @param agentID     代理商ID
 @param token    登录返回
 @param channelID   支付通道ID
 @param goodID   商品ID
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getStockTerminalWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                          channelID:(NSString *)channelID
                             goodID:(NSString *)goodID
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish;
/*!
 @abstract 45.地址列表
 @param token       登录返回
 @param userID   交易类型
 @result finish  请求回调结果
 */
+ (void)getAddressListWithToken:(NSString *)token
                         usedID:(NSString *)userID
                       finished:(requestDidFinished)finish;
/*!
 @abstract 47.选择代理商
 @param agentID     代理商ID
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getGoodSubAgentWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish;
/*!
 @abstract 48.配货列表
 @param agentID     代理商ID
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodListWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                           subAgentID:(NSString *)subAgentID
                            startTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish;
/*!
 @abstract 49.配货详情
 @param token    登录返回
 @param prepareID  配货id
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodDetailWithToken:(NSString *)token
                            prapareID:(NSString *)prepareID
                             finished:(requestDidFinished)finish;
/*!
 @abstract 51.配货——支付通道列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodChannelWithAgentID:(NSString *)agentID
                                   token:(NSString *)token
                                finished:(requestDidFinished)finish;


/*!
 @abstract 52.配货——筛选终端
 @param agentID  代理商id
 @param token    登录返回
 @param channelID  支付通道id
 @param goodID    pos机id
 @param terminalNumbers  终端号数组
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodTerminalListWithAgentID:(NSString *)agentID
                                        token:(NSString *)token
                                    channelID:(NSString *)channelID
                                       goodID:(NSString *)goodID
                              terminalNumbers:(NSArray *)terminalNumbers
                                         page:(int)page
                                         rows:(int)rows
                                     finished:(requestDidFinished)finish;

/*!
 @abstract 53.配货
 @param userID  登录id
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param channelID  支付通道id
 @param goodID    pos机id
 @param terminalList  终端号数组
 @result finish  请求回调结果
 */
+ (void)prepareGoodWithUserID:(NSString *)userID
                        token:(NSString *)token
                   subAgentID:(NSString *)subAgentID
                    channelID:(NSString *)channelID
                       goodID:(NSString *)goodID
                 terminalList:(NSArray *)terminalList
                     finished:(requestDidFinished)finish;
/*!
 @abstract 54.调货列表
 @param agentID     代理商ID
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getTransferGoodListWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                            subAgentID:(NSString *)subAgentID
                             startTime:(NSString *)startTime
                               endTime:(NSString *)endTime
                                  page:(int)page
                                  rows:(int)rows
                              finished:(requestDidFinished)finish;
/*!
 @abstract 55.调货详情
 @param token    登录返回
 @param transferID  配货id
 @result finish  请求回调结果
 */
+ (void)getTransferGoodDetailWithToken:(NSString *)token
                            transferID:(NSString *)transferID
                              finished:(requestDidFinished)finish;


/*!
 @abstract 55.交易流水获取终端列表
 @param token    登录返回
 @param agentID  代理商id
 @result finish  请求回调结果
 */
+ (void)getTradeTerminalListWithAgentID:(NSString *)agentID
                                  token:(NSString *)token
                               finished:(requestDidFinished)finish;
/*!
 @abstract 57.调货
 @param userID   登录id
 @param token    登录返回
 @param fromAgentID  被调货代理商id
 @param toAgentID    调货代理商id
 @param terminalList 终端号数组
 @result finish  请求回调结果
 */
+ (void)transferGoodWithUserID:(NSString *)userID
                         token:(NSString *)token
                   fromAgentID:(NSString *)fromAgentID
                     toAgentID:(NSString *)toAgentID
                  terminalList:(NSArray *)terminalList
                      finished:(requestDidFinished)finish;

/*!
 @abstract 58.交易流水——获取代理商列表
 @param token    登录返回
 @param agentID  代理商id
 @result finish  请求回调结果
 */
+ (void)getTradeAgentListWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish;

/*!
 @abstract 59.交易流水——查询交易流水
 @param agentID  代理商id
 @param token    登录返回
 @param tradeType  交易类型
 @param terminalNumber  终端号
 @param subAgentID  下级代理商
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getTradeRecordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        tradeType:(TradeType)tradeType
                   terminalNumber:(NSString *)terminalNumber
                       subAgentID:(NSString *)subAgentID
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish;

/*!
 @abstract 60.我的消息列表
 @param agentID  代理商id
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getMyMessageListWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish;

/*!
 @abstract 61.我的消息详情
 @param agentID  代理商id
 @param token    登录返回
 @param messageID  消息id
 @result finish  请求回调结果
 */
+ (void)getMyMessageDetailWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                            messageID:(NSString *)messageID
                             finished:(requestDidFinished)finish;

/*!
 @abstract 62.我的消息单删
 @param agentID  代理商id
 @param token    登录返回
 @param messageID  消息id
 @result finish  请求回调结果
 */
+ (void)deleteSingleMessageWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                             messageID:(NSString *)messageID
                              finished:(requestDidFinished)finish;

/*!
 @abstract 63.我的消息多删
 @param agentID  代理商id
 @param token    登录返回
 @param messageIDs  消息id数组
 @result finish  请求回调结果
 */
+ (void)deleteMultiMessageWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                           messageIDs:(NSArray *)messageIDs
                             finished:(requestDidFinished)finish;

/*!
 @abstract 64.我的消息批量已读
 @param agentID  代理商id
 @param token    登录返回
 @param messageIDs  消息id数组
 @result finish  请求回调结果
 */
+ (void)readMultiMessageWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                         messageIDs:(NSArray *)messageIDs
                           finished:(requestDidFinished)finish;
/*!
 @abstract 67.订单管理——列表
 @param agentID  代理商id
 @param token    登录返回
 @param orderType  订单类型
 @param keyword    关键字
 @param status     订单状态
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getOrderListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                      orderType:(OrderType)orderType
                        keyword:(NSString *)keyword
                         status:(int)status
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;
/*!
 @abstract 68.订单管理——批购列表  71.代购列表
 @param token    登录返回
 @param supplyType  批购还是代购
 @param orderID    订单id
 @result finish  请求回调结果
 */
+ (void)getOrderDetailWithToken:(NSString *)token
                      orderType:(SupplyGoodsType)supplyType
                        orderID:(NSString *)orderID
                       finished:(requestDidFinished)finish;
/*!
 @abstract 69.订单管理——取消批购订单
 @param token    登录返回
 @param orderID    订单id
 @result finish  请求回调结果
 */
+ (void)cancelWholesaleOrderWithToken:(NSString *)token
                              orderID:(NSString *)orderID
                             finished:(requestDidFinished)finish;
/*!
 @abstract 72.订单管理——取消代购订单
 @param token    登录返回
 @param orderID    订单id
 @result finish  请求回调结果
 */
+ (void)cancelProcurementOrderWithToken:(NSString *)token
                                orderID:(NSString *)orderID
                               finished:(requestDidFinished)finish;

/*!
 @abstract 73.售后单列表  76.注销记录列表 80.更新记录列表
 @param agentID  代理商id
 @param token    登录返回
 @param type     售后类型
 @param keyword  搜索关键字
 @param status   订单状态
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getCSListWithAgentID:(NSString *)agentID
                       token:(NSString *)token
                      csType:(CSType)type
                     keyword:(NSString *)keyword
                      status:(int)status
                        page:(int)page
                        rows:(int)rows
                    finished:(requestDidFinished)finish;

/*!
 @abstract 74.售后单取消申请  77.注销记录取消申请 82.更新记录取消申请
 @param token    登录返回
 @param type     售后类型
 @param csID     售后单id
 @result finish  请求回调结果
 */
+ (void)csCancelApplyWithToken:(NSString *)token
                        csType:(CSType)type
                          csID:(NSString *)csID
                      finished:(requestDidFinished)finish;

/*!
 @abstract 75.售后单详情 79.注销记录详情 81.更新记录详情
 @param token    登录返回
 @param type     售后类型
 @param csID     售后单id
 @result finish  请求回调结果
 */
+ (void)getCSDetailWithToken:(NSString *)token
                      csType:(CSType)type
                        csID:(NSString *)csID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 78.售后记录——重新提交注销
 @param token    登录返回
 @param csID     售后单id
 @result finish  请求回调结果
 */
+ (void)csRepeatAppleyWithToken:(NSString *)token
                           csID:(NSString *)csID
                       finished:(requestDidFinished)finish;


/*!
 @abstract 80.我的信息——获取详情
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getPersonDetailWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish;

/*!
 @abstract 81.我的信息——获取修改手机验证码
 @param agentID  代理商id
 @param token    登录返回
 @param phoneNumber  手机号
 @result finish  请求回调结果
 */
+ (void)getPersonModifyMobileValidateWithAgentID:(NSString *)agentID
                                           token:(NSString *)token
                                     phoneNumber:(NSString *)phoneNumber
                                        finished:(requestDidFinished)finish;

/*!
 @abstract 82.我的信息——修改手机
 @param agentID  代理商id
 @param token    登录返回
 @param phoneNumber  新手机号码
 @param validate  验证码
 @result finish  请求回调结果
 */
+ (void)modifyPersonMobileWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                       newPhoneNumber:(NSString *)phoneNumber
                             validate:(NSString *)validate
                             finished:(requestDidFinished)finish;

/*!
 @abstract 83.我的信息——获取修改邮箱验证码
 @param agentID  代理商id
 @param token    登录返回
 @param email    邮箱
 @result finish  请求回调结果
 */
+ (void)getPersonModifyEmailValidateWithAgentID:(NSString *)agentID
                                          token:(NSString *)token
                                          email:(NSString *)email
                                       finished:(requestDidFinished)finish;

/*!
 @abstract 84.我的信息——修改邮箱
 @param agentID  代理商id
 @param token    登录返回
 @param email    新邮箱
 @param validate 验证码
 @result finish  请求回调结果
 */
+ (void)modifyPersonEmailWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            newEmail:(NSString *)email
                            validate:(NSString *)validate
                            finished:(requestDidFinished)finish;

/*!
 @abstract 88.我的信息——修改密码
 @param agentID  代理商id
 @param token    登录返回
 @param primaryPassword   原密码
 @param newPassword   新密码
 @result finish  请求回调结果
 */
+ (void)modifyPasswordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                  primaryPassword:(NSString *)primaryPassword
                      newPassword:(NSString *)newPassword
                         finished:(requestDidFinished)finish;
/*!
 @abstract 89.我的信息——地址列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getAddressListWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                         finished:(requestDidFinished)finish;



/*!
 @abstract 90.我的信息——新增地址
 @param agentID  代理商id
 @param token    登录返回
 @param cityID   城市id
 @param receiverName   收件人姓名
 @param phoneNumber    收件人手机
 @param zipCode  邮政编码
 @param address  详细地址
 @param addressType    是否默认地址
 @result finish  请求回调结果
 */
+ (void)addAddressWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                       cityID:(NSString *)cityID
                 receiverName:(NSString *)receiverName
                  phoneNumber:(NSString *)phoneNumber
                      zipCode:(NSString *)zipCode
                      address:(NSString *)address
                    isDefault:(AddressType)addressType
                     finished:(requestDidFinished)finish;

/*!
 @abstract 91.我的信息——批量删除地址
 @param token    登录返回
 @param addressIDs   地址id数组
 @result finish  请求回调结果
 */
+ (void)deleteAddressWithToken:(NSString *)token
                    addressIDs:(NSArray *)addressIDs
                      finished:(requestDidFinished)finish;

/*!
 @abstract 91.a.修改地址
 @param token       登录返回
 @param addressID   地址ID
 @param cityID    城市id
 @param receiverName   收件人姓名
 @param phoneNumber   收件人电话
 @param zipCode   邮编
 @param address   详细地址
 @param addressType  是否默认地址
 @result finish  请求回调结果
 */
+ (void)updateAddressWithToken:(NSString *)token
                     addressID:(NSString *)addressID
                        cityID:(NSString *)cityID
                  receiverName:(NSString *)receiverName
                   phoneNumber:(NSString *)phoneNumber
                       zipCode:(NSString *)zipCode
                       address:(NSString *)address
                     isDefault:(AddressType)addressType
                      finished:(requestDidFinished)finish;


/*!
 @abstract 92.下级代理商管理——列表
 @param agentID  代理商id
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getSubAgentListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;
/*!
 @abstract 95.下级代理商管理——设置默认分润
 @param agentID  代理商id
 @param token    登录返回
 @param precent  分润比例
 @result finish  请求回调结果
 */
+ (void)setDefaultBenefitWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                             precent:(CGFloat)precent
                            finished:(requestDidFinished)finish;

//提交物流
+ (void)submitLogistWithAgentID:(NSString *)agentID
                                csID:(NSString *)csID
                          logistName:(NSString *)logistname
                           logistNum:(NSString *)logistnum
                            finished:(requestDidFinished)finish;
//员工管理列表
+ (void)getStaffListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;
//删除员工
+ (void)deleteStaffWithAgentID:(NSString *)agentID
                         Token:(NSString *)token
                       loginID:(NSString *)loginID
                       staffID:(NSString *)staffID
                      finished:(requestDidFinished)finish;
//创建员工
+ (void)createStaffWithAgentID:(NSString *)agentID
                         Token:(NSString *)token
                       LoginID:(NSString *)loginID
                      UserName:(NSString *)userName
                         Roles:(NSMutableString *)roles
                      Password:(NSString *)password
                  MakePassword:(NSString *)makepassword
                      finished:(requestDidFinished)finish;
//获取详情
+ (void)getStaffDetailWithAgentID:(NSString *)agentID
                           Token:(NSString *)token
                         staffID:(NSString *)staffID
                        finished:(requestDidFinished)finish;
//修改详情
+ (void)changeStaffWithAgentID:(NSString *)agentID
                         Token:(NSString *)token
                       LoginID:(NSString *)loginID
                         Roles:(NSMutableString *)roles
                      Password:(NSString *)password
                      finished:(requestDidFinished)finish;
/*!
 @abstract 93.下级代理商管理——详情
 @param token    登录返回
 @param subAgentID 下级代理商id
 @result finish  请求回调结果
 */
+ (void)getSubAgentDetailWithToken:(NSString *)token
                        subAgentID:(NSString *)subAgentID
                          finished:(requestDidFinished)finish;
/*!
 @abstract 94.下级代理商管理——创建
 @param agentID      登录代理商id
 @param token        登录返回
 @param username      用户名
 @param password      密码
 @param encrypt       是否已加密
 @param agentType     1.公司  2.个人
 @param companyName   公司名称
 @param licenseID     公司营业执照号
 @param taxID         公司税务证号
 @param legalPersonName  负责人姓名
 @param legalPersonID    负责人身份证号
 @param mobileNumber     手机
 @param email            邮箱
 @param cityID        城市id
 @param address       详细地址
 @param cardImagePath    身份证照片
 @param licenseImagePath 营业执照照片
 @param taxImagePath     税务证照片
 @result finish  请求回调结果
 */
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
                         finished:(requestDidFinished)finish;

/*!
 @abstract 96.下级代理商管理——获取分润列表
 @param token    登录返回
 @param subAgentID  下级代理商id
 @result finish  请求回调结果
 */
+ (void)getBenefitListWithToken:(NSString *)token
                     subAgentID:(NSString *)subAgentID
                       finished:(requestDidFinished)finish;
/*!
 @abstract 97.下级代理商管理——设置分润
 @param agentID  代理商id
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param channelID   支付通道id
 @param profit     分润比例
 @param type     0.修改分润  1.新增分润
 @result finish  请求回调结果
 */
+ (void)submitBenefitWithAgentID:(NSString *)agentID
                           token:(NSString *)token
                      subAgentID:(NSString *)subAgentID
                       channelID:(NSString *)channelID
                          profit:(NSString *)profit
                            type:(int)benefitType
                        finished:(requestDidFinished)finish;

/*!
 @abstract 98.下级代理商管理——删除分润
 @param agentID  代理商id
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param channelID  支付通道id
 @result finish  请求回调结果
 */
+ (void)deleteBenefitWithAgentID:(NSString *)agentID
                           token:(NSString *)token
                      subAgentID:(NSString *)subAgentID
                       channelID:(NSString *)channelID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 99.下级代理商管理——支付通道
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getAgentChannelListWithToken:(NSString *)token
                            finished:(requestDidFinished)finish;
/*!
 @abstract 下级代理商管理——获取消费类型
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getTradeTypeWithToken:(NSString *)token
                    channelID:(NSString *)channelID
                     finished:(requestDidFinished)finish;
/*!
 @abstract 订单信息
 @result finish  请求回调结果
 */
+ (void)orderConfirmWithOrderID:(NSString *)orderID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 下级代理商管理——获取默认分润
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getDefaultBenefitWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish;
/*!
 @abstract 首页轮播图
 @result finish  请求回调结果
 */
+ (void)getHomeImageListFinished:(requestDidFinished)finish;

/*!
 @abstract 100.下级代理商管理——上传图片
 @param image       图片
 @result finish  请求回调结果
 */
+ (void)uploadSubAgentImageWithAgentID:(NSString *)agentID
                                 image:(UIImage *)image
                              finished:(requestDidFinished)finish;
/*!
 @abstract 50.配货——POS列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodPOSWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish;
/*!
 @abstract 设置是否分润
 @param agentID  代理商id
 @param subAgentID    登录返回
 @param benefit  1.无 2.有
 @result finish  请求回调结果
 */
+ (void)setHasBenefitWithAgentID:(NSString *)agentID
                      subAgentID:(NSString *)subAgentID
                      hasBenefit:(int)benefit
                        finished:(requestDidFinished)finish;

+ (void)getAllUserWithAgentID:(NSString *)agentID
                      keyword:(NSString *)keyword
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;
+ (void)sendFindValidateWithMobileNumber:(NSString *)mobileNumber
                                finished:(requestDidFinished)finish;

+ (void)checkVersionFinished:(requestDidFinished)finish;


@end
