FROM python:latest
WORKDIR /var/www/html/

RUN pip install --no-cache-dir flask -i https://pypi.mirrors.ustc.edu.cn/simple \
    && pip install --no-cache-dir gunicorn -i https://pypi.mirrors.ustc.edu.cn/simple
CMD ["gunicorn", "app:app", "--bind=0.0.0.0:8081", "--workers=2"]

EXPOSE 8081
