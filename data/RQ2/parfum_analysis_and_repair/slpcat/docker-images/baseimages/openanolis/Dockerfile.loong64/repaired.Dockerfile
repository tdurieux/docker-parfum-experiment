#FROM harbor.loongnix.cn/mirrorloongsoncontainers/openanolis:8.4.beta1-loongarch64
FROM openanolis/anolisos:8.4-loongarch64

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

# set timezone