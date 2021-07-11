# 图片格式



我们知道，图片一般有不同的格式，比如我们常见的 JPG，PNG 就分别属于两种不同的图片格式，通过是否对图片进行压缩，我们可以大致分为：



- 无压缩。不对图片数据进行压缩处理，能准确地呈现原图片。 BMP 格式就是其中之一。

- 无损压缩。压缩算法对图片的所有的数据进行编码压缩，能在保证图片的质量的同时降低图片的尺寸。 png 是其中的代表。

  - 无损压缩通常用于严格要求“经过压缩、解压缩的数据必须与原始数据一致”的场合。
  - 比较典型的例子包括文字文件、程序可执行文件、程序源代码。有些图片文件格式，例如PNG和GIF，使用的是无损压缩。

- 有损压缩。压缩算法不会对图片所有的数据进行编码压缩，而是在压缩的时候，去除了人眼无法识别的图片细节。因此有损压缩可以在同等图片质量的情况下大幅降低图片的尺寸。 

- - 其中的代表是 jpg。



更通用常见的图片格式类型，可以参考火狐 MDN 文档 https://developer.mozilla.org/zh-CN/docs/Web/Media/Formats/Image_types

https://cloud.tencent.com/developer/article/1404912



除了是否压缩以外，还有一个大家可能经常会遇到的问题——图片是否有透明图层。

例如在之前的「搭建 Cloudflare 背后的 IPv6 AnyCast 网络」中的图片，在嵌入我的文章时并不会因为背景颜色的变化而显示出一个白色的背景，这是因为图片存在「透明通道（阿尔法通道）」。

常见的支持透明通道的图片格式有：PNG，PSD，JPEG XR 和 JPEG 2000，其中后两者也是 Google 推荐的图片的 next-gen formats 之二，而常见的无透明通道的则是：JPEG 啦。

除了这个之外，还有一个由 Google 牵头研发，Telegram Stickers 主力使用的文件格式——WebP。





# webP简介

> *WebP的有损压缩算法是基于VP8视频格式的帧内编码，并以RIFF作为容器格式。因此，它是一个具有八位色彩深度和以1:2的比例进行色度子采样的亮度-色度模型（YCbCr 4:2:0）的基于块的转换方案。*
>
> *不含内容的情况下，RIFF容器要求只需20字节的开销，依然能保存额外的 元数据(metadata)。WebP图像的边长限制为16383像素。*
>
> *WebP lossless images are 26% smaller in size compared to PNGs. WebP lossy images are 25-34% smaller than comparable JPEG images at equivalent SSIM quality index.*



简单来说，WebP 图片格式的存在，让我们在 WebP 上展示的图片体积可以有较大幅度的缩小，也就带来了加载性能的提升。

要生成一个 WebP 图片非常简单，只需要下载 Google 提供的 cwebp 工具，并且使用：

```shell
cwebp -q 70 picture_with_alpha.png -o picture_with_alpha.webp

```

就可以进行转换了，转换出来的 `webp` 图片比原图会小不少，但是这个是单张图片，我们的目的是让站点的图片可以无痛地以 WebP 格式输出，如果我们的博客上有 100+ 张图片转换该如何操作呢？如果是更多呢？