FROM pure/python:3.7-cuda10.0-base

WORKDIR /app

# Install Java 11
RUN apt-get update && apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

# Download CoreNLP
RUN wget https://nlp.stanford.edu/software/stanford-corenlp-full-2018-01-31.zip
RUN unzip stanford-corenlp-full-2018-01-31.zip
RUN rm stanford-corenlp-full-2018-01-31.zip

# Clone the code and install dependencies
RUN git clone https://github.com/tagoyal/dae-factuality && \
    cd dae-factuality && \
    git checkout d5a472b0f18c18d7125dc1551bde59538adac765 && \
    pip install --no-cache-dir -r requirements.txt

# Download the pretrained models
RUN pip install --no-cache-dir gdown
COPY scripts/download-models.sh download-models.sh
RUN sh download-models.sh

# Copy the scoring code and script to run
COPY src/score.py dae-factuality/score.py
COPY scripts/run.sh run.sh