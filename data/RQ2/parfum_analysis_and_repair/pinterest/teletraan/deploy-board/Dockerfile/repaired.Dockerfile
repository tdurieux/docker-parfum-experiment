FROM python:2.7
ENV PYTHONUNBUFFERED 1
ENV PROJECT_DIR=/opt/deploy-board
RUN mkdir $PROJECT_DIR
WORKDIR $PROJECT_DIR
ADD . $PROJECT_DIR

#Install PIP packages
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8888

