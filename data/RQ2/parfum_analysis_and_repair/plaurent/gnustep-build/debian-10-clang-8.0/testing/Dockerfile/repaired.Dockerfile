FROM debian:buster

RUN uname -a
RUN apt-get update && apt-get install --no-install-recommends -y clang build-essential wget git sudo && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y keyboard-configuration && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/plaurent/gnustep-build
RUN cp gnustep-build/*.sh .
RUN cp gnustep-build/debian-10-clang-8.0/*.sh .
RUN cp gnustep-build/debian-10-clang-8.0/testing/Dockerfile .
RUN chmod +x *.sh
RUN /bin/bash -c "./GNUstep-buildon-debian10.sh"

CMD [ "/bin/bash", "-c", "export PS1=allow_bash_to_run; source ~/.bashrc; ./demo.sh" ]
