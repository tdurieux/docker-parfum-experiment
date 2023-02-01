FROM selenium/standalone-chrome-debug:3.141.59-xenon
USER root
RUN apt-get update && sudo apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
USER seluser
RUN pip3 install --no-cache-dir pytest selenium ptvsd python-dateutil django
