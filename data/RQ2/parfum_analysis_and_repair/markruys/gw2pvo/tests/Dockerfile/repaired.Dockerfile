FROM python:3.6

ADD dist dist
ADD gw2pvo.cfg gw2pvo.cfg

RUN pip install --no-cache-dir dist/gw2pvo-*-py3-none-any.whl

RUN gw2pvo --config gw2pvo.cfg

