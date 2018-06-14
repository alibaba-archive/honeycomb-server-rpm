# FROM reg.docker.alibaba-inc.com/alipay/6u2-common:20180409020505-860cd63
FROM centos:7
RUN rpm --rebuilddb && yum clean all && yum -y install rpm-build gcc gcc-c++ make zlib-devel pcre-devel openssl-devel --nogpgcheck
RUN mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
# RUN groupadd -r admin
# RUN useradd -r -g admin -d /home/admin -c "admin account for honeycomb" admin
ENTRYPOINT ["/usr/bin/rpmbuild", "-bb", "/root/rpmbuild/SPECS/honeycomb-server.spec"]