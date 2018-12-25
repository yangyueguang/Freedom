//
//  RCDPushSettingViewController.m
//  RCloudMessage
//
//  Created by Jue on 2016/12/26.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDPushSettingViewController.h"
#import "RCDBaseSettingTableViewCell.h"
#import <RongIMKit/RongIMKit.h>

@interface RCDPushSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource, RCDBaseSettingTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIPickerView *pickerView;
@end
@implementation RCDPushSettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
  self.navigationItem.title = @"推送设置";
    UIButton *buttonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 87, 23)];
    [buttonItem setImage:[UIImage imageNamed:@"navigator_btn_back"] forState:UIControlStateNormal];
    [buttonItem setTitle:@"我" forState:UIControlStateNormal];
    [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonItem addTarget:self action:@selector(cilckBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
  
  self.tableView = [[UITableView alloc] init];
  [self setTableViewLayout];
  self.pickerView = [[UIPickerView alloc] init];
  //[self setPickerViewLayout];
  [self setActionSheetLayout];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDBaseSettingTableViewCell";
  RCDBaseSettingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDBaseSettingTableViewCell alloc] init];
  }
  [cell setCellStyle:DefaultStyle_RightLabel];
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
            [cell setCellStyle:SwitchStyle];
            cell.switchButton.tag = 101;
            cell.switchButton.on = [RCIMClient sharedRCIMClient].pushProfile.isShowPushContent;
            cell.leftLabel.text = @"显示远程推送的内容";
        }break;
        case 1: {
//            RCPushLauguage pushLauguage = [RCIMClient sharedRCIMClient].pushProfile.pushLauguage;
//            switch (pushLauguage) {
//                case RCPushLauguage_ZH_CN:
//                    cell.rightLabel.text = @"中文";
//                    break;
//                case RCPushLauguage_EN_US:
//                    cell.rightLabel.text = @"英文";
//                    break;
//                    
//                default:
//                    break;
//            }
//            cell.leftLabel.text = @"语言设置";
        }break;
        case 2: {
//          [cell setCellStyle:SwitchStyle];
//          cell.switchButton.tag = 102;
//          cell.switchButton.on = [RCIMClient sharedRCIMClient].pushProfile.enableMultiDevicePush;
//          cell.leftLabel.text = @"本手机是否接收远程推送";
            }break;
        default:break;
      }
    }break;
    default:break;
  }
  cell.baseSettingTableViewDelegate = self;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:{
      /*
      self.pickerView.hidden = NO;
      [self.view bringSubviewToFront:self.pickerView];
       */
//      [self.actionSheet showInView:self.view];
    }break;
    default:break;
  }
}
#pragma mark - Picker view Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 2;
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  return APPW;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  NSString *title;
  switch (row) {
    case 0:title = @"汉语";break;
    case 1:title = @"英语";break;
    default:break;
  }
  return title;
}
#pragma mark 私有方法
- (void)setTableViewLayout{
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.frame = [[UIScreen mainScreen] bounds];
  [self.view addSubview:self.tableView];
  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
  self.tableView.tableFooterView = [UIView new];
  self.tableView.backgroundColor = [FreedomTools colorWithRGBHex:0xf0f0f6];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.scrollEnabled = NO;
}
- (void)setPickerViewLayout{
  self.pickerView.delegate = self;
  self.pickerView.dataSource = self;
  self.pickerView.showsSelectionIndicator = YES;
  CGRect frame = CGRectMake(0, APPH - 100 - 64, APPW, 100);
  self.pickerView.frame = frame;
  self.pickerView.hidden = YES;
  [self.view addSubview:self.pickerView];
}
- (void)setActionSheetLayout{
    [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[RCIMClient sharedRCIMClient].pushProfile updatePushLauguage:RCPushLauguage_ZH_CN success:^{
//                NSLog(@"设置PUSH语音成功");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView reloadData];
//                });
//            } error:^(RCErrorCode status) {
//                NSLog(@"设置PUSH语音失败");
//            }];;
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"英文" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
    } ac3:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    } completion:nil];
}
- (void)onClickSwitchButton:(id)sender {
  UISwitch *switchButton = (UISwitch*)sender;
  switch (switchButton.tag) {
    case 101:{
      if (switchButton.on == YES) {
        [[RCIMClient sharedRCIMClient].pushProfile
         updateShowPushContentStatus:YES
         success:^{
           dispatch_async(dispatch_get_main_queue(), ^{
             [self AlertMessage:@"设置成功"];
           });
         } error:^(RCErrorCode status) {
           dispatch_async(dispatch_get_main_queue(), ^{
             [self AlertMessage:@"设置失败"];
           });
         }];
      } else {
        [[RCIMClient sharedRCIMClient].pushProfile
         updateShowPushContentStatus:NO
         success:^{
           dispatch_async(dispatch_get_main_queue(), ^{
             [self AlertMessage:@"设置成功"];
           });
         } error:^(RCErrorCode status) {
           dispatch_async(dispatch_get_main_queue(), ^{
             [self AlertMessage:@"设置失败"];
           });
         }];
      }
    }break;
    case 102:{
//      if (switchButton.on == YES) {
//        [[RCIMClient sharedRCIMClient].pushProfile updateMultiDevicePushStatus:YES success:^{
//          dispatch_async(dispatch_get_main_queue(), ^{
//            [self AlertMessage:@"设置成功"];
//          });
//        } error:^(RCErrorCode status) {
//          dispatch_async(dispatch_get_main_queue(), ^{
//            [self AlertMessage:@"设置失败"];
//          });
//        }];      } else {
//          [[RCIMClient sharedRCIMClient].pushProfile updateMultiDevicePushStatus:NO success:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//              [self AlertMessage:@"设置成功"];
//            });
//          } error:^(RCErrorCode status) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//              [self AlertMessage:@"设置失败"];
//            });
//          }];      }
    }break;
    default:break;
  }
}
-(void)cilckBackBtn:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)AlertMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(message);
    });
}
@end
