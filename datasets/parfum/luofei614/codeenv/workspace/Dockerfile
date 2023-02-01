FROM tutum/apache-php
RUN mkdir -p /var/www/.ssh
# 如果有用window的同事可以设置www-data的密码， windows用户可以用sftp同步
RUN echo 'www-data:123456' | chpasswd
#将源地址修改为国内的
RUN sed -i "s/archive\.ubuntu\.com/mirrors\.163\.com/g" /etc/apt/sources.list
#设置www-data用户可以登录
RUN sed -i "s/\/var\/www:\/usr\/sbin\/nologin/\/var\/www:\/bin\/bash/" /etc/passwd
#设置ssh，本地生产key，环境变量填写key
RUN apt-get update && apt-get install -y openssh-server zip rsync
RUN  mkdir /var/run/sshd && chmod 0755 /var/run/sshd
#这里添加的目录会在docker run 指定 v 参数覆盖，所以无用
ADD  www /app
ADD  run.sh /run.sh
RUN  chmod +x /run.sh
RUN  cd /app && ssh-keygen -N "" -t dsa -b 1024 -f rsync-key && cp rsync-key.pub /var/www/.ssh/authorized_keys  && zip -r code.zip *
RUN  locale-gen en_US.UTF-8
EXPOSE 22
VOLUME ["/code"]
CMD   /run.sh 
