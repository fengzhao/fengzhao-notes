

# 安装前提





**操作系统要求**



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



