FROM mysql:latest
MAINTAINER MascoSkray <MascoSkray@gmail.com>

#Update apt and install curl
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
#Run the latest UOJ Community verison db install script
RUN export RAW_URL=https://raw.githubusercontent.com/UniversalOJ/UOJ-System/master && curl -f $RAW_URL/install/db/install.sh | sh

ENV LANG=C.UTF-8 TZ=Asia/Shanghai
