# 3proxy.full is fully functional 3proxy build based on busibox:glibc
#
#to  build:
# docker build -f Dockerfile.full -t 3proxy.full .
#to run:
# by default 3proxy uses safe chroot environment with chroot to /usr/local/3proxy with uid/gid 65535/65535 and expects
# configuration file to be placed in /usr/local/etc/3proxy.
# Paths in configuration file must be relative to /usr/local/3proxy, that is use /logs instead of 
# /usr/local/3proxy/logs. nserver in chroot is required for DNS resolution. An example:
#
# echo nserver 8.8.8.8 >/path/to/local/config/directory/3proxy.cfg
# echo proxy -p3129 >>/path/to/local/config/directory/3proxy.cfg
# docker run -p 3129:3129 -v /path/to/local/config/directory:/usr/local/3proxy/conf -name 3proxy.full 3proxy.full
#
# /path/to/local/config/directory in this example must conrain 3proxy.cfg
# if you need 3proxy to be executed without chroot with root permissions, replace /etc/3proxy/3proxy.cfg by e.g. mounting config
# dir to /etc/3proxy ot by providing config file /etc/3proxy/3proxy.cfg
# docker run -p 3129:3129 -v /path/to/local/config/directory:/etc/3proxy -name 3proxy.full 3proxy.full
#
# use "log" without pathname in config to log to stdout.
# plugins are located in /usr/local/3proxy/libexec (/libexec for chroot config).