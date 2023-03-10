FROM base

RUN apt-get install --no-install-recommends -y libsdl1.2debian && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libfontconfig1 && rm -rf /var/lib/apt/lists/*;

RUN adduser openttd && mkdir -p /openttd/extract && chown -R openttd:openttd /openttd
WORKDIR /openttd

ADD opengfx*.zip openmsx*.zip opensfx*.zip openttd*.tar.gz /openttd/
RUN mv openttd-*-linux-generic-amd64/* .
RUN unzip openmsx*.zip -d /openttd/extract/
RUN unzip opensfx*.zip -d /openttd/extract/
RUN unzip opengfx*.zip -d /openttd/extract/ && tar -xf /openttd/extract/opengfx*.tar -C /openttd/extract/ && rm /openttd/extract/opengfx*.tar
RUN mv --no-clobber /openttd/extract/*/* /openttd/baseset/

RUN chown -R openttd:openttd /openttd
USER openttd

CMD ["./start-openttd.sh"]