//
//  TodoCell.m
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import "TodoCell.h"
#import "../constants/Constants.h"
@implementation TodoCell
- (instancetype)initCellWithTask:(Task *)task
            cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        tableView:(UITableView *)tableView
                   cellIdentifier:(NSString *)identifier {
    TodoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                       forIndexPath:indexPath];
    cell.title.text = task.title;
    UIImage *img ;
    switch (task.periority) {
        case LOW_PERIORITY:
            img = [UIImage imageNamed:LOW_STATUS_IMG];
            break;
        case MEDIUM_PERIORITY:
            img = [UIImage imageNamed:MEDIUM_STATUS_IMG];
            break;
        case HEIGHT_PERIORITY:
            img = [UIImage imageNamed:HEIGHT_STATUS_IMG];
            break;
        default:
            break;
    }
    cell.leadingImage.image = [self resizeImg:img withSize:CGSizeMake(40, 40)];
    if(task.status == DONE_STATUS){
        cell.trailingImage.image = [self resizeImg:[UIImage imageNamed:DONE_IMG] withSize:CGSizeMake(20, 20) ];
    }
    return cell;
}

-(UIImage*)resizeImg:(UIImage*)img withSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:newSize.width / 2.0];
    [path addClip];
    [img drawInRect:rect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}
@end
