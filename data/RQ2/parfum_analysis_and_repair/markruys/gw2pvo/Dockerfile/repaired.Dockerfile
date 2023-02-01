FROM python:3.7

RUN pip install --no-cache-dir gw2pvo

ENTRYPOINT exec gw2pvo --config /gw2pvo.cfg

