FROM ubuntu:16.04
RUN apt-get update \
    && apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install \
    curl \
    python-software-properties \

    software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
RUN sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install npm@latest && npm cache clean --force;

# install python
RUN sudo add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update
RUN sudo apt-get -y --no-install-recommends install python3.6 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

# install tensorspacejs
RUN python3.6 -m pip install tensorspacejs
RUN echo "alias python=python3.6" >> ~/.bash_aliases
RUN . ~/.bash_aliases

# initalize tensorspacejs
RUN tensorspacejs_converter -init

WORKDIR /data

CMD ["bash", "/data/converter.sh"]
