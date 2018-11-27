//  SDAssetsTableViewControllerCellModel.h
//  GSD_ZHIFUBAO
//  Created by Super on 15-6-4.
/*
 
 *********************************************************************************
 *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 *********************************************************************************
 */
#import <Foundation/Foundation.h>
@interface SDAssetsTableViewControllerCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconImageName;
@property (nonatomic, copy) Class destinationControllerClass;
+ (instancetype)modelWithTitle:(NSString *)title iconImageName:(NSString *)iconImageName destinationControllerClass:(Class)destinationControllerClass;
@end
