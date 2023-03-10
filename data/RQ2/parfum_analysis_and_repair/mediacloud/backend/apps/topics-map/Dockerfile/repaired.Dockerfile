#
# map topic worker
#

FROM gcr.io/mcback/common:latest

# Install Java
RUN \
    apt-get -y update && \ 
    apt-get -y --no-install-recommends install openjdk-8-jre-headless && \
    true && rm -rf /var/lib/apt/lists/*;

# Install fa2l Java libs
RUN \
    mkdir /opt/fa2l && \
    cd /opt/fa2l && \
    /dl_to_stdout.sh \
        "https://github.com/klarman-cell-observatory/forceatlas2/releases/download/1.0.3/forceatlas2.jar" \
        > "forceatlas2.jar" && \
    /dl_to_stdout.sh \
        "https://github.com/klarman-cell-observatory/forceatlas2/releases/download/1.0.3/gephi-toolkit-0.9.2-all.jar" \
        > "gephi-toolkit.jar" && \
    true

# Install Python dependencies
COPY src/requirements.txt /var/tmp/
RUN \
    cd /var/tmp/ && \
    pip3 install --no-cache-dir -r requirements.txt && \
    rm requirements.txt && \
    rm -rf /root/.cache/ && \
    true

# Copy sources
COPY src/ /opt/mediacloud/src/topics-map/
ENV PYTHONPATH="/opt/mediacloud/src/topics-map/python:${PYTHONPATH}"

# Copy worker script
COPY bin /opt/mediacloud/bin

USER mediacloud

CMD ["topics_map_worker_wrapper.sh"]
