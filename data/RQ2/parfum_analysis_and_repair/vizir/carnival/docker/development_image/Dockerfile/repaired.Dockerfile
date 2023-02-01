FROM rails:4.1.8

RUN apt-get update && \
  apt-get install --no-install-recommends -qy qt5-default libqt5webkit5-dev xvfb && rm -rf /var/lib/apt/lists/*;

ADD xvfb /etc/init.d/

ADD entrypoint /usr/bin/

ENV BUNDLE_APP_CONFIG /app/.bundle
ENV DISPLAY :1

ENTRYPOINT ["/usr/bin/entrypoint"]
