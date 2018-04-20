//
//  MainTableViewController.m
//  NewSearchDemo
//
//  Created by Macmini on 2018/4/18.
//  Copyright © 2018年 Macmini. All rights reserved.
//

#import "MainTableViewController.h"
#import "ResultsTableViewController.h"
#import "Product.h"

@interface MainTableViewController ()<UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ResultsTableViewController *resultController;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"DEMO Search";
    
    self.resultController = [[ResultsTableViewController alloc] init];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    
    if ([self.navigationItem respondsToSelector:@selector(setSearchController:)]) {
        // For iOS 11 and later, we place the search bar in the navigation bar.
        if (@available(iOS 11.0, *)) {
            self.navigationController.navigationBar.prefersLargeTitles = YES;
            self.navigationItem.searchController = self.searchController;
            self.navigationItem.hidesSearchBarWhenScrolling = NO; // 上下滚动时是否隐藏搜索框
        }
    } else {
        // For iOS 10 and earlier, we place the search bar in the table view's header.
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
    // 点击搜索后 显示搜索列表控制器后 是否需要 蒙版层(默认需要)
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    
    /* 官网解释: Search is now just presenting a view controller. As such, normal view controller
     presentation semantics apply. Namely that presentation will walk up the view controller
     hierarchy until it finds the root view controller or one that defines a presentation context.
     */
    // UISearchController 搜索框展开的过程其实就是 SearchBar 触发了一个 “presentViewController” 的动作. 在触发到搜索状态下的控制器时, 点击跳转到另外一个控制器上时, Yes:包含了导航栏, 反之没有.
    self.definesPresentationContext = YES;  // Know where you want UISearchController to be displayed.
}


#pragma mark - UISearchResultsUpdating
// 点击搜索框后, 输入搜索文本后 响应
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 模拟搜索数据(这里进行输入的文本进行数据源的过滤后, 显示新数据源)
    
    // 当前输入的文本
    NSString *searchText = searchController.searchBar.text;
    
    // 去掉前部与尾部的空格
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 根据有一个空格为分界, 分离出字符串
    NSArray *singleLetters = nil;
    if (searchText.length > 0) {
        singleLetters = [strippedString componentsSeparatedByString:@" "];
    }
    // 对每个分离出来的字符串 进行过滤匹配 得到对应字符串过滤下的NSPredicate(谓词)对象数组
    // 搜索条件可以根据 价格, title, 年份(Product模型中的字段值)
    NSArray *andMatchPredicates = [self findMatches:singleLetters]; // 将要用于 and谓词
    
    // 复合谓词 利用 and, 因为数据模型中字段必须同时包含有所搜索的key, 所以要用and.
    NSCompoundPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    
    // 根据复合谓词(谓词表达式) 进行过滤
    NSArray *filteredArray = [self.products filteredArrayUsingPredicate:andPredicate];
    ResultsTableViewController *resultVC = (ResultsTableViewController *)self.searchController.searchResultsController;
    resultVC.filteredArray = filteredArray;
    [resultVC.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
// 点击键盘右下角search按钮响应代理事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifire];
    
    Product *product = self.products[indexPath.row];
    
    [self configureCell:cell forProduct:product];
    
    return cell;
}


#pragma mark -
- (NSArray *)findMatches:(NSArray *)singleLetters {
    // 谓词表达式: title CONTAINS[c] "I"   // title为模型中的字段名, "I"输入的文本.
    // title/introPrice/yearIntroduced CONTAINS[c] "xxx"

    NSMutableArray *resultCompoundPredicates = [NSMutableArray array];
    
    for (NSString *singleLetter in singleLetters) {
        
        NSMutableArray *singleLetterPredicates = [NSMutableArray array];
        
        // 1.模型中 title进行匹配
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"]; // 左边表达式 title
        NSExpression *rhs = [NSExpression expressionForConstantValue:singleLetter]; // 右边表达式. CONTAINS[c] "I"
        NSPredicate *finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSDirectPredicateModifier type:NSContainsPredicateOperatorType options:NSCaseInsensitivePredicateOption];
        [singleLetterPredicates addObject:finalPredicate]; // 执行完这句会生成一个类似: title CONTAINS[c] "I" 谓词表达式的谓词对象
        
        // 2.模型中 价格/年份(NSnumber *) 由于两个字段都是数字
        // NSNumberFormatterNoStyle
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *targetNumber = [numberFormatter numberFromString:singleLetter];
        
        if (targetNumber != nil) {
            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            
            finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:NSCaseInsensitivePredicateOption];
            [singleLetterPredicates addObject:finalPredicate];
            
            
            
            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            
            finalPredicate = [NSComparisonPredicate predicateWithLeftExpression:lhs rightExpression:rhs modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:NSCaseInsensitivePredicateOption];
            [singleLetterPredicates addObject:finalPredicate];
        }
        
        // 复合谓词, 把以上字符串对应匹配下的谓词对象存放在数组中 (这里我们用 or, 因为只要数据源模型中title包含有文本中某个字母/文字等, 所以用or)
        /*
         例如，下列谓词是相等的：
         // 用到了 AND 复合谓词
         [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"age > 25"], [NSPredicate predicateWithFormat:@"firstName = %@", @"Quentin"]]];
         
         [NSPredicate predicateWithFormat:@"((age > 25) AND (firstName = %@))", @"Quentin"];
         */
        NSCompoundPredicate *orPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:singleLetterPredicates];
        [resultCompoundPredicates addObject:orPredicate];
    }
    
    return resultCompoundPredicates;
}
@end
