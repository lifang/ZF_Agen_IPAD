//
//  NextAgentdetalViewController.h
//  ZF_Agent_IPad
//
//  Created by comdosoft on 15/4/17.
//  Copyright (c) 2015年 comdo. All rights reserved.
//

#import "ScanImageViewController.h"
#import "SubAgentModel.h"

@interface NextAgentdetalViewController : ScanImageViewController

{UIButton*openbutton;

    UIButton *filterButton;


}
@property (nonatomic, strong) SubAgentModel *subAgent;

@end
