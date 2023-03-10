FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt https://github.com/explosion/spacy-models/releases/download/xx_sent_ud_sm-3.0.0/xx_sent_ud_sm-3.0.0.tar.gz#egg=xx_sent_ud_sm

# for testing the image
RUN pip install --no-cache-dir pytest && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]