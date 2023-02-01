FROM python:3.6

COPY . server
WORKDIR server/

#ADD requirements/base.txt .

RUN pip3 install --no-cache-dir -r requirements/base.txt
RUN find . -name '*.pyc' -delete


RUN pip3 install --no-cache-dir -e .
RUN python setup.py install


EXPOSE 8000

ENTRYPOINT python runner.py --env prod
