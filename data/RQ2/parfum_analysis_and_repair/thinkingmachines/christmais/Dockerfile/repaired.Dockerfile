FROM python:3.6-stretch

# Install magenta dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libasound2-dev libjack-dev && rm -rf /var/lib/apt/lists/*;

# Install chromedriver dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y chromium && rm -rf /var/lib/apt/lists/*;

# Set /usr/src/app as working dir
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install dev dependencies
COPY requirements-dev.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements-dev.txt

# Download checkpoint directory
RUN mkdir ckpt && \
    wget https://storage.googleapis.com/download.magenta.tensorflow.org/models/arbitrary_style_transfer.tar.gz && \
    tar --strip-components 1 -xvzf arbitrary_style_transfer.tar.gz -C ckpt/ && rm arbitrary_style_transfer.tar.gz

# Run tests
CMD python -m pytest -v && \
    python -m flake8 christmais
