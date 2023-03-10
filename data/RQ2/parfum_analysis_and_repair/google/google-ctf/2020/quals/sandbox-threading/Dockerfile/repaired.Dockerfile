FROM ubuntu:18.04
RUN set -e -x; \
        apt-get -y update; \
        apt-get -y upgrade; \
	apt-get install --no-install-recommends -y software-properties-common; rm -rf /var/lib/apt/lists/*; \
	add-apt-repository -y ppa:ubuntu-toolchain-r/test; \
	apt-get -y update; \
	apt-get -y upgrade libstdc++6; \
	apt-get install --no-install-recommends -y python2.7;

RUN set -e -x; \
	apt-get -y update; \
	apt-get install --no-install-recommends -y clang-tools libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 lld lldb llvm-runtime llvm clang && rm -rf /var/lib/apt/lists/*;

RUN set -e -x; \
        groupadd -g 1337 user; \
        useradd -g 1337 -u 1337 -m user

COPY ./ /home/user/
COPY flag /flag

RUN set -e -x; \
	chmod +x /home/user/server; \
	chown -R user:user /home/user; \
	find /home/user | grep ".*\.sh$" | xargs -I{} chmod +x {}

USER user
CMD cd /home/user && ./server_launch.sh

