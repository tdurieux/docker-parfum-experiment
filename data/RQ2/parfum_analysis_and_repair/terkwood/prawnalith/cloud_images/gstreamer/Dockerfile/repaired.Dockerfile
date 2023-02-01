FROM maxmcd/gstreamer

RUN apt-get update
RUN apt-get install --no-install-recommends -y gstreamer1.0-plugins-base && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gstreamer1.0-plugins-good && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gstreamer1.0-plugins-bad && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gstreamer1.0-plugins-ugly && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gstreamer1.0-libav && rm -rf /var/lib/apt/lists/*;
RUN echo Peaceful Stream Vintage
RUN mkdir /stream
WORKDIR "/stream"
ADD . ./
ENTRYPOINT ["sh", "recv.sh"]
