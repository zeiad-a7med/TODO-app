//
//  TodoCell.h
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "../Models/Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface TodoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *leadingImage;
@property (weak, nonatomic) IBOutlet UIImageView *trailingImage;
- (instancetype)initCellWithTask:(Task *)task
            cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        tableView:(UITableView *)tableView
                   cellIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
