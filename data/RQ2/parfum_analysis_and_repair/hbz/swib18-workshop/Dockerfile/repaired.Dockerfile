FROM ubuntu:latest

WORKDIR /home/loud
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get -y upgrade

# install some general tools
RUN apt-get install --no-install-recommends -y gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;

# install node (8.x or higher):
RUN curl -f -sL https://deb.nodesource.com/setup_8.x > setup_8.x
RUN chmod 755 ./setup_8.x && ./setup_8.x
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install the hbz jsonld-cli fork:
RUN git clone https://github.com/hbz/jsonld-cli.git
RUN cd jsonld-cli && npm install -g && npm cache clean --force;

# install elasticsearch
EXPOSE 9200 5601 3000
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;

# Note: elasticsearch requires java runtime environment
RUN apt-get install --no-install-recommends -y openjdk-11-jre-headless && rm -rf /var/lib/apt/lists/*;

# now install elasticsearch
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list
RUN apt-get -y update && apt-get install --no-install-recommends -y elasticsearch && rm -rf /var/lib/apt/lists/*;

# set default host to 0.0.0.0
RUN sed -i "s|#network.host: 192.168.0.1|network.host: 0.0.0.0|g" /etc/elasticsearch/elasticsearch.yml

# install and configure kibana
RUN apt-get install --no-install-recommends -y kibana && rm -rf /var/lib/apt/lists/*;

# set default host to 0.0.0.0
RUN sed -i "s|#server.host: \"localhost\"|server.host: 0.0.0.0|g" /etc/kibana/kibana.yml

# install workshop data
RUN git clone https://github.com/hbz/swib18-workshop.git

WORKDIR /home/loud/swib18-workshop
RUN npm install && npm cache clean --force;

# set default host to 0.0.0.0
RUN sed -i "s|const hostname = '127.0.0.1'|const hostname = '0.0.0.0'|g" /home/loud/swib18-workshop/js/app.js

# start all services
CMD service elasticsearch start && service kibana start && npm start
