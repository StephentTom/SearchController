//
//  BaseTableViewController.m
//  NewSearchDemo
//
//  Created by Macmini on 2018/4/19.
//  Copyright © 2018年 Macmini. All rights reserved.
//  由于main/搜索结果result控制器呈现的cell一样, 所以这里用继承基础控制器, 做相同事件.

#import "BaseTableViewController.h"
#import "Product.h"


@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:kCellIdentifire];
}

- (void)configureCell:(UITableViewCell *)cell forProduct:(Product *)product {
    /*
     typedef NS_ENUM(NSUInteger, NSNumberFormatterStyle) {
     NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle, // 无类型  123456
     
     NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle, // 123,456.023 (小数点后面最多3位)
     
     NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle, // 货币 $ 123,456.02(会根据手机语言不同会改变)
     
     NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle, // 12,345,602%
     
     NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,// 1.2345602322E5
     
     NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle, // 十二万三千四百五十六点〇二三二二
     
     NSNumberFormatterOrdinalStyle = kCFNumberFormatterOrdinalStyle, //  第12,3456
     
     NSNumberFormatterCurrencyISOCodeStyle = kCFNumberFormatterCurrencyISOCodeStyle, // USD 123,456.02
     
     NSNumberFormatterCurrencyPluralStyle = kCFNumberFormatterCurrencyPluralStyle, // 123,456.02美元
     
     NSNumberFormatterCurrencyAccountingStyle = kCFNumberFormatterCurrencyAccountingStyle, // US$123,456.02
     };
     */
    
    cell.textLabel.text = product.title;
    
    // 为价格添加 货币符号
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle; // 货币 $ 123,456.02(会根据手机语言不同会改变)
    NSString *priceString = [numberFormatter stringFromNumber:product.introPrice];
    
    NSString *appendingString = [NSString stringWithFormat:@"%@ | %@", priceString, [product.yearIntroduced stringValue]];
    
    cell.detailTextLabel.text = appendingString;
}
@end
