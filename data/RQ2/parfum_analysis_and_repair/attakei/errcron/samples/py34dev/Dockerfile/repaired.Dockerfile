FROM python:3.4

WORKDIR /usr/src/app

RUN pip install --no-cache-dir errbot crontab
RUN mkdir /var/lib/err
RUN pip install --no-cache-dir errcron -i https://testpypi.python.org/pypi
ADD config.py ./
ADD demo.plug ./
ADD demo.py ./

CMD ["errbot", "-T"]
