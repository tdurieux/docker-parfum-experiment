FROM ubuntu:19.10

# Install Chrome debian sources
RUN apt-get update \
    && apt-get install --no-install-recommends -y gnupg2 \
    && apt-get install --no-install-recommends -y wget \
    && apt-get clean \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && rm -rf /var/lib/apt/lists/*;


# Install pptitude and python dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y xvfb python-pip unzip openjdk-8-jre google-chrome-stable \
    && apt-get clean \
    && pip install --no-cache-dir selenium browsermob-proxy xvfbwrapper --upgrade && rm -rf /var/lib/apt/lists/*;

# Install direct binary dependencies
RUN wget https://github.com/lightbody/browsermob-proxy/releases/download/browsermob-proxy-2.1.2/browsermob-proxy-2.1.2-bin.zip \
    && unzip browsermob-proxy-2.1.2-bin.zip \
    && wget https://selenium-release.storage.googleapis.com/2.41/selenium-server-standalone-2.41.0.jar \
    && wget https://chromedriver.storage.googleapis.com/2.35/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && chmod +x chromedriver

# Start selenium server
RUN mkdir -p /log \
    && /usr/bin/java -jar selenium-server-standalone-2.41.0.jar >> /log/selenium.$(date +"%Y%d%m").log 2>&1&


RUN apt-get update && apt-get -y dist-upgrade

RUN apt-get -y --no-install-recommends install python3 python-dev python3-dev \
     build-essential libssl-dev libffi-dev \
     libxml2-dev libxslt1-dev zlib1g-dev \
     python-pip ipython3 python3-pip && rm -rf /var/lib/apt/lists/*;

COPY . /rafMetrics
WORKDIR /rafMetrics

# Install requirements for Python modules
RUN pip3 install --no-cache-dir -r requirements.txt

RUN chmod u+x ./WebMonitoring/WebsiteMonitorHelpers/entrypoint.sh

# Allows for log messages to be immediately dumped
ENV PYTHONUNBUFFERED=1

# Execute Website management
ENV PYTHONPATH="/rafMetrics"
ENTRYPOINT ["python3", "./WebMonitoring/WebsiteManager.py"]

# For development purpose only
# ENTRYPOINT ["tail", "-f", "/dev/null"]

