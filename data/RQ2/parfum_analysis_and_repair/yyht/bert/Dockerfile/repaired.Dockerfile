FROM tensorflow/tensorflow:1.8.0-py3

RUN apt update && apt install --no-install-recommends -y vim supervisor git && rm -rf /var/lib/apt/lists/*;
Workdir /app
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
RUN sh init.sh
RUN  cd  jieba && python3 setup.py install
RUN mkdir -p /var/log/supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
