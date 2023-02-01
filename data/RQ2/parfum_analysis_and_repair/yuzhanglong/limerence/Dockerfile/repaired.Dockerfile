FROM python:3.8
COPY . .
WORKDIR .
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip install --no-cache-dir gunicorn -i https://pypi.tuna.tsinghua.edu.cn/simple
CMD ["gunicorn", "-c", "gunicorn.py", "manage:app"]
EXPOSE 5001