FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive

# Add the git ppa so we can get an update to date version to use with Github Actions.
RUN apt-get update
RUN apt install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:git-core/ppa -y

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential swig python3 gcc-multilib zip fonts-freefont-ttf git vim wget rsync && rm -rf /var/lib/apt/lists/*;

RUN wget https://software-dl.ti.com/processor-sdk-rtos/esd/AM335X/04_01_00_06/exports/ti-processor-sdk-rtos-am335x-evm-04.01.00.06-Linux-x86-Install.bin
RUN chmod +x ti-processor-sdk-rtos-am335x-evm-04.01.00.06-Linux-x86-Install.bin
RUN ./ti-processor-sdk-rtos-am335x-evm-04.01.00.06-Linux-x86-Install.bin --prefix ~/ti --mode unattended
