# 基础镜像的Dockerfile ： https://lark.alipay.com/aone/docker/rm2g1d
# 基于基础镜像
FROM reg.docker.alibaba-inc.com/alibase/alios7u2-min

# 指定应用名字，配置在$APP_NAME.release文件里
# 从 build.tools.docker.args=--build-arg APP_NAME=${APP_NAME} 传入
ARG APP_NAME
ENV APP_NAME=${APP_NAME}

# 构建时要做的事，一般是执行shell命令，例如用来安装必要软件，创建文件（夹），修改文件
RUN rpm -ivh --nodeps "http://yum.corp.taobao.com/taobao/7/x86_64/current/ali-jdk/ali-jdk-8.4.7-1519273.alios7.x86_64.rpm" && \
rpm -ivh --nodeps "http://yum.tbsite.net/taobao/7/x86_64/current/tengine-proxy/tengine-proxy-2.1.13-20170802132414.el7u2.x86_64.rpm" && \
rpm -ivh --nodeps "http://yum.tbsite.net/alios/7/os/x86_64/Packages/taobao-cronolog-1.6.2-15.alios7.x86_64.rpm" && \
mkdir -p /home/admin/$APP_NAME/target && \
echo "/home/admin/$APP_NAME/bin/appctl.sh stop" > /home/admin/stop.sh && \
echo "/home/admin/$APP_NAME/bin/appctl.sh restart" >> /home/admin/start.sh && \
echo "/home/admin/$APP_NAME/bin/preload.sh" > /home/admin/health.sh && \
chmod +x /home/admin/*.sh

# 增加jdk路径
ENV PATH "$PATH:/opt/taobao/java/bin/"

# 将应用nginx脚本复制到镜像中
COPY environment/common/cai/ /home/admin/cai/

# 将应用启动脚本和配置文件复制到镜像中
COPY environment/common/bin/ /home/admin/${APP_NAME}/bin

# 设置文件操作权限
RUN chmod -R a+x /home/admin/${APP_NAME}/bin/ /home/admin/cai/bin/

# 挂载数据卷,指定目录挂载到宿主机上面,为了能够保存（持久化）数据以及共享容器间的数据，为了实现数据共享，例如日志文件共享到宿主机或容器间共享数据.
VOLUME /home/admin/$APP_NAME/logs \
       /home/admin/logs \
       /home/admin/cai/logs \
       /home/admin/diamond \
       /home/admin/snapshots \
       /home/admin/configclient \
       /home/admin/notify \
       /home/admin/catserver \
       /home/admin/liaoyuan-out \
       /home/a/vipsrv-dns \
       /home/admin/vipsrv-failover \
       /home/admin/vipsrv-cache \
       /home/admin/csp \
       /home/admin/.rocketmq_offsets \
       /home/admin/amsdata \
       /home/admin/amsdata_all

# 启动容器时进入的工作目录
WORKDIR /home/admin/$APP_NAME/bin

#容器启动时自动执行的脚本，我们一般会将应用启动脚本放在这里，相当于系统自启应用
ENTRYPOINT ["/home/admin/start.sh"]

# 从Sar包镜像中复制Sar包到应用镜像
# Sar包升级文档：http://gitlab.alibaba-inc.com/middleware-container/pandora/wikis/sar-upgrade
# Sar包镜像列表：http://docker.alibaba-inc.com/#/imageDesc/2751570/detail
COPY --from=reg.docker.alibaba-inc.com/pandora-sar/sar:2019-04-stable /opt/taobao-hsf.tgz /home/admin/$APP_NAME/target/taobao-hsf.tgz

############# project #################
# 设置spring profile或者自定义的jvm参数。如果需要则打开下面的注释内容
# ENV SERVICE_OPTS=-Dspring.profiles.active=project

# 将构建出的主包复制到指定镜像目录中