FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
LABEL description="warpdrive-environment"

RUN apt-get update && yes|apt-get upgrade && apt-get -qq -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/
RUN chmod a+rwx /home/

# Install miniconda to
RUN curl -f -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /home/miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/home/miniconda/bin:${PATH}
RUN conda update -y conda

# Python packages from conda
RUN conda install -c anaconda -y python=3.7.2
RUN conda install -c anaconda -y pip

