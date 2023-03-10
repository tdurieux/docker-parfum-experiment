FROM python:3.8

RUN mkdir /code
COPY . /code
RUN pip install --no-cache-dir -r /code/requirements.txt
# -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install --no-cache-dir -U --force-reinstall --no-binary :all: gevent
WORKDIR /code

CMD ["python", "/code/app.py"]