FROM ubuntu:16.04
MAINTAINER Dilawar Singh <dilawar.s.rajput@gmail.com>

# If you are behind proxy,  uncomment the following lines with appropriate
# values.
ENV http_proxy http://proxy.ncbs.res.in:3128
ENV https_proxy http://proxy.ncbs.res.in:3128

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget x11-apps xorg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-matplotlib python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip python-networkx graphviz python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pygraphviz && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir python-libsbml pyneuroml

# Install the package from STABLE channel.
RUN wget -nv https://download.opensuse.org/repositories/home:moose/xUbuntu_16.04/Release.key -O /tmp/Release.key
RUN apt-key add - < /tmp/Release.key
RUN sh -c "echo 'deb http://download.opensuse.org/repositories/home:/moose/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/moose.list"
RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated moose-nightly && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password --gecos '' mooser

USER mooser
ENV HOME /home/mooser
CMD /usr/bin/xterm
