//
//  BaseTableViewController.h
//  NewSearchDemo
//
//  Created by Macmini on 2018/4/19.
//  Copyright © 2018年 Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;

static NSString *const kCellIdentifire = @"ProductCell";

@interface BaseTableViewController : UITableViewController

- (void)configureCell:(UITableViewCell *)cell forProduct:(Product *)product;
@end
