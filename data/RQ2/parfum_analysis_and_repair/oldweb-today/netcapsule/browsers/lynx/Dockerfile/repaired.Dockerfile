FROM netcapsule/base-browser

RUN apt-get update && apt-get install --no-install-recommends -y \
    lynx-cur \
    && rm -rf /var/lib/apt/lists/*

USER browser

COPY run.sh /app/run.sh
RUN sudo chmod a+x /app/run.sh

CMD /app/entry_point.sh /app/run.sh


