FROM ubuntu:22.04
RUN apt update
RUN apt install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN uname -a
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /dev/timezone
RUN apt-get update && apt-get install --no-install-recommends -y git sudo && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/plaurent/gnustep-build
RUN cp gnustep-build/*.sh .
RUN cp gnustep-build/ubuntu-22.04-clang-14.0-runtime-2.1/*.sh .
RUN cp gnustep-build/ubuntu-22.04-clang-14.0-runtime-2.1/testing/Dockerfile .
RUN chmod +x *.sh

CMD [ "/bin/bash", "-c", "export PS1=allow_bash_to_run; source ~/.bashrc; ./libobjc2-teston-ubuntu2204.sh" ]
