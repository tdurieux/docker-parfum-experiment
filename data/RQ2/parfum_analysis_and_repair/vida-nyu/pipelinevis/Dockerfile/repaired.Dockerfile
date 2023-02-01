FROM ubuntu:latest

LABEL maintainer="{jorgehpo, s.castelo, rlopez}@nyu.edu"

RUN apt-get update && apt-get install --no-install-recommends -y \
  python3 \
  python3-pip \
  unzip \
  curl \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash

RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /install_files

ADD . ./

WORKDIR /install_files/PipelineProfiler

RUN npm install && npm cache clean --force;

RUN npm run build

WORKDIR /install_files

RUN pip3 install --no-cache-dir .

EXPOSE 8888

RUN echo "#!/bin/bash" >> run.sh \
  & echo "source ~/.bashrc & jupyter notebook --ip=0.0.0.0 --no-browser --allow-root" >> run.sh \
  & chmod +x run.sh

CMD ["./run.sh"]
