FROM area9/flowcpp

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    ffmpeg && rm -rf /var/lib/apt/lists/*;

USER flow

