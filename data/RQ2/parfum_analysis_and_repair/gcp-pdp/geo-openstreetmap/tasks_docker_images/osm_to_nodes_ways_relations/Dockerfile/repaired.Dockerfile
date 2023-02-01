FROM google/cloud-sdk

# update repos
RUN apt-get update -y && apt-get install --no-install-recommends build-essential cmake libboost-dev \
                   libexpat1-dev zlib1g-dev libbz2-dev -y && rm -rf /var/lib/apt/lists/*; # install pyosmium dependencies


# install python GCS sdk
RUN pip3 install --no-cache-dir --upgrade google-cloud-storage

# install pyosmium
RUN pip3 install --no-cache-dir osmium
# install guppy3 (memory profiler)
RUN pip3 install --no-cache-dir guppy3

# set env vars
ENV DATA_DIR /osm_to_nodes_ways_relations/data/

# copy script files
COPY src /osm_to_nodes_ways_relations/src
# set work dir
WORKDIR /osm_to_nodes_ways_relations/src

CMD python3 pbf_parser.py $SRC_OSM_GCS_URI $NODES_WAYS_RELATIONS_DIR_GCS_URI --num_threads $NUM_THREADS
