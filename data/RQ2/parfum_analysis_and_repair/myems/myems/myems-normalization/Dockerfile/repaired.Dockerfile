FROM python:slim

RUN apt update && apt install --no-install-recommends -y nano telnet && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
COPY . /code
RUN pip install --no-cache-dir -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
CMD ["python", "main.py"]