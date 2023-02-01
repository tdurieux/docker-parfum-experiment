FROM ubuntu:20.04
ARG project=minsky
ADD . /root
RUN cat /etc/os-release
RUN apt-get update -qq -y
RUN apt-get install --no-install-recommends -y wget gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN wget https://download.opensuse.org/repositories/home:hpcoder1/xUbuntu_20.04/Release.key
RUN apt-key add - < Release.key
RUN echo 'deb http://download.opensuse.org/repositories/home:/hpcoder1/xUbuntu_20.04/ /' >/etc/apt/sources.list.d/hpcoders.list
RUN apt-get update -qq -y
RUN apt-get install --no-install-recommends -y --allow-unauthenticated $project && rm -rf /var/lib/apt/lists/*;
RUN minsky /root/smoke.tcl
