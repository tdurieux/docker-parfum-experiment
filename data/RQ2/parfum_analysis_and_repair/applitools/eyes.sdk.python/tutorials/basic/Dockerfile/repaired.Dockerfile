FROM tutorial_python:latest
ARG repo=tutorial-selenium-python
ARG package
ENV REPOSITORY_NAME=$repo
RUN cd home/project \
    && git clone https://github.com/applitools/${REPOSITORY_NAME}.git \
    && cd ${REPOSITORY_NAME}

COPY ./basic/start.sh /
COPY package/ /

RUN cd home/project/${REPOSITORY_NAME} \
    && pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir ./$package

CMD ./start.sh ${REPOSITORY_NAME}
