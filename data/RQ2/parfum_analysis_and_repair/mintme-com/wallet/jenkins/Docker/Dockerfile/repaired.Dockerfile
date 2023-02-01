FROM electronuserland/builder:wine-03.18

RUN mkdir /hostHome
RUN apt-get update && apt-get install --no-install-recommends -y libusb-1.0 nasm graphicsmagick autoconf automake libtool python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli --upgrade --user
ENV PATH "$PATH:/root/.local/bin"
