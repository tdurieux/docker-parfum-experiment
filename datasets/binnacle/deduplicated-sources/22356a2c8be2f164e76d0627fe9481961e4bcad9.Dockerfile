#####################
#version: RCT 1.0
#describe rct-analyze
#truman create
#
FROM openjdk:8u181-jdk-alpine3.8
LABEL author="Truman.p.Du"
COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
RUN apk upgrade --update && \
    apk add --update curl tar bash
ENV BASE_DIR /opt/app/rct/rct-analyze
WORKDIR ${BASE_DIR}
ENV RCT_NAME RCT-Analyze
ENV VERSION 2.1.1
RUN apk upgrade --update && \
    apk add --update curl  bash
RUN cd ${BASE_DIR} && \
    curl -fsSL -o ${RCT_NAME}-${VERSION}-release.tar.gz https://github.com/xaecbd/RCT/releases/download/v${VERSION}/${RCT_NAME}-${VERSION}-release.tar.gz && \    
    tar xvf ${RCT_NAME}-${VERSION}-release.tar.gz && \
    rm -rf ${RCT_NAME}-${VERSION}-release.tar.gz
ADD start.sh ${BASE_DIR}
CMD ["sh","start.sh"]
