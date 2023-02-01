# registry.cn-beijing.aliyuncs.com/yunionio/debian10-base:1.0

FROM debian:10

RUN apt update && apt install --no-install-recommends -y alien && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean autoclean && \
	apt-get autoremove --yes && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/
