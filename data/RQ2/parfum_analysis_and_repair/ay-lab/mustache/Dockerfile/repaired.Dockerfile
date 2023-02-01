FROM continuumio/anaconda3

RUN apt update && apt install --no-install-recommends -y build-essential zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/ay-lab/mustache

RUN conda env create -f /mustache/environment.yml

RUN echo "conda activate mustache" >> ~/.bashrc