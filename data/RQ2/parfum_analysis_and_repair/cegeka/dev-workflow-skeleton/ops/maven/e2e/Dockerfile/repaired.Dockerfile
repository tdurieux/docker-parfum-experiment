FROM dws/mvn-front-end

ENV DISPLAY=:1.0

RUN echo "deb http://packages.linuxmint.com debian import" >> /etc/apt/sources.list && \
		apt-get update && \
		apt-get install --no-install-recommends -y --force-yes xvfb firefox && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["Xvfb", ":1"]