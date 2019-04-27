# honeycomb-rpm

```sh
sh build.sh
```

将honeycomb server,tengine,cronolog打包一起编译成centos-7 rpm包

做了如下几件事儿

1. 编译tengine,cronolog

2. 解压并安装honeycomb-server

3. 指定配置nginx.conf给用户

4. 覆盖原有honeycomb-server的server_ctl以启动nginx

5. 生成honeycomb-server的默认config.js

docker镜像完成之后rpm包会挂载到RPMS下

工作流

1. 下载你想要的tengine，honeycomb server和cronolog的源码到SOURCES,原本已经存在了honeycomb server的config.js,nginx.conf和server_ctl。运行./SCRIPTS/build_server.sh [VERSION] 可以打包对应版本的server

2. 编辑SPECS/honeycomb-server.spec,根据你下载的版本正确设置honeycomb_server_version,tengine_version,cronolog_version的版本

3. 你可以选择调整rpm包的version和release参数。

4. 准备就绪。运行build.sh，rpm包会输出到RPMS
