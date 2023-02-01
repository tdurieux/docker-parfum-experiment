FROM ubuntu:16.04
MAINTAINER seongahjo <seongside@gmail.com>
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && apt-get -y --no-install-recommends install dialog locales python3-pip \
&& locale-gen ko_KR.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG ko_KR.UTF-8
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8
RUN apt-get -y --no-install-recommends install libgtk2.0-dev \
&& apt-get -y --no-install-recommends install cmake \
&& apt-get -y --no-install-recommends install git \
&& apt-get -y --no-install-recommends install nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/seongahjo/Mosaicer.git
WORKDIR Mosaicer
RUN pip3 install --no-cache-dir --upgrade pip \
&& pip3 install --no-cache-dir -r requirements.txt
WORKDIR node
RUN npm install && npm cache clean --force;
EXPOSE 3000
