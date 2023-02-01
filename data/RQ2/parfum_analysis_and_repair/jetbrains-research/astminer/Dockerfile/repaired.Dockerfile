FROM ubuntu:20.04

LABEL desc="Docker container to run ASTMiner with all preinstalled requirements"

# Instal OpenJDK11
RUN apt-get update && apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;

# Install G++ (required for Fuzzy parser)
RUN apt-get update && apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;

# Install PythonParser for GumTree
ARG PYTHONPARSER_REPO=https://raw.githubusercontent.com/GumTreeDiff/pythonparser/master
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3.8 python3-pip git wget && \
    mkdir pythonparser && \
    cd pythonparser && \
    wget $PYTHONPARSER_REPO/requirements.txt && \
    wget $PYTHONPARSER_REPO/pythonparser && \
    pip3 install --no-cache-dir -r requirements.txt && \
    chmod +x pythonparser && rm -rf /var/lib/apt/lists/*;
ENV PATH="/pythonparser:${PATH}"

# Install tree sitter, tree sitter grammars and copy scripts
COPY ./src/main/python/parse/tree_sitter aw_tree_sitter
RUN pip install --no-cache-dir ./aw_tree_sitter && \
    git clone https://github.com/tree-sitter/tree-sitter-java.git && \
    aw_tree_sitter -b tree-sitter-java

# Install javalang parser
COPY ./src/main/python/parse/javalang aw_javalang
RUN pip install --no-cache-dir ./aw_javalang

# Install srcML
RUN wget https://131.123.42.38/lmcrs/v1.0.0/srcml_1.0.0-1_ubuntu20.04.deb && \
    apt-get install --no-install-recommends -y libarchive13 && \
    apt-get install --no-install-recommends -y libcurl4 && \
    dpkg -i srcml_1.0.0-1_ubuntu20.04.deb && rm -rf /var/lib/apt/lists/*;

# Copy astminer shadow jar
WORKDIR astminer
COPY ./build/shadow/astminer.jar .

ENTRYPOINT ["java", "-jar", "astminer.jar"]
