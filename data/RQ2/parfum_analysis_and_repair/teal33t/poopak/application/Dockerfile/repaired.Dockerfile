FROM python:3.6.1

COPY . /application
ENV HOME=/application
WORKDIR /application

RUN pip install --no-cache-dir -r requirements.txt

ADD docker_wait /wait
RUN chmod +x /wait
CMD /wait
