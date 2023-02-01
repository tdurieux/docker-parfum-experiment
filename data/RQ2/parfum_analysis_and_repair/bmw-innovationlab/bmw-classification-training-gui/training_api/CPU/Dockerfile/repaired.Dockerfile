FROM python:3.6

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends --fix-missing -y \
					python-tk \
					nano \
					python3-pip && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir gluoncv
RUN pip install --no-cache-dir mxnet-mkl
RUN pip install --no-cache-dir fastapi[all]

WORKDIR /app/src

COPY ./gluon_files/packages/gluoncv /usr/local/lib/python3.6/site-packages/gluoncv

COPY ./midweight_heavyweight_solution .
RUN python3 webcrawler.py
COPY . ..
CMD ["uvicorn","main:app", "--host", "0.0.0.0","--reload"]
