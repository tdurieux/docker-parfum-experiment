FROM madduci/docker-linux-cpp

RUN apt-get update && apt-get install --no-install-recommends -y make pkg-config git && rm -rf /var/cache/apt/* && ln -s /usr/bin/g++-9 /usr/bin/g++ && rm -rf /var/lib/apt/lists/*;



