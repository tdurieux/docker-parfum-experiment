FROM python:3.6.6

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.6/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=c3b78d342e5413ad39092fd3cfc083a85f5e2b75 \
    TEST_DB_URL=postgresql+psycopg2://circleci:srtpass@192.168.56.101/srt

RUN apt-get update && apt-get install --no-install-recommends -y \
    antiword \
    build-essential \
    ca-certificates \
    curl \
    flac \
    ffmpeg \
    gcc \
    git \
    gzip \
    lame \
    libav-tools \
    libjpeg-dev \
    libmad0 \
    libpq-dev \
    libpulse-dev \
    libsox-fmt-mp3 \
    libxml2-dev \
    libxslt1-dev \
    make \
    musl-dev \
    netcat \
    poppler-utils \
    postgresql-common \
    pstotext \
    python-dev \
    python-pip \
    sox \
    ssh \
    swig \
    tar \
    tesseract-ocr \
    unrtf \
    zlib1g-dev \
    unzip \
    curl \
    vim \
    inotify-tools \
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
    #clean up the apt cache
    && rm -rf /var/lib/apt/lists/*

ADD requirements-test.txt .
RUN pip install --no-cache-dir -r requirements-test.txt

WORKDIR /opt

CMD ["/bin/sh"]

COPY geckodriver .
RUN cp geckodriver /usr/local/bin

WORKDIR /opt
ADD requirements-test.txt .
RUN pip install --no-cache-dir -r requirements-test.txt


# Adding trusting keys to apt for repositories
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# Adding Google Chrome to the repositories
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
# Updating apt to see and install Google Chrome
RUN apt-get -y update
# Magic happens
RUN apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;
# Download the Chrome Driver
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
# Unzip the Chrome Driver into /usr/local/bin directory
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

ENV DISPLAY=192.168.56.1:0.0
