FROM xappbase

RUN apt-get install --no-install-recommends -yq xchat && rm -rf /var/lib/apt/lists/*;


ENTRYPOINT ["xchat"]
