FROM python:3.7

RUN echo 'deb http://httpredir.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update && apt-get install --no-install-recommends -y python-gevent python-gevent-websocket emacs && rm -rf /var/lib/apt/lists/*;

WORKDIR /data/hamid/workspace
RUN git clone https://github.com/AskNowQA/SQG.git
WORKDIR /data/hamid/workspace/SQG
RUN git checkout dev && git pull origin dev
COPY ./data /data/hamid/workspace/SQG/data
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir https://download.pytorch.org/whl/cpu/torch-1.0.1-cp37-cp37m-linux_x86_64.whl
RUN pip install --no-cache-dir torchvision
RUN pip install --no-cache-dir -r requirements.txt
ENV PYTHONPATH=.:$PYTHONPATH
CMD ["python", "sqg_webserver.py", "--port", "5005" ]