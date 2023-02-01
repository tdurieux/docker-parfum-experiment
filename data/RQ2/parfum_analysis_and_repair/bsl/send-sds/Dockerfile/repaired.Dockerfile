FROM	ubuntu
RUN apt-get update && apt-get install --no-install-recommends -qq -y make gcc libasound2-dev libsndfile1-dev && rm -rf /var/lib/apt/lists/*;
RUN	mkdir /src
COPY	. /src
WORKDIR /src
RUN	make && install send-sds /usr/local/bin
