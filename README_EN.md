# honeycomb-rpm

```sh
sh build.sh
```

pack honeycomb server,tengine,cronologto centos-7 into  rpm pacakge

this scirpt do following things

1. compile tengine,cronolog

2. compress and install honeycomb-server

3. link nginx.conf to user

4. regen new server_ctl of honeycomb-server address to start nginx

5. generate default config.js of honeycomb-server

rpm pacakge will be in RPMS/ folder after build successed

work flow

1. download tengine，honeycomb server and cronolog source code to SOURCES/.

2. change your SPECS/honeycomb-server.spec,honeycomb_server_version,tengine_version,cronolog_version

3. change rpm's version and release arg。

4. ready to left off! run build.sh，then take care of this.
