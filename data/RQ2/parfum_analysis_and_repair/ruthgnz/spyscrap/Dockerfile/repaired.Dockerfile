FROM ubuntu:18.04
RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    pkg-config \
    python3-dev \
    python3-numpy \
    software-properties-common \
    zip \
    unzip \
    && apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python3 setup.py install --yes USE_AVX_INSTRUCTIONS

RUN mkdir spyscrap
WORKDIR spyscrap

# Install Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION=$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -f -sS -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

COPY ./src/requirements.txt .
RUN pip3 install --no-cache-dir -r ./requirements.txt
RUN python -m spacy download es_core_news_sm
COPY ./src/ .
RUN cp /usr/local/bin/chromedriver .
ENV PYTHONIOENCODING=utf-8
ENTRYPOINT ["python3","main.py"]
