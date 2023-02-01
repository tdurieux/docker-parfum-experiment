FROM python:3.7.10-slim-stretch

# update apk repo
RUN echo "http://dl-4.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories

# install chromedriver
RUN apk update
RUN apk add --no-cache chromium chromium-chromedriver

RUN apk add --no-cache linux-headers gmp-dev

RUN apk add --no-cache gcc g++ libffi libffi-dev libstdc++ python3-dev musl-dev

RUN apk add --no-cache openssl-dev

COPY ./requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt

ADD ./ /
ADD ./_docker_app_script.sh /

WORKDIR /

RUN chmod +x /_docker_app_script.sh

CMD ["/_docker_app_script.sh"]

