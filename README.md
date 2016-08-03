# CLLoopImageView
## 一款轻量级的图片轮播控件

### 使用方法
- 初始化

 ``` 
 /**
 * 第二个参数默认为NO.(YES表示设置图片自动轮播)
 */
CLLoopImageView *loopView = [CLLoopImageView loopImageViewWithFrame:CGRectMake(0, 0, 375, 200) autoScroll:YES];
 ```
- 设置图片

```
loopView.images = @[@"0.png",@"1.png",@"2.png",@"3.png",@"4.png"];
```
- 设置标题 (可选)

```
// loopView.titles = @[@"aaa",@"bbb",@"ccc",@"ddd",@"eee"];
```
- 设置tap手势处理事件

```
[loopView tapCurrentImageWithHandler:^(NSInteger currentIndex) {
      NSLog(@"点击了第 %zd 张图片", currentIndex);
}];
```
- 添加到父控件

```
[superView addSubview:loopView];
```


### 效果图

![](loopView.gif)



