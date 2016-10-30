//
//  ViewController.m
//  ALiImageReshape
//
//  Created by LeeWong on 2016/10/29.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "AliImageReshapeController.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,ALiImageReshapeDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;
@end

@implementation ViewController
- (IBAction)sysMethod:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (IBAction)customMethod:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册选取", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //拍照
        [self takePhoto];
    } else if(buttonIndex == 1) {
        //相册选取
        [self chooseImage];
    } else {
        //取消
    }
}

- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)chooseImageFromLibary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ALiImageReshapeDelegate

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    [self.chooseImage setImage:image];
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.allowsEditing) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [self.chooseImage setImage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.chooseImage setImage:image];
        AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
        vc.sourceImage = image;
        vc.reshapeScale = 16./9.;
        vc.delegate = self;
        [picker pushViewController:vc animated:YES];
    }

}


@end
