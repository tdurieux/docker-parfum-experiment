FROM python:3.7.2

COPY config/requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip

# install required packages
RUN pip install --no-cache-dir -r requirements.txt

# set timezone
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone


COPY . .

CMD ["python", "sentinel.py", "app.py", "--config", "config/boot/boot.sae.properties"]

