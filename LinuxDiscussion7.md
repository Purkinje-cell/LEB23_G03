### Git 冲突处理

在多人协作项目时，常常会碰到的一个场景是两个人同时对同一个文件进行了不同的修改。

### Markdown 图床配置

在使用 Markdown 撰写讨论报告时，我们发现了一个问题：Markdown 对于插入图片的支持比较复杂，需要指定本地图片的路径或网络图片的 URL。因此，我们上传至 Github 的 Markdown 报告中无法显示图片。我们搜索了 Markdown 图片支持的解决方案，发现图床是一种较好的方式。

**图床（Image Hosting)** 是一个在线存储和分享图片的服务。它允许用户将图片上传到图床服务器上，并通过生成的链接或嵌入代码将图片分享给其他人或展示在不同的平台上。图床为用户提供了一个方便、快捷的图片存储和分享方式，不需要担心存储空间和带宽问题。用户可以通过图床服务轻松上传、管理和分享图片，而不必担心占用自己的硬盘空间或消耗大量带宽。这对于网站制作、论坛交流、博客撰写等场景非常有用，因为图片通常占用很大的存储空间和带宽。使用图床服务，用户可以将图片托管到第三方服务器上，让访问者直接从图床服务器获取图片，减轻了原始服务器的压力。

这里我们根据网上的教程, 使用 GitHub 创建一个图床。[如何利用 Github 搭建自己的免费图床？ - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/347342082)

首先，在 Github 上新建一个仓库 Images（此处命名可以修改），并在 Settings -> Developer Settings -> Personal access tokens 里新创建一个 Token，用于 PicGo 软件直接使用 API 访问 Github。

![image.png](https://raw.githubusercontent.com/Purkinje-cell/Images/master/20230427160824.png)

之后，从 GitHub 上下载 PicGo 软件，并按照教程配置它的 Github 仓库名和分支名，并粘贴之前设置好的 Token。使用 PicGo 控制图片上传的好处是它能够较为方便的设置不同图床的上传，以及在上传后可以自动复制 Markdown 类型的链接到剪贴板，从而减小了工作量。

![image.png](https://raw.githubusercontent.com/Purkinje-cell/Images/master/20230427161524.png)

之后，将 Markdown 中图片的格式从引用本地文件改为引用 GitHub 上的 URL。再将 Markdown 上传到 Github，发现已经能够显示图片。

目前网上有许多免费的图床，如 SM. MS。或者可以使用腾讯云存储服务来进行图床的配置。使用腾讯云的好处是上传速度较快，不会遇到 GitHub 需要 VPN 的问题。

测试一下
