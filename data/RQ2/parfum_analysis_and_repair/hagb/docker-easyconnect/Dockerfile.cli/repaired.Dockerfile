FROM debian:buster-slim

ARG BUILD_ENV=local

RUN if [ "${BUILD_ENV}" = "local" ]; then sed -i s/deb.debian.org/mirrors.aliyun.com/ /etc/apt/sources.list; fi && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests iptables \
	dante-server busybox iproute2 tinyproxy-bin && \
    for command in ps kill killall; do ln -s "$(which busybox)" /usr/local/bin/"${command}" || exit 1 ; done && \
    rm -rf /var/lib/apt/lists/*

ARG EC_CLI_URL="https://github.com/shmilee/scripts/releases/download/v0.0.1/easyconn_7.6.8.2-ubuntu_amd64.deb"

RUN EC_DIR=/usr/share/sangfor/EasyConnect/resources && cd tmp && \
    busybox wget "${EC_CLI_URL}" -O easyconn.deb && \
    dpkg -x easyconn.deb easyconn && \
    bash -c " \
        mkdir -p ${EC_DIR}/{bin,lib64,shell,logs}/ && \
        cp easyconn/${EC_DIR}/bin/{CSClient,easyconn,ECAgent,svpnservice,ca.crt,cert.crt} \
                   /${EC_DIR}/bin/ && \
        chmod +xs ${EC_DIR}/bin/{CSClient,ECAgent,svpnservice} && \
        cp easyconn/${EC_DIR}/lib64/lib{nspr4,nss3,nssutil3,plc4,plds4,smime3}.so \
                   /${EC_DIR}/lib64/" && \
    cp easyconn/${EC_DIR}/shell/* \
               /${EC_DIR}/shell/ && \
    chmod +x ${EC_DIR}/shell/* && \
    ln -s ${EC_DIR}/bin/easyconn /usr/local/bin/ && \
    cp -r easyconn/${EC_DIR}/conf ${EC_DIR}/conf_7.6.8 && rm -r *

ARG EC_763_URL="http://download.sangfor.com.cn/download/product/sslvpn/pkg/linux_01/EasyConnect_x64.deb"
ARG EC_767_URL="http://download.sangfor.com.cn/download/product/sslvpn/pkg/linux_767/EasyConnect_x64_7_6_7_3.deb"

RUN cd /tmp && \
    for ver in 7.6.3 7.6.7 ; do { \
        vername=EC_$( echo "$ver" | sed 's/\.//g' )_URL && \
        url="$(eval printf %s \"\$$vername\")" && \
        if [ -n "${url}" ]; then busybox wget "${url}" -O EasyConnect.deb && dpkg -x EasyConnect.deb ec && \
        cp -r ec/usr/share/sangfor/EasyConnect/resources/conf \
                /usr/share/sangfor/EasyConnect/resources/conf_$ver && \
        rm -r *; fi ;} || exit 1 ; done

RUN for i in /usr/share/sangfor/EasyConnect/resources/conf_*/; do \
        ln -s /root/.easyconn $i/.easyconn ; \
    done && touch /root/.easyconn

COPY ./docker-root /

COPY --from=fake-hwaddr fake-hwaddr/fake-hwaddr.so /usr/local/lib/fake-hwaddr.so

VOLUME /root/ /usr/share/sangfor/EasyConnect/resources/logs/

CMD _EC_CLI=1 start.sh