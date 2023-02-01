FROM ubuntu:18.04

WORKDIR /megflow

# install requirements
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget yasm clang git build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt update && apt-get install --no-install-recommends -y pkg-config --fix-missing && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libv4l-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;

# prepare cargo env
ENV CARGO_HOME /cargo
ENV RUSTUP_HOME /rustup
RUN curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf -o run.sh \
	&& chmod a+x run.sh \
	&& ./run.sh -y && rm run.sh
ENV PATH $PATH:/cargo/bin
RUN chmod -R 777 /cargo /rustup
COPY ci/cargo-config.github /cargo/config

# copy workspace
RUN mkdir -p $HOME/megflow-runspace
WORKDIR $HOME/megflow-runspace

# build conda env and activate
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /conda && rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH $PATH:/conda/bin
RUN echo "PATH=${PATH}" >> ~/.bashrc
RUN conda init

COPY . $HOME/megflow-runspace/

# python install
RUN cd flow-python && python3 setup.py install --user

RUN export PATH=/root/.local/bin:${PATH} && cd flow-python/examples \
	&& megflow_run -p logical_test
