FROM python:3.6-slim-stretch
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    apt-utils \
    build-essential \
    git \
    wget \
    curl \
    unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . /app
ARG TUTORIAL
RUN wget -O snorkel-requirements.txt \
    https://raw.githubusercontent.com/snorkel-team/snorkel/master/requirements.txt \
    && pip3 install --no-cache-dir -r $TUTORIAL/requirements.txt \
    && pip3 install --no-cache-dir -r requirements.txt \
    && pip3 install --no-cache-dir -r snorkel-requirements.txt \
    && python3 -m spacy download en_core_web_sm

WORKDIR $TUTORIAL
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
