//
//  CollectionView.m
//  card_input
//
//  Created by Bhoma ram on 24/09/23.
//

#import "CollectionView.h"


@implementation CollectionView

- (instancetype)init {
  self.imagesArray = [NSMutableArray array];
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.scrollDirection = UICollectionViewScrollDirectionVertical;

  layout.itemSize = CGSizeMake(100, 100);

  self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate = self;
    self.allowsMultipleSelection = YES;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self requestPhotoLibraryAccess];
  }
  return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.imagesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.clipsToBounds = YES;
  imageView.image = self.imagesArray[indexPath.item];
  imageView.layer.cornerRadius = 6;
  [cell.contentView addSubview:imageView];
  cell.layer.cornerRadius = 6;
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath: indexPath];
  if(cell.isSelected) {
    cell.layer.borderWidth = 3;
    cell.layer.borderColor = [UIColor blueColor].CGColor;
  }else {
    cell.layer.borderWidth = 0;
  }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath: indexPath];
  cell.layer.borderWidth = 0;
}

#pragma mark - Photo

- (void)requestPhotoLibraryAccess {
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    if (status == PHAuthorizationStatusAuthorized) {
      [self fetchImagesFromPhotoLibrary];
    } else {
        
    }
  }];
}

- (void)fetchImagesFromPhotoLibrary {
  PHFetchOptions *fetchOptions = [PHFetchOptions new];
  PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
  
  for (PHAsset *asset in assets) {
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset
                          targetSize:CGSizeMake(100, 100) // Set your desired image size here
                         contentMode:PHImageContentModeAspectFill
                             options:nil
                       resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
      if (result) {
        [self.imagesArray addObject:result];
        dispatch_async(dispatch_get_main_queue(), ^{
          [self reloadData];
        });
      }
    }];
  }
}


@end
