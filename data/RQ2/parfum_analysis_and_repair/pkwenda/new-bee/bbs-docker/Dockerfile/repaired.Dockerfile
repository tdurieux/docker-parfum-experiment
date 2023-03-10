FROM ubuntu:14.04


MAINTAINER pkwenda "sis.nonacosa@gmail.com"

WORKDIR /app/

COPY . /app/

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list
RUN apt-get update && apt-get install --no-install-recommends -y wget git curl zip monit openssh-server git iptables ca-certificates daemon net-tools libfontconfig-dev && \
sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && apt-get update && rm -rf /var/lib/apt/lists/*;

#Install Oracle JDK 8
#--------------------
RUN echo "# Installing Oracle JDK 8" && \
    sudo apt-get install --no-install-recommends -y software-properties-common debconf-utils && \
    sudo add-apt-repository -y ppa:webupd8team/java && \
    sudo apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections && \
    sudo apt-get install --no-install-recommends -y oracle-java8-installer && rm -rf /var/lib/apt/lists/*;

# Node related
# ------------

RUN echo "# Installing Nodejs" && \
    curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install --no-install-recommends nodejs build-essential -y && \
    npm cache clear --force -f && rm -rf /var/lib/apt/lists/*;