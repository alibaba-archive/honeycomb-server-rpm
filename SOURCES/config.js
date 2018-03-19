'use strict';

const path = require('path');

module.exports = {
  /**
   * [必选] 服务控制台账号
   */
  admin: {
    /**
     * 服务控制台端口，可更改
     */
    port: 9999,
    logsRoot: '/home/admin/honeycomb/logs',
    /**
     * 控制台登陆用户名
     */
    username: 'honeycomb',
    password: 'dd0cf4ed95b64c54deaf78a11f36e9ad990380df730f1ae34aa7a38afc9ce383', // 'honeycomb'
    /**
     * 控制台签名密码
     */
    token: '***honeycomb-default-token***',
    /**
     * 开启默认的publish页面
     */
    enablePublishPage: true,
    gatherUsage: true,
    gatherUsageInterval: 5000,
    gatherUsageTimeout: 3000
  },
  proxy: {
    /**
     * 默认端口
     */
    port: 80,
    /**
     * [optional] 由前级系统产生的traceId，记录日志的时候需要获取到，可以方便追踪用
     */
    traceIdName: null,
    nginxBin: '/home/admin/nginx/sbin/nginx',
    /**
     * nginx 配置文件路径，abs path
     * @type {String}
     */
    nginxConfig: '/home/admin/nginx/conf/nginx.conf',
    /**
     * 默认首页地址， 如果 / 没有被劫持，
     */
    index: '/',
    /**
     * nginx 命令地址
     * @type {String}
     */
    /**
     * nginx 配置文件路径，abs path
     * @type {String}
     */
    healthCheck: {
      router: '/status',
      file: path.join(__dirname, '../run/status'),
      /**
       * honeycomb是否自动touch health检测文件
       * @type {Boolean}
       */
      autoTouch: true
    }
  },
  configSecret: 'a560d35be5306e29723583b68b4e768f4107d81f9cbe11bbd8995340cc07ea9c',
  /** 私有云标记 **/
  serverEnv: '',
  privateCloud: true
};
