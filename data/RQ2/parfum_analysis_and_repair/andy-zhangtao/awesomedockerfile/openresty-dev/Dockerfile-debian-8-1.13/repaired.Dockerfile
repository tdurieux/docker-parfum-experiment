# vikings/openresty:8-debian-1.13
FROM	debian:8
RUN apt-get update && \
			apt-get install --no-install-recommends -y wget gnupg software-properties-common && \
			wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add - && \
			add-apt-repository -y "deb http://ftp.debian.org/debian wheezy-backports main" && \
			add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty" && \
			apt-get update && \
			apt-get install --no-install-recommends -y openresty=1.11.2.5-3~jessie1 && rm -rf /var/lib/apt/lists/*;
