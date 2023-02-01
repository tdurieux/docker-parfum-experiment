FROM       jrottenberg/ffmpeg:4.2-ubuntu

WORKDIR    /app

RUN        apt-get update

RUN apt-get install --no-install-recommends -y software-properties-common wget && rm -rf /var/lib/apt/lists/*;

RUN        wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-12_all.deb && dpkg -i repo-mediaarea_1.0-12_all.deb && apt-get update

RUN apt-get -y --no-install-recommends install mediainfo wget openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y unzip python && rm -rf /var/lib/apt/lists/*;

RUN wget "https://zebulon.bok.net/Bento4/binaries/Bento4-SDK-1-5-1-629.x86_64-unknown-linux.zip" && \
             unzip Bento4-SDK-1-5-1-629.x86_64-unknown-linux.zip && \
             rm Bento4-SDK-1-5-1-629.x86_64-unknown-linux.zip && \
             mv Bento4-SDK-1-5-1-629.x86_64-unknown-linux bento4

ENV        PATH $PATH:/app/bento4/bin

ENTRYPOINT ["java","-jar","/app/piper.jar"]

COPY       target/piper-0.0.1-SNAPSHOT.jar /app/piper.jar