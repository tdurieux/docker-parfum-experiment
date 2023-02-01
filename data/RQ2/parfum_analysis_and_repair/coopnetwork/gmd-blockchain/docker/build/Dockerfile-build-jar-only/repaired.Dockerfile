FROM openjdk:16-bullseye


RUN mkdir -p /output/
RUN mkdir -p /scripts/
RUN mkdir -p /srcgmd/

COPY ./ /srcgmd/

ADD ./docker/build/build.sh /scripts/build.sh
CMD bash /scripts/build.sh