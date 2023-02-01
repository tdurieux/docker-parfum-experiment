FROM python:3.6

VOLUME /usr/src/app
VOLUME /var/lib/sorna/scratches
WORKDIR /usr/src/app

RUN pip install --no-cache-dir -U pip wheel setuptools

COPY requirements.txt /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app
RUN pip install --no-cache-dir -e .

CMD python -m sorna.agent.server
