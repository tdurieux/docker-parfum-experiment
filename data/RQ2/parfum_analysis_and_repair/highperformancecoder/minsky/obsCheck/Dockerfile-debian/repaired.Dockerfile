FROM debian
ARG project=minsky
ADD . /root
RUN apt-get update -qq -y
RUN apt-get install --no-install-recommends -y wget gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN wget -nv https://download.opensuse.org/repositories/home:hpcoder1/Debian_11/Release.key -O Release.key
RUN apt-key add - < Release.key
RUN echo 'deb http://download.opensuse.org/repositories/home:/hpcoder1/Debian_11/ /' > /etc/apt/sources.list.d/home:hpcoder1.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y --allow-unauthenticated $project && rm -rf /var/lib/apt/lists/*;
RUN minsky /root/smoke.tcl
