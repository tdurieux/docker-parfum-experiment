FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8
# copy the repository form the previous image

RUN mkdir -p /root/app

COPY easyauth /root/app/easyauth
COPY docker /root/app/docker
COPY requirements.txt /root/app/

RUN ls /root/app/easyauth

WORKDIR /root/app/
RUN mv docker/server/server.py .
RUN mv docker/test-docker/entrypoint.sh .

RUN echo "adding requirements"
RUN pip3 install --no-cache-dir -U -r requirements.txt
RUN pip3 install --no-cache-dir -U pydbantic[mysql]
RUN pip3 install --no-cache-dir -U aiomysql

EXPOSE 8220

# TODO - add startup.sh to each REPO - will run from cloned folder
CMD ["./entrypoint.sh"]