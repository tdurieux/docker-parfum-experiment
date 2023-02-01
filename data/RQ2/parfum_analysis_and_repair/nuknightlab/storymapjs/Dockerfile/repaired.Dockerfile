FROM python:3.8
ENV PYTHONUNBUFFERED=1
COPY ./requirements-dev.txt /usr/src/apps/StoryMapJS/
COPY ./.localstack/KnightLabRootCA.crt /usr/src/apps/StoryMapJS/
COPY ./.localstack/KnightLabRootCA.key /usr/src/apps/StoryMapJS/
COPY ./.localstack/KnightLabRootCA.pem /usr/src/apps/StoryMapJS/
WORKDIR /usr/src/apps/StoryMapJS
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements-dev.txt
