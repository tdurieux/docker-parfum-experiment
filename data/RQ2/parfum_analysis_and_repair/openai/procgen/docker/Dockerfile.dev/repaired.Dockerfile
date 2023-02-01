# This Dockerfile demonstrates the "Install from Source" option for using procgen
FROM ubuntu:bionic-20191202
RUN apt-get update && apt-get install --yes --no-install-recommends ca-certificates curl build-essential mesa-common-dev libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o /tmp/miniconda-installer.sh https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh
RUN bash /tmp/miniconda-installer.sh -b -p ~/miniconda
ADD environment.yml .
RUN ~/miniconda/bin/conda env update --name dev --file environment.yml
ENV PATH=/root/miniconda/envs/dev/bin:/root/miniconda/bin:$PATH
ADD . /procgen
RUN pip install --no-cache-dir -e /procgen
RUN python -c "from procgen import ProcgenGym3Env; ProcgenGym3Env(num=1, env_name='coinrun')"