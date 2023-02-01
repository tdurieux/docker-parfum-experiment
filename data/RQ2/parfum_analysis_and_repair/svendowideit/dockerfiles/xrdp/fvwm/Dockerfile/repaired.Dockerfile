FROM xrdp

RUN apt-get install --no-install-recommends -yq fvwm && rm -rf /var/lib/apt/lists/*;

ADD xsession /home/dockerx/.xsession

