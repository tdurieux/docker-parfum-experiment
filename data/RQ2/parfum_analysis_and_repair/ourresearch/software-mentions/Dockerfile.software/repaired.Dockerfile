# -------------------
# build builder image
# -------------------

FROM openjdk:8u275-jdk as builder

USER root

RUN apt-get update && \
    apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/grobid-source

# gradle
COPY gradle/ ./gradle/
COPY gradlew ./
COPY gradle.properties ./
COPY build.gradle ./
COPY settings.gradle ./

# source
COPY software-mentions/ ./software-mentions/
COPY grobid-home/ ./grobid-home/
COPY grobid-core/ ./grobid-core/
COPY grobid-service/ ./grobid-service/
COPY grobid-trainer/ ./grobid-trainer/

# cleaning unused native libraries before packaging
RUN rm -rf grobid-home/pdf2xml
RUN rm -rf grobid-home/pdfalto/lin-32
RUN rm -rf grobid-home/pdfalto/mac-64
RUN rm -rf grobid-home/pdfalto/win-*
RUN rm -rf grobid-home/lib/lin-32
RUN rm -rf grobid-home/lib/win-*
RUN rm -rf grobid-home/lib/mac-64

# cleaning unused datasets stuff
RUN rm -rf software-mentions/resources/dataset

RUN ./gradlew clean assemble install --no-daemon  --info --stacktrace

WORKDIR ./software-mentions/
RUN ./gradlew clean install --no-daemon  --info --stacktrace

WORKDIR /opt/grobid
RUN unzip -o /opt/grobid-source/grobid-service/build/distributions/grobid-service-*.zip && \
    mv grobid-service* grobid-service
RUN unzip -o /opt/grobid-source/grobid-home/build/distributions/grobid-home-*.zip && \
    chmod -R 755 /opt/grobid/grobid-home/pdfalto
RUN rm -rf grobid-source

# -------------------
# build runtime image
# -------------------

# use NVIDIA Container Toolkit to automatically recognize possible GPU drivers on the host machine
FROM tensorflow/tensorflow:2.7.0-gpu
#CMD nvidia-smi

# setting locale is likely useless but to be sure
ENV LANG C.UTF-8

# install JRE 8, python and other dependencies
RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-utils build-essential gcc libxml2 unzip curl \
    openjdk-8-jdk ca-certificates-java \
    musl gfortran \
    python3 python3-pip python3-setuptools python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/grobid

COPY --from=builder /opt/grobid .

RUN python3 -m pip install pip --upgrade

# install DeLFT via pypi
RUN pip3 install --no-cache-dir requests delft==0.3.1
# link the data directory to /data
# the current working directory will most likely be /opt/grobid
RUN mkdir -p /data \
    && ln -s /data /opt/grobid/data \
    && ln -s /data ./data

# disable python warnings (and fix logging)
ENV PYTHONWARNINGS="ignore"

WORKDIR /opt/grobid

ENV JAVA_OPTS=-Xmx4g

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "-s", "--"]

# install jep (and temporarily the matching JDK)
ENV TEMP_JDK_HOME=/tmp/jdk-${JAVA_VERSION}
ENV JDK_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u212-b04/OpenJDK8U-x64_linux_8u212b04.tar.gz
RUN curl --fail --show-error --location -q ${JDK_URL} -o /tmp/openjdk.tar.gz \
    && ls -lh /tmp/openjdk.tar.gz \
    && mkdir - "${TEMP_JDK_HOME}" \
    && tar --extract \
        --file /tmp/openjdk.tar.gz \
        --directory "${TEMP_JDK_HOME}" \
        --strip-components 1 \
        --no-same-owner \
    && JAVA_HOME=${TEMP_JDK_HOME} pip3 --no-cache-dir install jep==4.0.2 \
    && rm -f /tmp/openjdk.tar.gz \
    && rm -rf "${TEMP_JDK_HOME}"
ENV LD_LIBRARY_PATH=/usr/local/lib/python3.8/dist-packages/jep:${LD_LIBRARY_PATH}
# remove libjep.so because we are providng our own version in the virtual env
RUN rm /opt/grobid/grobid-home/lib/lin-64/jep/libjep.so

# preload embeddings, for GROBID all the RNN models use glove-840B (default for the script), ELMo is currently not loaded

COPY --from=builder /opt/grobid-source/grobid-home/scripts/preload_embeddings.py .
COPY --from=builder /opt/grobid-source/grobid-home/config/resources-registry.json .
#RUN python3 preload_embeddings.py --embedding word2vec --registry ./resources-registry.json
RUN ln -s /opt/grobid /opt/delft

COPY --from=builder /opt/grobid-source/software-mentions /opt/grobid/software-mentions
COPY --from=builder /root/.m2/repository/org /opt/grobid/software-mentions/lib/org

WORKDIR /opt/grobid/software-mentions

RUN mkdir /opt/grobid/delft
RUN mkdir /opt/grobid/delft/delft
COPY --from=builder /opt/grobid-source/grobid-home/config/resources-registry.json /opt/grobid/delft/delft/resources-registry.json

# trigger gradle wrapper install
RUN ./gradlew --version

RUN ./gradlew copyModels installScibert  && rm -rf resources/models && rm -f /opt/grobid/grobid-home/models/software/model.wapiti.gz && rm -f /opt/grobid/grobid-home/models/software-BERT_CRF-0.3.0.zip && rm -f /opt/grobid/grobid-home/models/software_context_bert-0.3.0.zip && rm -f /opt/grobid/grobid-home/models/software_context_used_bert-0.3.0.zip && rm -f /opt/grobid/grobid-home/models/software_context_shared_bert-0.3.0.zip && rm -f /opt/grobid/grobid-home/models/software_context_creation_bert-0.3.0.zip

RUN ./gradlew clean install

CMD ["./gradlew", "run"]

ARG GROBID_VERSION

LABEL \
    authors="The contributors" \
    org.label-schema.name="software-mentions" \
    org.label-schema.description="Image with software-mentions service" \
    org.label-schema.url="https://github.com/ourresearch/software-mentions" \
    org.label-schema.version=${GROBID_VERSION}
