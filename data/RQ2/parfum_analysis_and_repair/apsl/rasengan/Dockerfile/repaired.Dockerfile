FROM python:3.5

RUN pip install --no-cache-dir rasengan==0.2.6
RUN mkdir /rasengan
WORKDIR /rasengan
CMD ["rasengan"]