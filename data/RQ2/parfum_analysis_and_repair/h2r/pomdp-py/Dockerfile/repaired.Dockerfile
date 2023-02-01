FROM continuumio/miniconda3

WORKDIR /app

RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*; # RUN apt-get install gcc g++ cmake vim -y


RUN conda create -n pomdp python=3.8 -y

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "pomdp", "/bin/bash", "-c"]

RUN pip install --no-cache-dir Cython
RUN git clone https://github.com/h2r/pomdp-py.git
RUN cd pomdp-py/ && pip install --no-cache-dir -e.
WORKDIR /app/pomdp-py

# activate 'pomdp' environment by default
RUN echo "conda activate pomdp" >> ~/.bashrc