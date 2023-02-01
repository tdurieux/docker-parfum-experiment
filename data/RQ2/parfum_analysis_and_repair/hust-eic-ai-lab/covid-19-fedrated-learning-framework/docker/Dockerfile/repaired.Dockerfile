FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel
WORKDIR /workspace/UCADI
RUN apt-get update
RUN apt-get -y --no-install-recommends install apt-file apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-file update
RUN apt-get -y --no-install-recommends install vim git re2c screen build-essential libcap-dev && rm -rf /var/lib/apt/lists/*;
COPY ./docker/requirements_docker.txt /workspace/UCADI
RUN pip install --no-cache-dir -r requirements_docker.txt

# ref: https://github.com/NVIDIA/apex
RUN git clone https://github.com/NVIDIA/apex
WORKDIR /workspace/FL_COVID19/apex
RUN pip install -v --no-cache-dir ./

# ref: https://github.com/ninja-build/ninja
WORKDIR /workspace/UCADI
RUN git clone https://github.com/ninja-build/ninja.git
WORKDIR /workspace/UCADI/ninja
RUN ./configure.py --bootstrap

RUN useradd hcw
WORKDIR /workspace/UCADI