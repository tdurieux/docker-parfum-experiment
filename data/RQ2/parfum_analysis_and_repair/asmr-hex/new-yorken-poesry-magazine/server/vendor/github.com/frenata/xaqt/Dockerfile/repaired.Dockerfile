############################################################
# Dockerfile to build sandbox for executing user code
# Based on Ubuntu
############################################################

FROM ubuntu:bionic
MAINTAINER Andrew Nichols

RUN apt-get update
RUN apt-get upgrade -y
#Install all the languages/compilers we are supporting.
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php-cli && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y mono-xsp4 mono-xsp4-base && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y mono-vbnc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

#RUN npm cache clean -f
#RUN npm install -g n
#RUN n stable

RUN npm install -g underscore request express pug shelljs passport http sys jquery lodash async mocha moment connect validator restify ejs ws co when helmet fs-extra mustache should backbone forever debug get-stdin && npm cache clean --force;

ENV NODE_PATH /usr/local/lib/node_modules/

RUN apt-get install --no-install-recommends -y clojure && rm -rf /var/lib/apt/lists/*;


#prepare for Java download
# commenting out according to: https://askubuntu.com/questions/422975/e-package-python-software-properties-has-no-installation-candidate
# RUN apt-get install -y python-software-properties
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

#grab oracle java (auto accept licence)
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install --no-install-recommends -y oracle-java8-installer && rm -rf /var/lib/apt/lists/*;


RUN apt-get install --no-install-recommends -y gobjc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnustep-devel && sed -i 's/#define BASE_NATIVE_OBJC_EXCEPTIONS     1/#define BASE_NATIVE_OBJC_EXCEPTIONS     0/g' /usr/include/GNUstep/GNUstepBase/GSConfig.h && rm -rf /var/lib/apt/lists/*;


#RUN apt-get install -y scala
RUN useradd -m mysql
RUN apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y perl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
#RUN mkdir -p /opt/rust && \
#    curl https://sh.rustup.rs -sSf | HOME=/opt/rust sh -s -- --no-modify-path -y && \
#    chmod -R 777 /opt/rust

RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bc && rm -rf /var/lib/apt/lists/*;

RUN echo "mysql ALL = NOPASSWD: /usr/sbin/service mysql start" | cat >> /etc/sudoers

# install stack for haskell
RUN apt-get install --no-install-recommends -y haskell-platform && rm -rf /var/lib/apt/lists/*;

# copy entrypoint directory into image.
COPY ./entrypoint /entrypoint
