FROM blabla1337/owasp-skf-lab:base-v0.1

LABEL maintainer="Glenn ten Cate"
ENV APPNAME="labs"

RUN \
 echo "**** install deps ****" && \
 apt-get update && \
 apt-get install -qy --no-install-recommends \
	wget \
	git \
	firefox \	
	psmisc \
	openjdk-11-jdk \
	obmenu \
	lxterminal \
	python \
	rofi \
	feh \
	pcmanfm \
	libxss1 && rm -rf /var/lib/apt/lists/*;

#install Polybar
RUN apt-get install --no-install-recommends -qy cmake \
	python3-sphinx \
	python3-pip \
	cmake-data \
	libcairo2-dev \
	libxcb1-dev \
	libuv1-dev \
	libxcb-ewmh-dev \
	libxcb-icccm4-dev \
	libxcb-image0-dev \
	libxcb-randr0-dev \
	libxcb-util0-dev \
	libxcb-xkb-dev \
	pkg-config \
	python-xcbgen \
	xcb-proto \
	libxcb-xrm-dev \
	i3-wm \
	libasound2-dev \
	libmpdclient-dev \
	libiw-dev \
	libcurl4-openssl-dev \
	libpulse-dev \
	libxcb-composite0-dev \
	xcb \
	libxcb-ewmh2 && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir packaging
RUN git clone https://github.com/jaagr/polybar.git
RUN sed -e s/sudo//g -i polybar/build.sh
RUN cd polybar; echo "\n" | ./build.sh -i
RUN mv /usr/local/bin/polybar /usr/bin/polybar
RUN mv /usr/local/bin/polybar-msg /usr/bin/polybar-msg

# install OWASP SKF Labs
RUN git clone https://github.com/blabla1337/skf-labs.git
RUN mv skf-labs/python /config
RUN mv /config/python /config/python-labs
RUN chown -R abc:abc /config/python-labs

# install OWASP ZAP
RUN wget https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2_11_1_unix.sh
RUN	chmod +x ZAP_2_11_1_unix.sh
RUN	./ZAP_2_11_1_unix.sh -q
RUN mv /usr/local/bin/zap.sh /usr/bin/zap.sh

# install Sublime editor
RUN apt install --no-install-recommends -y apt-transport-https ca-certificates curl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN	curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
RUN add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
RUN apt update && apt install --no-install-recommends -y sublime-text && rm -rf /var/lib/apt/lists/*;

RUN echo "**** clean up ****" && \
 rm -rf \
	ZAP_2_11_1_unix.sh \ 
	/tmp/* \
	/skf-labs \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /
COPY /runner-script.sh /config
COPY /.config /config/.config
COPY /.local /config/.local
COPY /.config/openbox/.themes /usr/share/themes

# ports and volumes
EXPOSE 3389
VOLUME /config

