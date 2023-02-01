FROM xappbase

RUN apt-get install --no-install-recommends -yq xterm && rm -rf /var/lib/apt/lists/*;


ENTRYPOINT ["xterm"]
