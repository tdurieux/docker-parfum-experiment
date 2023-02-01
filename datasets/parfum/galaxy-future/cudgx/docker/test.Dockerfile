FROM centos:7

RUN apt yum install yum-utils &  yum install java-1.8.0-openjdk.x86_64  wget -y


RUN rpm --import https://repo.clickhouse.com/CLICKHOUSE-KEY.GPG

RUN yum-config-manager --add-repo https://repo.clickhouse.com/rpm/stable/x86_64

RUN  yum install clickhouse-server clickhouse-client -y



COPY ./downloads/mysql-community-common-5.7.26-1.el7.x86_64.rpm ./
RUN rpm -ivh mysql-community-common-5.7.26-1.el7.x86_64.rpm

COPY ./downloads/mysql-community-libs-5.7.26-1.el7.x86_64.rpm ./
RUN rpm -ivh mysql-community-libs-5.7.26-1.el7.x86_64.rpm

COPY ./downloads/mysql-community-client-5.7.26-1.el7.x86_64.rpm ./
RUN rpm -ivh mysql-community-client-5.7.26-1.el7.x86_64.rpm

RUN yum install perl  libaio net-tools numactl -y
COPY ./downloads/mysql-community-server-5.7.26-1.el7.x86_64.rpm ./
RUN rpm -ivh mysql-community-server-5.7.26-1.el7.x86_64.rpm


ADD  downloads/kafka_2.12-2.7.1.tgz kafka


COPY downloads/go1.16.10.linux-amd64.tar.gz go1.16.10.linux-amd64.tar.gz
RUN tar -xvf go1.16.10.linux-amd64.tar.gz  -C /usr/local/

RUN echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
RUN echo 'export PATH=$PATH:/go/bin' >>~/.bashrc
RUN echo 'export GOPROXY=https://goproxy.cn,https://goproxy.io,direct' >>~/.bashrc
RUN echo 'export GOPRIVATE=code.galaxy-future.com,code.galaxy-future.org' >>~/.bashrc
RUN echo 'export GOPATH=/go' >>~/.bashrc

RUN source ~/.bashrc && go get github.com/onsi/ginkgo/ginkgo
RUN source ~/.bashrc && go get github.com/onsi/gomega/...


RUN yum install git -y
RUN echo $'[url "git@code.galaxy-future.com:"] \n\
              insteadOf = https://code.galaxy-future.com/' >> /root/.gitconfig
COPY downloads/repo-key /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan code.galaxy-future.com >> /root/.ssh/known_hosts



COPY scripts/test.sh ./test.sh

#
#



#RUN mysqld --initialize-insecure
#RUN mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid --user=root
#



#RUN sudo apt-get install apt-transport-https ca-certificates dirmngr
#RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4
#
#RUN echo "deb https://repo.clickhouse.com/deb/stable/ main/" | sudo tee \
#    /etc/apt/sources.list.d/clickhouse.list
#
#RUN sudo apt-get install -y clickhouse-server clickhouse-client
#
#RUN  sudo service clickhouse-server start




#
#RUN echo $'[Unit]\n\
#Requires=network.target remote-fs.target \n\
#After=network.target remote-fs.target \n\
#\n\
#[Service]\n\
#Type=simple\n\
#User=root\n\
#ExecStart=/kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties\n\
#ExecStop=/kafka/bin/zookeeper-server-stop.sh\n\
#Restart=on-abnormal\n\
#\n\
#[Install]\n\
#WantedBy=multi-user.target' >> /lib/systemd/system/zookeeper.service
#
#RUN echo $'[Unit] \n\
#Requires=network.target remote-fs.target\n\
#After=network.target remote-fs.target\n\
#\n\
#[Service]\n\
#Type=simple\n\
#User=root\n\
#ExecStart=/kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties\n\
#ExecStop=/kafka/bin/zookeeper-server-stop.sh\n\
#Restart=on-abnormal\n\
#\n\
#[Install]\n\
#WantedBy=multi-user.target' >> /lib/systemd/system/kafka.service

