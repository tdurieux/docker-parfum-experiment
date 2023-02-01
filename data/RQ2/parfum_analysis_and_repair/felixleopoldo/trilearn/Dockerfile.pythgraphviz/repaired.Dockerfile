FROM continuumio/miniconda3
RUN apt-get update && apt-get install --no-install-recommends -y python-dev graphviz libgraphviz-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN conda install python=2.7
RUN conda install -c anaconda pygraphviz
#RUN pip install trilearn   
