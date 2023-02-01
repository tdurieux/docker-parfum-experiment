FROM python:3.7

COPY sources.list /etc/apt
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y gcc make vim net-tools python3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /proj
COPY . .
ENV LC_ALL=zh_CN.utf8
ENV LANG=zh_CN.utf8
ENV LANGUAGE=zh_CN.utf8
ENV PIPURL "https://mirrors.aliyun.com/pypi/simple/"
RUN pip install --no-cache-dir -i ${PIPURL} -r requirements.txt
RUN chmod +x server.sh
RUN chmod +x docker_start.sh
CMD ["./docker_start.sh", "8000", "dev"]
