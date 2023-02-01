FROM ubuntu:20.04

ADD . /botpress
WORKDIR /botpress

RUN apt update && \
	apt install --no-install-recommends -y wget ca-certificates && \
	update-ca-certificates && \
	wget -O duckling https://s3.amazonaws.com/botpress-binaries/duckling-example-exe && \
	chmod +x duckling && \
	chmod +x bp && \
	chgrp -R 0 /botpress && \
	chmod -R g=u /botpress && \
	apt install --no-install-recommends -y tzdata && \
	ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
	dpkg-reconfigure --frontend noninteractive tzdata && \
	./bp extract && rm -rf /var/lib/apt/lists/*;


ENV BP_MODULE_NLU_DUCKLINGURL=http://localhost:8000
ENV BP_IS_DOCKER=true

ENV LANG=C.UTF-8
EXPOSE 3000

CMD ./duckling & ./bp