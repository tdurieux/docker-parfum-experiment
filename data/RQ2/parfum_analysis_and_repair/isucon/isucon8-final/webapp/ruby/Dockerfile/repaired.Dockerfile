FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y build-essential git-core tzdata ruby ruby-dev ruby-bundler libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
ENV TZ=Asia/Tokyo
