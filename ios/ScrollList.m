//
//  ScrollList.m
//  card_input
//
//  Created by Bhoma ram on 24/09/23.
//

#import "ScrollList.h"
#import "card_input-Swift.h"

@implementation ScrollList
RCT_EXPORT_MODULE();
#pragma mark - TableView
- (UIView *)view {

  return  [[SwiftCollectionView alloc] init];
}

@end
