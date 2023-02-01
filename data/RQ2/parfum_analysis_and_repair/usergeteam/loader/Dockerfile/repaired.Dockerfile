# set base image (host OS)
FROM python:3.9

# set the working directory in the container
WORKDIR /app/

RUN apt -qq update
RUN apt -qq install -y --no-install-recommends \
    curl \
    git \
    gnupg2 \
    unzip \
    wget \
    ffmpeg && rm -rf /var/lib/apt/lists/*;

# install chrome
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    # -f ==> is required to --fix-missing-dependancies
    dpkg -i ./google-chrome-stable_current_amd64.deb; apt -fqqy install && \
    # clean up the container "layer", after we are done
    rm ./google-chrome-stable_current_amd64.deb

# install chromedriver
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ && \
    # clean up the container "layer", after we are done
    rm /tmp/chromedriver.zip

ENV GOOGLE_CHROME_DRIVER /usr/bin/chromedriver
ENV GOOGLE_CHROME_BIN /usr/bin/google-chrome-stable

# install node-js
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm i -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# install rar
RUN mkdir -p /tmp/ && \
    cd /tmp/ && \
    wget -O /tmp/rarlinux.tar.gz https://www.rarlab.com/rar/rarlinux-x64-6.0.0.tar.gz && \
    tar -xzvf rarlinux.tar.gz && \
    cd rar && \
    cp -v rar unrar /usr/bin/ && \
    # clean up
    rm -rf /tmp/rar* && rm rarlinux.tar.gz

# copy the content of the local src directory to the working directory
COPY . .

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# command to run on container start
CMD [ "bash", "./run" ]
