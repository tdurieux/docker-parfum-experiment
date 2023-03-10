FROM eyevinntechnology/ffmpeg-base:0.3.0
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN cd /root/source && \
    wget https://zebulon.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-634.x86_64-unknown-linux.zip && \
    unzip ./Bento4-SDK-1-6-0-634.x86_64-unknown-linux.zip -d /usr/local && \
    ln -s /usr/local/Bento4-SDK-1-6-0-634.x86_64-unknown-linux /usr/local/bento4
ENV PATH="${PATH}:/usr/local/bento4/bin"
