FROM arwineap/docker-ubuntu-python3.6

RUN apt-get update

# Install latest version of python3
RUN apt install --no-install-recommends -y python3.6 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade setuptools
RUN apt-get install --no-install-recommends -y python3.6-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libblas-dev libatlas-base-dev && rm -rf /var/lib/apt/lists/*;

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

RUN apt-get install --no-install-recommends -y python3-tk && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libglib2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libsm6 libxext6 && rm -rf /var/lib/apt/lists/*;

# Install bindsnet and dependencies
RUN pip install --no-cache-dir bindsnet

# Install git
RUN apt-get install --no-install-recommends -y git-core && rm -rf /var/lib/apt/lists/*;

# Install vim
RUN apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir jupyter -U && pip install --no-cache-dir jupyterlab

# Bind python3.6 to python
RUN touch ~/.bash_aliases
RUN echo alias python=\'/usr/bin/python3.6\' >> ~/.bash_aliases

# Create a working directory to work from
RUN mkdir working

# Always start from /working
RUN chmod 777 \/working
ENTRYPOINT ["/working"]

