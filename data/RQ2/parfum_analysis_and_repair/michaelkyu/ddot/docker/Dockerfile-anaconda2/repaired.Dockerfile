# Use an official Python runtime as a parent image
FROM continuumio/anaconda

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# Install any needed packages specified in requirements.txt
RUN conda install -c conda-forge python-igraph
RUN conda install networkx=1.11

# libiconv seems to be necessary for conda's python-igraph to work correctly
RUN conda install libiconv

RUN pip install --no-cache-dir tulip-python ndex-dev

RUN pip install --no-cache-dir simplejson mygene

RUN echo a

RUN git clone -b 'v1.0' --depth 1 https://github.com/michaelkyu/ddot.git ddot

RUN cd ddot && make
RUN cd ..

RUN pip install --no-cache-dir ddot/
RUN mv ddot/examples /ddot_examples
RUN rm -rf ddot

WORKDIR /ddot_examples
