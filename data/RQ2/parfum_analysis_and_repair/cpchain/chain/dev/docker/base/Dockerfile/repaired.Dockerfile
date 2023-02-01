FROM debian:testing

ARG DEBIAN_FRONTEND=noninteractive
# cf. https://qiita.com/haessal/items/0a83fe9fa1ac00ed5ee9
ARG DEBCONF_NOWARNINGS=yes

RUN echo "deb http://deb.debian.org/debian/ testing main non-free contrib" > /etc/apt/sources.list
# apt-get for scripting and apt for interactive use.
RUN apt-get update; apt-get -y upgrade; apt-get -y --no-install-recommends install locales tzdata && rm -rf /var/lib/apt/lists/*;

# set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8    

# set location
ENV TZ 'Asia/Hong_Kong'
RUN echo $TZ > /etc/timezone

# user
RUN adduser --disabled-login --gecos '' cpchain
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN echo 'cpchain ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# dev
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3 python3-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install golang-go && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

ENV HOME /home/cpchain

USER cpchain
WORKDIR $HOME