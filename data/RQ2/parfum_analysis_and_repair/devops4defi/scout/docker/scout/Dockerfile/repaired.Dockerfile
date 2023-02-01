FROM python:3.9.6
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN chmod 755 ./start*.sh
ENTRYPOINT ./startEth.sh
EXPOSE 8801
