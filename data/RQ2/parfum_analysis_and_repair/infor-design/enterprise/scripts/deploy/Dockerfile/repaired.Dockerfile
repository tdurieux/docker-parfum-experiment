FROM node:14.19

WORKDIR /usr/src

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        software-properties-common \
        build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        git && rm -rf /var/lib/apt/lists/*;

RUN npm install release-it -g && npm cache clean --force;

RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm ./awscliv2.zip && rm -fr ./aws

RUN mkdir -p /root/.ssh && touch /root/.ssh/config
RUN echo "[url \"git@github.com:\"]\n\tinsteadOf = https://github.com/" >> /root/.gitconfig
RUN echo "StrictHostKeyChecking no " > /root/.ssh/config
RUN git config --global url."https://{token}:@github.com/".insteadOf "https://github.com/"

COPY ./run.sh run.sh
RUN chmod +x run.sh

ENTRYPOINT ["/bin/bash", "run.sh"]
