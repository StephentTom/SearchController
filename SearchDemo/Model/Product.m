//
//  Product.m
//  NewSearchDemo
//
//  Created by Macmini on 2018/4/18.
//  Copyright © 2018年 Macmini. All rights reserved.
//

#import "Product.h"

@implementation Product

+ (Product *)productWithName:(NSString *)name
                        year:(NSNumber *)year
                       price:(NSNumber *)price {
    Product *newProduct = [[self alloc] init];
    newProduct.title = name;
    newProduct.yearIntroduced = year;
    newProduct.introPrice = price;
    
    return newProduct;
}
@end
