//
//  ViewController.m
//  XLTest
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 xinle. All rights reserved.
//

typedef int(^TextXLBlock)(void);
#import "ViewController.h"
#import "MyDetailViewController.h"
#import "WebTableViewController.h"
#import "SuperClass.h"
//#import "SuperClass+UserMethod.h"
#import "SubClass1.h"

@interface ViewController ()

@property (nonatomic, strong)NSString *str1;
@property (nonatomic, copy)NSString *str2;

@property (nonatomic, strong)NSMutableString *mStr1;
@property (nonatomic, copy)NSMutableString *mStr2;

@property (nonatomic, strong)NSArray *arr1;
@property (nonatomic, copy)NSArray *arr2;

@property (nonatomic, strong)UILabel *lbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
LOG(@"~~~~");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 从一个加权数组随机取出1ge
 parm:
 1.weightArr 加权数组[@"唯一标识符":@"权重,统一处理成整数",...]
 示例:[@{@"A":@"3"},@{@"B":@"4"},@{@"C":@"1"},@{@"D":@"2"},@{@"E":@"1"},]
 */
-(NSString *)getRadomKeyWithWeightArr:(NSArray <NSDictionary *>*)weightArr{
    
    weightArr = [weightArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary*  _Nonnull obj1, NSDictionary*  _Nonnull obj2) {
        
        if ([obj1.allValues.firstObject integerValue] >= [obj2.allValues.firstObject integerValue]) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray *keyArr = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *valueArr = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in weightArr) {
        NSString *key = dic.allKeys.firstObject;
        [keyArr addObject:key];
        [valueArr addObject:dic[key]];
    }
    
    NSInteger sum = 0;
    NSMutableArray *weightSumArr = [NSMutableArray arrayWithCapacity:1];
    for (NSString *weightValue in valueArr) {
        sum = sum + weightValue.integerValue;
        [weightSumArr addObject:@(sum)];
    }
    
    long randomValue = random()%(sum - 0 + 1) + 0;
    NSNumber *index;
    for (int i = 0; i < weightSumArr.count - 1; i++) {
        if (randomValue <= [weightSumArr[i] longValue]) {
            index = @(i);
            break;
        }else{
            if (randomValue <= [weightSumArr[i + 1] longValue]) {
                index = @(i + 1);
                break;
            }
        }
    }
    
    return keyArr[index.integerValue];
}



/**
 从一个加权数组随机取出n个数的新数组(加权随机数)
 parm:
 1.weightArr 加权数组[@"唯一标识符":@"权重,统一处理成整数",...]
 示例:[@{@"A":@"3"},@{@"B":@"4"},@{@"C":@"1"},@{@"D":@"2"},@{@"E":@"1"},]
 2.resultCount 最终结果的个数
 */
-(NSArray *)getRadomArrWithWeightArr:(NSArray <NSDictionary *>*)weightArr ResultArrCount:(NSInteger)resultCount{
    
    NSMutableSet *mSet = [NSMutableSet setWithCapacity:1];
    while (mSet.count < resultCount) {
        NSString *key = [self getRadomKeyWithWeightArr:weightArr];
        [mSet addObject:key];
    }
    return mSet.allObjects;
}

int a = 1;
static int b = 2;

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    NSMutableArray *blockArr = [NSMutableArray arrayWithCapacity:1];
//    for (int i = 0; i < 3; i++) {
//        __block TextXLBlock block = ^(){
//            return i * i;
//        };
//        [blockArr addObject:block];
//    }
//
//    TextXLBlock b0 = blockArr[0];
//    TextXLBlock b1 = blockArr[1];
//    TextXLBlock b2 = blockArr[2];
//
//
//    NSLog(@"~%i~%i~%i",b0(),b1(),b2());
    
//    MyDetailViewController *vc = [[MyDetailViewController alloc] init];
//    vc.returnBlock = ^(NSString * str) {
//        NSLog(@"~~~~我就想看看block用strong会不会崩溃:%@",str);
//    };
    
//    WebTableViewController *vc = [[WebTableViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];
    
    
//#*************************************************************
//    NSArray *weightArr = @[@{@"A":@"30"},@{@"B":@"40"},@{@"C":@"10"},@{@"D":@"20"},@{@"E":@"10"},];
//    //1.0
//    NSInteger sumA = 0,sumB = 0,sumC = 0,sumD = 0,sumE = 0;
//    for (int i = 0; i < 110000; i++) {
//        NSString *key = [self getRadomKeyWithWeightArr:weightArr];
//        if ([key isEqualToString:@"A"]) {
//            sumA ++;
//        }else if ([key isEqualToString:@"B"]){
//            sumB ++;
//        }else if ([key isEqualToString:@"C"]){
//            sumC ++;
//        }else if ([key isEqualToString:@"D"]){
//            sumD ++;
//        }else if ([key isEqualToString:@"E"]){
//            sumE ++;
//        }
//    }
//    NSString *str = [NSString stringWithFormat:@" A:%li\n B:%li\n C:%li\n D:%li\n E:%li\n ",(long)sumA,(long)sumB,(long)sumC,(long)sumD,(long)sumE];
//    NSLog(@"验证取数概率的测试结果\n%@",str);
//    //2.0
//    NSArray *resultArr = [self getRadomArrWithWeightArr:weightArr ResultArrCount:3];
//    NSLog(@"取数出对应个数:\n%@",resultArr);
    
    
    
    
//    int c = 3;
//    static int d = 4;
//    NSMutableString *str = [[NSMutableString alloc]initWithString:@"hello"];
//    void (^blk)(void) = ^{
//        a++;
//        b++;
//        d++;
//        [str appendString:@"world"];
//        NSLog(@"1----------- a = %d,b = %d,c = %d,d = %d,str = %@",a,b,c,d,str);
//    };
//
//    a++;
//    b++;
//    c++;
//    d++;
//    str = [[NSMutableString alloc]initWithString:@"haha"];
//    NSLog(@"2----------- a = %d,b = %d,c = %d,d = %d,str = %@",a,b,c,d,str);
//    blk();
    
  
    
//    UILabel *label = [[UILabel alloc] init];
//    label.tag = 100;
//    label.text = @"label";
//    label.textColor =[UIColor redColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:15];
//    label.frame = CGRectMake(100, 100, 80, 30);
//    [self.view addSubview:label];
//    self.lbl = label;
//
//    label.text = @"XLLabel";
//
////    NSString *str = @"~~~NSString~~~";
////    self.str1 = str;
////    self.str2 = str;
////    self.mStr1 = str;
////    self.mStr2 = str;
////    NSLog(@"str1:%@,str2:%@",self.str1,self.str2);
////    NSLog(@"mStr1:%@,mStr2:%@",self.mStr1,self.mStr2);
////
////    str = @"~~~NSString修改~~~";
////    NSLog(@"str1:%@,str2:%@",self.str1,self.str2);
////    NSLog(@"mStr1:%@,mStr2:%@",self.mStr1,self.mStr2);
////
////    NSMutableString *mStr = [NSMutableString stringWithString:@"~~~NSMutableString~~~"];
////    self.mStr1 = mStr;
////    self.mStr2 = mStr;
////    self.str1 = mStr;
////    self.str2 = mStr;
////    NSLog(@"mStr1:%@,mStr2:%@",self.mStr1,self.mStr2);
////    NSLog(@"str1:%@,str2:%@",self.str1,self.str2);
////
////    [mStr appendString:@"修改"];
////    NSLog(@"mStr1:%@,mStr2:%@",self.mStr1,self.mStr2);
////    NSLog(@"str1:%@,str2:%@",self.str1,self.str2);
////
//    NSString *str = @"~~~NSString~~~";
//    NSMutableString *mStr = [NSMutableString stringWithString:@"~~~NSMutableString~~~"];
//
//    NSArray *arr = @[str,mStr];
//    self.arr1 = arr;
//    self.arr2 = [NSMutableArray arrayWithArray:arr];
//    NSLog(@"arr:%@,arr2%@",self.arr1,self.arr2);
//
//    str = @"我修改了";
//    [mStr appendString:@"哈哈哈"];
//    NSLog(@"arr:%@,arr2%@",self.arr1,self.arr2);
    
    
//    SuperClass *sClass = [[SuperClass alloc] init];
//    SubClass1 *sub1 = [[SubClass1 alloc] init];
//
//    [sClass userMethod];
//    [sub1 userMethod];
    
    NSLog(@"%li",(long)[self getValLocationWithVal:7 InArr:@[@(1),@(2),@(5),@(5),@(6),@(7),@(8)]]);
    
}

-(BOOL)isSuSHuWithNum:(NSInteger)num{
    
    BOOL isSuShu = NO;
    if (num <= 1) {
        isSuShu = NO;
    }else{
        
        for (int i = 2; i < num; i++) {
            if (num % i == 0) {
                isSuShu = YES;
                break;
            }
        }
    }
    
    return isSuShu;
}

-(void)showNineNine{
    
    NSInteger num = 9;
    for (int i = 1; i <= num; i++) {
        
        NSString *str = @"";
        for (int j = 1; j <= i; j++) {
            str = [NSString stringWithFormat:@"%@ %i*%i=%i",str,j,i,(i*j)];
        }
        NSLog(@"%@\n", str);
    }
}

-(NSInteger)getFactorialWithNum:(NSInteger)num{
    
    NSInteger result;
    if (num <= 0) {
        return -1;//error
    }
    
    if (num == 1) {
        return 1;
    }else{
        result = num * [self getFactorialWithNum:(num - 1)];
        return result;
    }
}

-(BOOL)isJingXiangWithStr:(NSString *)str1 Str2:(NSString *)str2{
    
    if (str1.length != str2.length) {
        return NO;
    }else{
        
        BOOL isJingXiang = YES;
        NSInteger length = str1.length;
        for (int i = 0; i < length; i++) {
            
            NSString *singleStr1 = [str1 substringWithRange:NSMakeRange(i, 1)];
            NSString *singleStr2 = [str2 substringWithRange:NSMakeRange(length - i - 1, 1)];
            if (![singleStr1 isEqualToString:singleStr2]) {
                isJingXiang = NO;
                break;
            }
        }
        return isJingXiang;
    }
}

-(NSInteger)getValLocationWithVal:(NSInteger)val InArr:(NSArray<NSNumber *> *)arr{
    
    if (![arr containsObject:@(val)]) {
        return -1;
    }else{
        
        NSInteger count = arr.count;
        NSInteger beginLoc = 0;
        NSInteger endLoc = count;
        while (beginLoc < endLoc) {
            
            NSInteger loc = (beginLoc + endLoc) / 2;
            if (val < [arr[loc] integerValue]) {
                endLoc = loc;
            }else if (val > [arr[loc] integerValue]) {
                beginLoc = loc;
            }else{
                
                if (loc > 1) {
                    while ([arr[loc] integerValue] == [arr[loc - 1] integerValue]) {
                        loc--;
                    }
                }
                beginLoc = loc;
                endLoc = loc;
                
            }
        }
        return beginLoc;
    }
}

//OC中的链表是什么概念?

@end
