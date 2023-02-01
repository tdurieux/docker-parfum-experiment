FROM python:latest

WORKDIR /jcoin
ADD . /jcoin

# RUN apk add --no-cache alpine-sdk git
RUN pip3 install --no-cache-dir -Ur requirements.txt

ENV NAME jcoin

CMD ["python3", "josecoin.py"]
