#
# docker build -t xfce .

FROM xrdp

RUN apt-get install --no-install-recommends -yq xfdesktop4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq xfce4-panel && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq xfwm4 thunar && rm -rf /var/lib/apt/lists/*;

ADD xsession /home/dockerx/.xsession
