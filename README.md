# ALiImageReshape

##### 简介
在项目中通常会遇到，比如上传封面或者头像的时候要求选取的图片是等比例的，因此，我们经常会用到图片的裁剪。

[Demo放在这里](https://github.com/LeeWongSnail/ALiImageReshape)

支持拍照和相册选取之后进行图片的裁剪，可以自定义选择的宽高比

```
//宽高比
@property (nonatomic, assign) CGFloat reshapeScale; 
```
注意这个属性一定要为浮点型，默认值为1即正方形。

系统的方法只需要设置allowEditing = YES 即可，但是缺点是只支持正方形的裁剪。

实例图片：

![从相册选取](https://i.niupic.com/images/2016/10/29/uK4efP.gif)

![拍照](https://i.niupic.com/images/2016/10/29/fnIgwd.gif)

