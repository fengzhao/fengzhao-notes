

北京时间 2019 年 11 月 14 日凌晨 1 点 16 分，Go 官方团队在 golang-nuts 邮件组宣布 https://go.dev 上线，这是一个新的 Go 开发人员资源中心。



> Hey Gophers：
>
> 我们很高兴与大家分享 **go.dev**（一个新的 Go 开发人员中心）现已上线！
>
> 在 **go.dev**上，您将找到有关如何开始使用该语言，精选用例和其他资源的信息。它是 **golang.org** 的配套网站。您可以在最新的 Go 博客文章中阅读有关内容。**Go blog post**
>
> 通过单击页眉或页脚中的“浏览”，您还将找到一个发现 Go 软件包和模块的新位置 **pkg.go.dev**。
>
> **pkg.go.dev** 提供了 **godoc.org** 之类的 Go 文档，但它更懂模块，并提供了有关软件包先前版本的信息（例如 Go 标准库的所有发行版！）。
>
> 它还可以检测并显示许可证，并具有更好的搜索算法。
>
> 您可以在 **pkg.go.dev** 上关注 **Go issue 33654**，以了解将来的发展。
>
> 我们才刚刚开始构建 go.dev，因此可能会出现一些错误。我们希望与大家一起努力，使该网站更适合 Go 开发人员，因此，如果发现了问题，请反馈给我们！您可以点击每个页面页脚的“共享反馈”或“报告问题”，或发送电子邮件至 go-discovery-feedback@google.com。有关该站点的更多信息，请参见 **go.dev/about**。
>
> 希望您喜欢新网站，并希望能收到您的反馈！





同时，go.dev 还提供了一个 Go 软件包和模块的新信息资源中心：pkg.go.dev，而在此之前，Go 已经存在了一个包资源网站：godoc.org。

2020 年 1 月 31 日，在 Go 官方博客又发布了一篇博文，关于 pkg.go.dev 接下来要做的事情，一时间社区讨论激烈，很多人不解。

官方（Russ）对此也进行了解释。本文就官方的博文和 Google 邮件组上的相关内容进行整理总结，分享给大家。





- 将 godoc.org 请求重定向到 pkg.go.dev，并向社区开发者征求反馈意见。（目前还未重定向，不错已经有提示）

