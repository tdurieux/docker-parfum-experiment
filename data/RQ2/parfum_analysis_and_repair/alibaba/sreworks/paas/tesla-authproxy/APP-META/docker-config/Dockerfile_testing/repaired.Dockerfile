# 日常环境的Dockerfile ： https://lark.alipay.com/aone/docker/rm2g1d
# 用基础镜像地址替换下方镜像地址
FROM reg.docker.alibaba-inc.com/aone-base/tesla-authproxy-service_base:20191010173104

# 健康检查默认3秒钟做一次,默认做100次也就是300秒,这里设置最多等180秒
ENV ali_start_timeout=180

# 设置打开jpda 调试端口。如果需要则打开下面的注释内容
# ENV JPDA_ENABLE=1

# 设置spring profile或者自定义的jvm参数。如果需要则打开下面的注释内容
ENV SERVICE_OPTS=-Dspring.profiles.active=internal

# 将构建出的主包复制到指定镜像目录中