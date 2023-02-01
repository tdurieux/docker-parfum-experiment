FROM golang as build

# go mod Installation source, container environment variable addition will override the default variable value
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct

# Set up the working directory
WORKDIR /Open-IM-Server
# add all files to the container
COPY . .

WORKDIR /Open-IM-Server/script
RUN chmod +x *.sh

RUN /bin/sh -c ./build_all_service.sh

#Blank image Multi-Stage Build
FROM ubuntu

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends apt-transport-https && apt-get install -y --no-install-recommends procps \
&& apt-get install -y --no-install-recommends net-tools && rm -rf /var/lib/apt/lists/*;
#Non-interactive operation
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install --no-install-recommends -y vim curl tzdata gawk && rm -rf /var/lib/apt/lists/*;
#Time zone adjusted to East eighth District
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata


#set directory to map logs,config file,script file.
VOLUME ["/Open-IM-Server/logs","/Open-IM-Server/config","/Open-IM-Server/script","/Open-IM-Server/db/sdk"]

#Copy scripts files and binary files to the blank image
COPY --from=build /Open-IM-Server/script /Open-IM-Server/script
COPY --from=build /Open-IM-Server/bin /Open-IM-Server/bin

WORKDIR /Open-IM-Server/script

CMD ["./docker_start_all.sh"]
