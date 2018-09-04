%define user admin
%define cronolog_version 1.6.2
%define tengine_version 2.2.1
%define honeycomb_server_version  1.0.9_3
%define use_systemd (0%{?fedora} && 0%{?fedora} >= 18) || (0%{?rhel} && 0%{?rhel} >= 7) || (0%{?suse_version} && 0%{?suse_version} >=1210)

Name:     	    honeycomb-server
Version:        1.0.9_3
Release:        1%{?dist}
Summary:        the micro-app container

License:        MIT
URL:            https://github.com/node-honeycomb/honeycomb-server
Source0:        cronolog-%{cronolog_version}.tar.gz
Source1:	    tengine-%{tengine_version}.tar.gz
Source2:	    honeycomb-server_%{honeycomb_server_version}.tgz
Prefix:         /usr
Group:          Development/Tools

BuildRequires:  gcc, make

%description
the micro-app container written in node.js

%pre
somaxconn=`sysctl net.core.somaxconn | awk '{print $3}'`
echo $somaxconn
if [ $somaxconn -lt 10240 ]; then
    sysctl net.core.somaxconn=10240
fi
backlog=`sysctl net.ipv4.tcp_max_syn_backlog | awk '{print $3}'`
echo $backlog
if [ $backlog -lt 10240 ]; then
    sysctl net.ipv4.tcp_max_syn_backlog=10240
fi
getent group %{user}>/dev/null || groupadd -r %{user}
getent passwd %{user}>/dev/null || \
    useradd -r -g %{user} -d /home/%{user}  \
    -c "admin account for honeycomb" %{user}
exit 0
%prep
%setup -b 0 -n cronolog-%{cronolog_version}
./configure

%setup -b 1 -n tengine-%{tengine_version}
./configure  \
 --with-http_ssl_module \
 --with-http_flv_module \
 --user=admin \
 --group=admin \
 --with-http_stub_status_module \
 --with-http_gzip_static_module \
 --with-http_upstream_check_module \
 --prefix=/home/admin/nginx \

%setup -b 2 -n honeycomb-server_%{honeycomb_server_version}


%build

cd %{_builddir}

cd cronolog-%{cronolog_version}
make %{?_smp_mflags}

cd ../

cd tengine-%{tengine_version}
make %{?_smp_mflags}

cd ../
%install

install -D -m 0644 %{_builddir}/../SOURCES/honeycomb_server.service %{buildroot}%{_unitdir}/honeycomb_server.service

cd %{_builddir}
cd cronolog-%{cronolog_version}
make install prefix=$RPM_BUILD_ROOT/usr

cd ../
cd tengine-%{tengine_version}
make install DESTDIR=$RPM_BUILD_ROOT
cd ../../SOURCES
cp  nginx.conf $RPM_BUILD_ROOT/home/admin/nginx/conf
touch $RPM_BUILD_ROOT/home/admin/nginx/conf/custom.conf


cd %{_builddir}
cd honeycomb-server_%{honeycomb_server_version}
sh honeycomb_install.sh $RPM_BUILD_ROOT/home/admin/honeycomb
rm -rf $RPM_BUILD_ROOT/home/admin/honeycomb/target/honeycomb
cp -f  %{_builddir}/../SOURCES/server_ctl $RPM_BUILD_ROOT/home/admin/honeycomb/bin
cp  %{_builddir}/../SOURCES/config.js $RPM_BUILD_ROOT/home/admin/honeycomb/conf
mv $RPM_BUILD_ROOT/home/admin/honeycomb/conf/config.js $RPM_BUILD_ROOT/home/admin/honeycomb/conf/config_default.js

%post
%if %use_systemd
    /usr/bin/systemctl preset %{pkgname}.service >/dev/null 2>&1 ||:
%else
%endif

%files
%attr(0755, admin, admin) /home/admin
%attr(0755, admin, admin) /home/admin/nginx
%attr(0755, admin, admin) /home/admin/honeycomb
%attr(6755, root, admin) /home/admin/nginx/sbin/nginx
%attr(644, root, root) %{_unitdir}/honeycomb_server.service
/usr/sbin/cronolog
/usr/sbin/cronosplit
/home/admin/nginx
/home/admin/honeycomb
%doc
/usr/man/man1/cronolog.1m.gz
/usr/man/man1/cronosplit.1m.gz
/usr/info/cronolog.info.gz
/usr/info/dir

