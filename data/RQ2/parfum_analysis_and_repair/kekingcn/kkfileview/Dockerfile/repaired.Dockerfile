FROM ubuntu:20.04
MAINTAINER chenjh "842761733@qq.com"
ADD server/target/kkFileView-*.tar.gz /opt/
COPY fonts/* /usr/share/fonts/chinese/
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" > /etc/apt/sources.list &&\
	apt-get clean && apt-get update && \
	apt-get install --no-install-recommends -y locales && apt-get install --no-install-recommends -y language-pack-zh-hans && \
	localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && locale-gen zh_CN.UTF-8 && \
    export DEBIAN_FRONTEND=noninteractive && \
	apt-get install --no-install-recommends -y tzdata && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	apt-get install --no-install-recommends -y libxrender1 && apt-get install --no-install-recommends -y libxt6 && apt-get install --no-install-recommends -y libxext-dev && apt-get install --no-install-recommends -y libfreetype6-dev && \
	apt-get install --no-install-recommends -y wget && apt-get install --no-install-recommends -y ttf-mscorefonts-installer && apt-get install --no-install-recommends -y fontconfig && \
	apt-get install -y --no-install-recommends ttf-wqy-microhei && \
	apt-get install -y --no-install-recommends ttf-wqy-zenhei && \
	apt-get install -y --no-install-recommends xfonts-wqy && \
    cd /tmp && \
	wget https://kkfileview.keking.cn/server-jre-8u251-linux-x64.tar.gz && \
	tar -zxf /tmp/server-jre-8u251-linux-x64.tar.gz && mv /tmp/jdk1.8.0_251 /usr/local/ && \
	
#	安装 OpenOffice
#	wget https://kkfileview.keking.cn/Apache_OpenOffice_4.1.6_Linux_x86-64_install-deb_zh-CN.tar.gz -cO openoffice_deb.tar.gz &&\
#	tar -zxf /tmp/openoffice_deb.tar.gz && cd /tmp/zh-CN/DEBS &&\
#	dpkg -i *.deb && dpkg -i desktop-integration/openoffice4.1-debian-menus_4.1.6-9790_all.deb &&\

 libreoffice \
    apt-get install -y libxinerama1 libc ir 2 libcups2 libx11-xcb1 &&\
    wget https:// kf \
       tar -zxf / mp libreoffice_deb.tar.gz && c  / \
    dpkg -i *.deb &&\
   
	-rf /tmp/  & \
    cd /usr/shar && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/local/jdk1.8.0_251
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin
ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV KKFILEVIEW_BIN_FOLDER /opt/kkFileView-4.1.0-SNAPSHOT/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.1.0-SNAPSHOT/config/application.properties","-jar","/opt/kkFileView-4.1.0-SNAPSHOT/bin/kkFileView-4.1.0-SNAPSHOT.jar"]