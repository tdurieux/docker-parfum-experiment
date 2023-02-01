FROM python:3.7.4

WORKDIR /app

ADD requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
ADD . .

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENTRYPOINT [ "python3", "server.py" ]
CMD [ "--help" ]
