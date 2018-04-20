//
//  Product.h
//  NewSearchDemo
//
//  Created by Macmini on 2018/4/18.
//  Copyright © 2018年 Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *yearIntroduced;
@property (nonatomic, strong) NSNumber *introPrice;

+ (Product *)productWithName:(NSString *)name
                        year:(NSNumber *)year
                       price:(NSNumber *)price;
@end
