FROM python:3.6

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY ./ /usr/src/app/
RUN pip install --no-cache-dir --upgrade -r /usr/src/app/requirements.txt
EXPOSE 5000

CMD ["python", "who_the_hill/web/pub.py"]