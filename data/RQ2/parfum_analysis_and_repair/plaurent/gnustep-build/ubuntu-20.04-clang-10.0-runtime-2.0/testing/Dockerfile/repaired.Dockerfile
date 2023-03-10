FROM ubuntu:20.04

RUN uname -a
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /dev/timezone
RUN apt-get update && apt-get install --no-install-recommends -y git sudo && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/plaurent/gnustep-build
RUN cp gnustep-build/*.sh .
RUN cp gnustep-build/ubuntu-20.04-clang-10.0-runtime-2.0/*.sh .
RUN cp gnustep-build/ubuntu-20.04-clang-10.0-runtime-2.0/testing/Dockerfile .
RUN chmod +x *.sh
RUN /bin/bash -c "./GNUstep-buildon-ubuntu2004.sh"
RUN [ "/bin/bash", "-c", "export PS1=allow_bash_to_run; source ~/.bashrc; ./demo.sh" ]

CMD [ "/bin/bash", "-c", "export PS1=allow_bash_to_run; source ~/.bashrc; ./demo.sh" ]
