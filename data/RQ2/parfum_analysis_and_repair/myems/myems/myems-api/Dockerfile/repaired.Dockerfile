FROM python:slim

RUN apt update && apt install --no-install-recommends -y nano telnet && rm -rf /var/lib/apt/lists/*;

# todo: share upload folder with admin container on Docker
RUN mkdir -p /var/www/myems-admin/upload

WORKDIR /code
COPY . /code
RUN pip install --no-cache-dir -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
EXPOSE 8000
CMD ["gunicorn", "app:api", "-b", "0.0.0.0:8000", "--timeout", "600", "--workers=4"]