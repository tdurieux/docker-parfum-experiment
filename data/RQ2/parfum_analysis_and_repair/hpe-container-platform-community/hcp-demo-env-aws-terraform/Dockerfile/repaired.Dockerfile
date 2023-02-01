FROM theiaide/theia-full:next

RUN sudo apt-get update \
    && sudo apt-get install --no-install-recommends -y software-properties-common \
    && sudo add-apt-repository -y ppa:deadsnakes/ppa \
    && sudo apt-get update \
    && sudo apt-get install --no-install-recommends -y python3.5 python3.6 python3.7 python3.8 python3.9 tox python3-sphinx \
    && pip3 install --no-cache-dir -U pylint && rm -rf /var/lib/apt/lists/*;
