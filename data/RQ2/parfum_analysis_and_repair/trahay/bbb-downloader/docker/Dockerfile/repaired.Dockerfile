FROM debian:11

LABEL Author="François Trahay <francois.trahay@telecom-sudparis.eu>"
LABEL Title="BBB-downloader in Docker"

ENV BBB_PATH "/opt/bbb-downloader"
ENV PATH "$PATH:$BBB_PATH"

# Install build tools
RUN apt update \
  && apt install --no-install-recommends -y \
  python3 \
  python3-pip \
  ffmpeg \
  bc \
  docker.io \
  npm \
  git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/trahay/bbb-downloader.git ${BBB_PATH}
RUN cd ${BBB_PATH} && npm install && npm cache clean --force;
RUN cd ${BBB_PATH} && pip3 install --no-cache-dir -r python-requirements.txt
