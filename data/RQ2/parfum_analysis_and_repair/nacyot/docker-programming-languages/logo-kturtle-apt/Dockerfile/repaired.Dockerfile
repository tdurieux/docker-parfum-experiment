FROM nacyot/vnc
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y kturtle && rm -rf /var/lib/apt/lists/*;

RUN bash -c 'echo "kturtle -i /source/hello_world.logo" >> /root/.zshrc'

# Set default WORKDIR
WORKDIR /source
CMD x11vnc -forever -usepw -create
