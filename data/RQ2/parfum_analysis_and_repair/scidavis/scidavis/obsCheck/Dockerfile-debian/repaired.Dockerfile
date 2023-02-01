FROM debian
ARG project=scidavis
ADD . /root
RUN apt-get update -qq -y
RUN apt-get install --no-install-recommends -y wget gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN wget https://download.opensuse.org/repositories/home:hpcoder1/Debian_10/Release.key
RUN apt-key add - < Release.key
RUN echo 'deb http://download.opensuse.org/repositories/home:/hpcoder1/Debian_10/ /' > /etc/apt/sources.list.d/home:hpcoder1.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y --allow-unauthenticated xvfb $project && rm -rf /var/lib/apt/lists/*;
RUN sh /root/scidavisSmoke.sh
