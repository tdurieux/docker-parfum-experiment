FROM continuumio/miniconda3
MAINTAINER Jan Rudolph <jan.daniel.rudolph@gmail.com>

# INSTALL REDIS
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.redis.io/redis-stable.tar.gz \
  && tar xvzf redis-stable.tar.gz \
  && rm redis-stable.tar.gz \
  && cd redis-stable \
  && make

# DOWNLOAD DATABASES
RUN wget https://cs.tau.ac.il/~jandanielr/db.tar.gz \
  && tar xvzf db.tar.gz \
  && rm db.tar.gz

# INSTALL DEPENDENCIES
COPY conda_requirements.txt conda_requirements.txt
RUN conda install --yes --file conda_requirements.txt
COPY pip_requirements.txt pip_requirements.txt
RUN pip install --no-cache-dir -r pip_requirements.txt

COPY . photon
WORKDIR photon
RUN pip install --no-cache-dir -e .

RUN mv /db db
RUN chmod +x phos/app.py

# RUN CELERY AS ROOT
ENV C_FORCE_ROOT TRUE

EXPOSE 5000

ENTRYPOINT ["./run.sh"]
