#
# Copyright (c) 2018 TIBCO Software Inc.
# 
FROM sbrt-base:${docker_base_version}

LABEL description="Streaming Application"

#
# Install application archive & test configurations
#
COPY maven ${STREAMING_RUNTIME_HOME}

#
# entry point to start node
#
ENTRYPOINT ${STREAMING_PRODUCT_HOME}/start-node
