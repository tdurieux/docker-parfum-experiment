FROM xappbase

RUN apt-get install --no-install-recommends -yq iceweasel && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["iceweasel"]
