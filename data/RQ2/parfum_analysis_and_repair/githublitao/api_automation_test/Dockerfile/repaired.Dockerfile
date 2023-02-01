FROM centos/python-36-centos7:latest
COPY ./requirements.txt /api_automation_test/
USER root
WORKDIR /api_automation_test
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir --upgrade pip\
    && pip install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir -r /api_automation_test/requirements.txt --default-timeout=200 --ignore-installed\
    && yum -y install crontabs \
    && pip install --no-cache-dir https://github.com/darklow/django-suit/tarball/v2 && rm -rf /var/cache/yum
CMD [ "sh", "-c", "/sbin/service crond start"]
