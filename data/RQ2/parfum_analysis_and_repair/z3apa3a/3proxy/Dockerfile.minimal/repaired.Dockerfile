# dockerfile for "interactive" minimal 3proxy execution, no configuration mounting is required, configuration
# is accepted from stdin. Use "end" command to indicate the end of configuration. Use "log" for stdout logging.
#
# This is busybox based docker with only 3proxy static executable and empty non-writable "run" directory.
#
# "plugin" is not supported
#
# Build:
#
# docker build -f Dockerfile.minimal -t 3proxy.minimal .
#
# Run example:
#
# docker run -i -p 3129:3129 --name 3proxy 3proxy.minimal  
#or
# docker start -i 3proxy
#<chroot run 65535 65535
#<nserver 8.8.8.8
#<nscache 65535
#<log
#<proxy -p3129
#<end
#
# use "chroot run 65536 65536" in config for safe chroot environment. nserver is required for DNS resolutions in chroot.