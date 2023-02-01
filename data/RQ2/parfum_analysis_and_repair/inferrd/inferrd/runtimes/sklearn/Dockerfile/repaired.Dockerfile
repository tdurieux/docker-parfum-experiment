FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends awscli unzip curl wget gnupg2 python3-pip python3.8 -y && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade dill pandas sklearn joblib flask --no-cache-dir

COPY . .

EXPOSE 9001

CMD ["sh", "./run-model.sh"]