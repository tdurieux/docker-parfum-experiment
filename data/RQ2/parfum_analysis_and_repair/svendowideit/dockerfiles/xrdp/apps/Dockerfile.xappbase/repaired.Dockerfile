FROM appbase

RUN apt-get install --no-install-recommends -yq x11-common x11-utils x11-xserver-utils && rm -rf /var/lib/apt/lists/*;

