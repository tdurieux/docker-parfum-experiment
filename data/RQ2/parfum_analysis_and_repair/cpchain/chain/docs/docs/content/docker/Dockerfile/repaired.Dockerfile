FROM debian:stable

RUN echo "deb http://mirrors.ustc.edu.cn/debian/ stable main non-free contrib" > /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y python3-sphinx python3-flask python3-sphinx-rtd-theme && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

WORKDIR /docs

# ENTRYPOINT make