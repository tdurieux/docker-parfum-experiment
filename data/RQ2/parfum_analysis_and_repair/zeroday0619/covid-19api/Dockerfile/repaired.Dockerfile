FROM matthewfeickert/docker-python3-ubuntu
LABEL maintainer="zeroday0619 [Euiseo Cha]"
RUN sudo apt-get update -y
RUN sudo apt-get upgrade -y
RUN sudo apt-get install --no-install-recommends build-essential python3.6-dev python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;
RUN python3.6 -m pip install fastapi[all] aiohttp[speedup] bs4[speedup] fastapi_plugins scrapy aioredis ujson lxml
RUN sudo mkdir -p /usr/src/ncov && rm -rf /usr/src/ncov
COPY . /usr/src/ncov
WORKDIR /usr/src/ncov
EXPOSE 80
CMD ["uvicorn", "--host", "0.0.0.0", "--port", "80", "run:app"]