FROM python:3.7
WORKDIR /app
ADD . /app
RUN pip install --no-cache-dir -r requirements.txt
LABEL maintainer="t@a4.io"
LABEL pub.microblog.oneshot=true
CMD ["python", "wizard.py"]
