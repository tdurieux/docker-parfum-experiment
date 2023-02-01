FROM continuumio/miniconda3:4.8.2

LABEL Name=chromosight Version=1.6.2

COPY * ./ /app/
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN conda config --add channels bioconda
RUN conda install -c conda-forge -y cooler pip \
  && conda clean -afy

RUN pip install --no-cache-dir -Ur requirements.txt
RUN pip install --no-cache-dir .

ENTRYPOINT [ "chromosight" ]
