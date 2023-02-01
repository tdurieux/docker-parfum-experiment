FROM  bootstrapper:5000/liuqs_public/tensorflow:1.1.0-gpu

COPY requirements.txt /tmp/
COPY sources.list /etc/apt
RUN apt-get update && apt-get install --no-install-recommends -y vim git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -r /tmp/requirements.txt

