//
//  ArrayDataSource.m
//  DoubanFM
//
//  Created by wangwangwar on 14/12/1.
//  Copyright (c) 2014年 wangwangwar. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource ()

@property (nonatomic) NSArray *items;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) void (^configureCell)(id cell, id item);

@end

@implementation ArrayDataSource

#pragma mark - Initializations

- (instancetype)initWithItems:(NSArray *)items
                        cellIdentifier:(NSString *)cellIdentifier
                    configureCellBlock:(void (^)(id cell, id item))configureCell {
    self = [super init];
    if (self) {
        _items = items;
        _cellIdentifier = cellIdentifier;
        _configureCell = configureCell;
    }
    
    return self;
}

#pragma mark - Operations

- (void)setItems:(NSArray *)items {
    _items = items;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[(NSUInteger)indexPath.row];
}

#pragma mark - Table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    _configureCell(cell, item);
    
    return cell;
}

@end
