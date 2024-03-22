

# 安装前提

Gitlab 分为 SaaS 和 Self-Managed 两种版本，其中:

- SaaS 即 gitlab.com 这个在线版本（这个其实就是官方的 Self-Managed 版本，不过有一些额外的功能）；
- Self-Managed 就是指的我们自己本地部署的版本（本地部署也有额外的功能）。

Gitlab 官网目前提供了 Enterprise Edition 和 Community Edition 两种 Self-Managed 版本，分别对应 linux 系统的软件包 gitlab-ee 和 gitlab-ce。看名字就知道，gitlab-ee 是收费的功能更加丰富的版本。此外，企业版根据用户付费情况的不同，又分为了 Starter、Premiun、Ultimate 三种 PLAN，可以在 https://about.gitlab.com/pricing/feature-comparison/ 查看区别。


Gitlab 官方推荐用户安装企业版，因为在不购买许可证时，安装的 Gitlab-ee 就是运行为 Gitlab-ce 版本（付费功能自动隐藏），方便用户随时升级到企业版。毫无疑问，必须得选择安装 Gitlab-ee 啊！
安装方法有很多种，甚至可以选择最原始的从源代码进行安装。针对 Linux 系统 Gitlab 官方提供了很多现成的软件包，安装简单高效，可以在 https://about.gitlab.com/install/ 查看支持的 Linux 发行版。





**GITLAB支持的操作系统**



gitlab支持的操作系统：

- Ubuntu (16.04/18.04/20.04)
- Debian (9/10)
- CentOS (6/7/8)
- openSUSE (Leap 15.1/Enterprise Server 12.2)
- Red Hat Enterprise Linux (please use the CentOS packages and instructions)
- Scientific Linux (please use the CentOS packages and instructions)
- Oracle Linux (please use the CentOS packages and instructions)





**系统要求**

**软件要求**

### Ruby versions

From GitLab 13.6:

- Ruby 2.7 and later is required.

From GitLab 12.2:

- Ruby 2.6 and later is required.

You must use the standard MRI implementation of Ruby. We love [JRuby](https://www.jruby.org/) and [Rubinius](https://github.com/rubinius/rubinius#the-rubinius-language-platform), but GitLab needs several Gems that have native extensions.

### Go versions

The minimum required Go version is 1.13.

### Git versions

From GitLab 13.6:

- Git 2.29.x and later is required.

From GitLab 13.1:

- Git 2.24.x and later is required.
- Git 2.28.x and later [is recommended](https://gitlab.com/gitlab-org/gitaly/-/issues/2959).

### Node.js versions

Beginning in GitLab 12.9, we only support Node.js 10.13.0 or higher, and we have dropped support for Node.js 8. (Node.js 6 support was dropped in GitLab 11.8)

We recommend Node 12.x, as it’s faster.

GitLab uses [webpack](https://webpack.js.org/) to compile frontend assets, which requires a minimum version of Node.js 10.13.0.

You can check which version you’re running with `node -v`. If you’re running a version older than `v10.13.0`, you need to update it to a newer version. You can find instructions to install from community maintained packages or compile from source at the [Node.js website](https://nodejs.org/en/download/).

### Redis versions

GitLab 13.0 and later requires Redis version 4.0 or higher.

Redis version 5.0 or higher is recommended, as this is what ships with [Omnibus GitLab](https://docs.gitlab.com/omnibus/) packages starting with GitLab 12.7.

## 硬件要求



# 在CentOS7上安装gitlab







# gitlab安装优化

GitLab 在 v10 版本之后，不断增加功能，逐渐调整重心为一站式平台，产品趋于面向公司和组织，导致其对于服务器资源的依赖与日俱增。
从最初的 1GB 左右内存的资源就能流畅运行，膨胀到了目前至少需要 6～7 个GB内存才能够顺滑运行。
对于开发者和小团队而言，如何相对克制和轻量的使用它变成了一个有挑战的事情。



如果你追求绝对的资源占用，只希望拥有一个轻量的代码仓库，对于项目管理相关功能并不介意。
时至今日，GitLab 不论如何优化都难以达到其他聚焦于代码仓库功能的项目，推荐你使用"Gitea"这个轻量的程序，
但如果你希望拥有类似 GitHub 的项目管理体验，并有私有化部署要求，GitLab 会是不二之选。

