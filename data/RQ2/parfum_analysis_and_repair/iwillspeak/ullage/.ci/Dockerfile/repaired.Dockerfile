FROM ubuntu:20.04
RUN apt-get update && \
	apt-get install --no-install-recommends -y wget curl gnupg2 lsb-release software-properties-common && \
	curl -f -O https://apt.llvm.org/llvm.sh && \
	chmod +x llvm.sh && \
	./llvm.sh 9 && \
	apt-get install --no-install-recommends -y sudo && \
	apt-get install --no-install-recommends -y python3 && \
	apt-get install --no-install-recommends -y llvm-9-dev && \
	apt-get install --no-install-recommends -y clang binutils && \
	apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;
