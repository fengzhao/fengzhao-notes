## OpenResty运行原理



Nginx 采用的是 master-worker 模型，一个 master 进程管理多个 worker 进程，基本的事件处理都是放在 woker 中，master 负责一些全局初始化，以及对 worker 的管理。



在OpenResty中，每个 woker 使用一个 LuaVM，当请求被分配到 woker 时，将在这个 LuaVM 里创建一个 coroutine(协程)。协程之间数据隔离，每个协程具有独立的全局变量 _G。

