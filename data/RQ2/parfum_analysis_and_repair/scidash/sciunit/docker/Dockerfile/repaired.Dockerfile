# sciunit
# author Rick Gerkin rgerkin@asu.edu
FROM jupyter/datascience-notebook

RUN apt-get update && apt-get install --no-install-recommends openssh-client -y && rm -rf /var/lib/apt/lists/*; # Needed for Versioned unit tests to pass
RUN git clone http://github.com/scidash/sciunit
WORKDIR sciunit
RUN pip install --no-cache-dir -e .
RUN git clone -b cosmosuite http://github.com/scidash/scidash ../scidash
USER $NB_USER
RUN sh test.sh

