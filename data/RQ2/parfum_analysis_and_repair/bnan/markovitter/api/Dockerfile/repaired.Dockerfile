FROM python:3.6
ENV PYTHONUNBUFFERED 0
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
ADD requirements.txt /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt
RUN curl -f -o /usr/local/bin/wait-for-it -sSL https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x /usr/local/bin/wait-for-it
ADD . /usr/src/app/

