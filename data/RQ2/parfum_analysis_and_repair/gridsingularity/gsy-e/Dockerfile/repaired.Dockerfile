FROM python:3.8

ADD . /app

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements/pandapower.txt
RUN pip install --no-cache-dir -e .

ENTRYPOINT ["gsy-e"]
