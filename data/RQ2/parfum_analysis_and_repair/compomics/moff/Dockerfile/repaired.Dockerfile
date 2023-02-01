from continuumio/miniconda3

COPY moff_enviroment.yml .
RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN conda env create -f moff_enviroment.yml
RUN echo "source activate moff_env" >>  ~/.bashrc
ENV PATH /opt/conda/envs/moff_env/bin:$PATH
RUN git clone  -b master  --single-branch https://github.com/compomics/moff /moFF
WORKDIR /moFF


