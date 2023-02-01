FROM sertansenturk/tomato:latest

RUN pip3 install --no-cache-dir --user pytest

COPY tests /code/tests
COPY sample-data /code/sample-data

USER root
RUN chown -R tomato_user:tomato_user /code
USER tomato_user

WORKDIR /code
