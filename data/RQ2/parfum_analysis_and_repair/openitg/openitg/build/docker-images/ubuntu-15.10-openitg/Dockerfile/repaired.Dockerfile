FROM ubuntu:15.10
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y autoconf automake gettext gcc g++ make git build-essential zip unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxt-dev libogg-dev libpng12-dev libjpeg-dev libvorbis-dev libusb-dev libglu1-mesa-dev libx11-dev libxrandr-dev liblua50-dev liblualib50-dev libmad0-dev libasound2-dev libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libavcodec-dev libavformat-dev libswscale-dev libavutil-dev && rm -rf /var/lib/apt/lists/*;
CMD /bin/bash
