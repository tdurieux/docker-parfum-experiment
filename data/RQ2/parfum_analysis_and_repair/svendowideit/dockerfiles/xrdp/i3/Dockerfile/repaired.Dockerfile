FROM xrdp

RUN apt-get install --no-install-recommends -yq i3 && rm -rf /var/lib/apt/lists/*;

ADD xsession /home/dockerx/.xsession
