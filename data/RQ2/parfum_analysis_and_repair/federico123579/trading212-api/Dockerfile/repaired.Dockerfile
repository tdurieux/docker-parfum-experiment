FROM ubuntu:17.10
MAINTAINER Federico Lolli
RUN apt-get -qq update
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
################## BEGIN INSTALLATION ######################
RUN apt-get -y --no-install-recommends install xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install firefox && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3.6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-venv && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
##################### INSTALLATION END #####################
##### PIP #####
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py
RUN pip install --no-cache-dir virtualenv
###############
# GECKODRIVER #
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.11.1/geckodriver-v0.11.1-linux64.tar.gz
RUN tar -xvzf geckodriver-v0.11.1-linux64.tar.gz && rm geckodriver-v0.11.1-linux64.tar.gz
RUN rm geckodriver-v0.11.1-linux64.tar.gz
RUN chmod +x geckodriver
RUN cp geckodriver /bin/
RUN rm geckodriver*
###############
# TRADING-API #
WORKDIR /home
RUN git clone https://github.com/federico123579/Trading212-API.git trading-api
WORKDIR /home/trading-api
RUN git checkout factory
RUN python3.6 -m venv env
RUN . env/bin/activate
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir -r dev-requirements.txt
RUN pip install --no-cache-dir .
###############
