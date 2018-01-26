FROM centos:7
RUN yum -y install rpm-build gcc gcc-c++ make zlib-devel pcre-devel openssl-devel
RUN mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN groupadd -r admin
RUN useradd -r -g admin -d /home/admin -c "admin account for honeycomb" admin
ENTRYPOINT ["/usr/bin/rpmbuild", "-bb", "/root/rpmbuild/SPECS/honeycomb-server.spec"]