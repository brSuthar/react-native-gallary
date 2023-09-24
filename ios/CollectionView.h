//
//  CustomTableViewCell.h
//  card_input
//
//  Created by Bhoma ram on 24/09/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "CustomTableViewCell.h"

@interface CollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray<UIImage *> *imagesArray;
@end

