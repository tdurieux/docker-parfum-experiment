FROM ubuntu
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip curl git vim && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
RUN source /root/.bashrc
RUN nvm install v10.15.0
RUN nvm alias default v10.15.0
RUN mkdir ~/code && cd ~/code && git clone https://github.com/loadchange/amemv-crawler.git
RUN cd amemv-crawler && pip3 install --no-cache-dir -r requirements.txt
