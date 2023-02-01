FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends lzip git make sudo -y && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends gcc-6 g++-6 python3.8 python3.8-dev python3.8-distutils build-essential libssl-dev libffi-dev curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.8 get-pip.py
RUN echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
RUN . ~/.bashrc
RUN git clone --recursive https://github.com/ibarrond/Pyfhel
RUN cd Pyfhel && pip3 install --no-cache-dir .