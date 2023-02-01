FROM centos:7

# 1. 安装基本依赖
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo && yum makecache && \
    yum update -y && yum install epel-release -y && yum update -y && yum install wget unzip epel-release nginx xz gcc automake zlib-devel openssl-devel supervisor -y
WORKDIR /opt/

# 2. 准备python
RUN wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz -O /opt/Python-3.6.1.tar.xz
RUN tar xf Python-3.6.1.tar.xz  && cd Python-3.6.1 && ./configure && make && make install
RUN python3 -m venv py3

# 3. 安装yum依赖
ENV YUM_BUILD_NUM=1
RUN curl -o  ~/rpm_requirements.txt https://raw.githubusercontent.com/ZQiannnn/jumpserver-ansible/feature/feature-ansible-0.5.0/requirements/rpm_requirements.txt
RUN curl -o  ~/coco_rpm_requirements.txt https://raw.githubusercontent.com/jumpserver/coco/master/requirements/rpm_requirements.txt
RUN yum -y install $(cat ~/rpm_requirements.txt) && yum -y install $(cat ~/coco_rpm_requirements.txt)

# 4. 安装pip依赖
ENV JUMP_BUILD_NUM=1
RUN curl -o ~/requirements.txt https://raw.githubusercontent.com/ZQiannnn/jumpserver-ansible/feature/feature-ansible-0.5.0/requirements/requirements.txt
RUN source /opt/py3/bin/activate && pip install -r ~/requirements.txt
ENV COCO_BUILD_NUM=0
RUN curl -o ~/coco_requirements.txt https://raw.githubusercontent.com/jumpserver/coco/dev/requirements/requirements.txt
RUN source /opt/py3/bin/activate && pip install -r ~/coco_requirements.txt


# 3. 下载包并解压
WORKDIR /opt/
ENV TAR_BUILD_NUM=0
RUN wget https://github.com/jumpserver/coco/archive/dev.zip -O /opt/coco.zip
RUN wget https://github.com/jumpserver/luna/releases/download/0.5-rel/luna.tar.gz -O /opt/luna.tar.gz
ENV BUILD_NUM=6
RUN wget https://github.com/ZQiannnn/jumpserver-ansible/archive/feature/feature-ansible-0.5.0.zip -O /opt/jumpserver.zip
RUN unzip coco.zip && mv coco-dev coco && unzip jumpserver.zip && mv jumpserver-ansible-feature-feature-ansible-0.5.0 jumpserver && tar xzf luna.tar.gz


VOLUME /opt/coco/keys
VOLUME /opt/jumpserver/data

# 7. 准备文件
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY jumpserver_conf.py /opt/jumpserver/config.py
COPY coco_conf.py /opt/coco/conf.py
COPY ansible.cfg /etc/ansible/ansible.cfg
COPY hosts /etc/ansible/hosts
COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
RUN ssh-keygen -t rsa -C "Jumpserver" -f /root/.ssh/id_rsa

EXPOSE 2222 80
ENTRYPOINT ["entrypoint.sh"]