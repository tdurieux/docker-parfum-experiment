FROM python:3.6.2-slim
WORKDIR '/skills-labeller'

# Required system libraries
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Required inital python related files
ADD etl/requirements.txt requirements.txt
RUN pip install -r requirements.txt --no-cache-dir
# DEBUG: TODO: put this requirement into requirements.txt
RUN pip install --no-cache-dir pytest
RUN python -m spacy download en
# see: https://github.com/explosion/spaCy/issues/1110 (on debian)
RUN apt-get install --no-install-recommends -y libgomp1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Clean up
RUN apt-get remove -y build-essential && apt-get remove -y git && apt-get -y autoremove

ADD etl etl
ADD etl/utils etl/utils
ADD resources resources
COPY test test

ENTRYPOINT '/skills-labeller/etl/run.sh'
