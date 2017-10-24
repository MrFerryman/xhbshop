//
//  XHJudgeBankCardNumber.m
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/22.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

#import "XHJudgeBankCardNumber.h"

@implementation XHJudgeBankCardNumber
+ (BOOL)judgeBankCardNumberWithString: (NSString *) number {
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[number length];
    int lastNum = [[number substringFromIndex:cardNoLength-1] intValue];
    
    number = [number substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [number substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;  
    allsum += lastNum;  
    if((allsum % 10) == 0)  
        return YES;  
    else  
        return NO;
}
@end
