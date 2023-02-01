FROM registry.cn-shenzhen.aliyuncs.com/jzdev/tinibase:1.0.0

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /ExchangeMargin

WORKDIR /ExchangeMargin

ADD . /ExchangeMargin

WORKDIR /ExchangeMargin

RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.douban.com/simple

ENTRYPOINT ["python", "sh/sh_diff.py"]
