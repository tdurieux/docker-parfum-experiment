FROM python:3.7

ADD setup.py /app/
ADD covid19surveyorml /app/covid19surveyorml/

RUN apt-get update && \
  apt-get install -y \
    git \
    build-essential \
    curl \
    mecab \
    libmecab-dev \
    --no-install-recommends && \
  apt-get clean && \
  pip install --no-cache-dir /app && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["covid19surveyorml"]
CMD ['--help']
