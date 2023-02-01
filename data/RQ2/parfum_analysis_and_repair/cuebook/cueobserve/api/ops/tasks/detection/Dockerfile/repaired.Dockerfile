FROM python:3.7.7-buster

RUN apt-get update

# install psycopg2 dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install libpq-dev gcc musl-dev libffi-dev libssl-dev libxft-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3-dev && rm -rf /var/lib/apt/lists/*;

#RUN apt-get g++
RUN apt-get update \
    && apt-get -y --no-install-recommends install gfortran libopenblas-dev liblapack-dev \
	&& pip install --no-cache-dir --upgrade pip \
	&& pip install --no-cache-dir numpy==1.20.2 \
	&& pip install --no-cache-dir scipy==1.6.2 \
	&& pip install --no-cache-dir pandas==1.1.0 \
  && pip install --no-cache-dir pystan==2.19.1.1 \
  && pip install --no-cache-dir convertdate \
	&& pip install --no-cache-dir prophet && rm -rf /var/lib/apt/lists/*;

#AWS Instructions
RUN apt-get install --no-install-recommends -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;


RUN mkdir -p /lambda_anomaly_detection

COPY . /lambda_anomaly_detection

RUN pip install --no-cache-dir \
        --target /lambda_anomaly_detection \
        awslambdaric

WORKDIR /lambda_anomaly_detection


ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

CMD [ "cloudwrapper.aws_lambda_handler" ]