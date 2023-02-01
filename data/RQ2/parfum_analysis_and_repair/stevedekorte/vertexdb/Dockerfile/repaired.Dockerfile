FROM 		ruby:latest

ENV		OPTS ""
RUN apt-get update && apt-get install --no-install-recommends --force-yes -y cmake \
							git \
							apt-utils \
							libtokyocabinet-dev \
							zip \
							libyajl-dev \
							libyajl2 \
							libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update  --no-rdoc --no-ri && gem install  --no-rdoc --no-ri \
							yajl			\
							yajl-ruby		\
							zipruby			\
							libevent && rm -rf /root/.gem;


RUN		git clone https://github.com/stevedekorte/vertexdb.git vertexdb

WORKDIR		vertexdb

RUN		cmake .		&&\
		make		&&\
		make install

EXPOSE		8080

ENTRYPOINT	["/usr/local/bin/vertexdb"]
CMD		["-db", "/opt/database", "--pid", "/var/run/vertex.pid", "-H", "0.0.0.0", "-p", "80", "$OPTS"]
