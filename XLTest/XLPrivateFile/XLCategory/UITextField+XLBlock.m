//
//  UITextField+XLBlock.m
//  ZJNews
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 FXEYE. All rights reserved.
//

#import "UITextField+XLBlock.h"
#import <objc/runtime.h>

@implementation UITextField (XLBlock)


-(void)addAactionBlock:(TextFieldStrBlock)block forControlEvents:(UIControlEvents)event{
    
    __weak typeof(self) weakSelf = self;
    if (event == UIControlEventEditingDidBegin) {
        [self addTarget:weakSelf action:@selector(textEditingDidBegin:) forControlEvents:(event)];
        if (block) {
            objc_setAssociatedObject(self, "textEditingDidBegin:", block, OBJC_ASSOCIATION_COPY);//KVC增加示例变量
        }
    }else if (event == UIControlEventEditingChanged){
        [self addTarget:weakSelf action:@selector(textEditingChanged:) forControlEvents:(event)];
        if (block) {
            objc_setAssociatedObject(self, "textEditingChanged:", block, OBJC_ASSOCIATION_COPY);//KVC增加示例变量
        }
    }else if (event == UIControlEventEditingDidEnd){
        [self addTarget:weakSelf action:@selector(textEditingDidEnd:) forControlEvents:(event)];
        if (block) {
            objc_setAssociatedObject(self, "textEditingDidEnd:", block, OBJC_ASSOCIATION_COPY);//KVC增加示例变量
        }
    }else if (event == UIControlEventEditingDidEndOnExit){
        [self addTarget:weakSelf action:@selector(textEditingDidEndOnExit:) forControlEvents:(event)];
        if (block) {
            objc_setAssociatedObject(self, "textEditingDidEndOnExit:", block, OBJC_ASSOCIATION_COPY);//KVC增加示例变量
        }
    }
}

-(void)textEditingDidBegin:(UITextField *)tf{
    TextFieldStrBlock block = objc_getAssociatedObject(self, "textEditingDidBegin:");
    block(tf.text);
}

-(void)textEditingChanged:(UITextField *)tf{
    TextFieldStrBlock block = objc_getAssociatedObject(self, "textEditingChanged:");
    block(tf.text);
}

-(void)textEditingDidEnd:(UITextField *)tf{
    TextFieldStrBlock block = objc_getAssociatedObject(self, "textEditingDidEnd:");
    block(tf.text);
}

-(void)textEditingDidEndOnExit:(UITextField *)tf{
    TextFieldStrBlock block = objc_getAssociatedObject(self, "textEditingDidEndOnExit:");
    block(tf.text);
}

@end
