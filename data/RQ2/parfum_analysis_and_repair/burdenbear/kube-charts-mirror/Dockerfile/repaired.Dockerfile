FROM python:3

WORKDIR /root/

COPY ./requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY ./*.* ./

VOLUME ["/mnt/charts/"]

CMD ["/root/update.sh"]
