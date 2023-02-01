FROM appbase

RUN apt-get install --no-install-recommends -yq vim-tiny && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["vi"]
