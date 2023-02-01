FROM python:2.7-alpine

COPY . /tweeviz-ui
RUN pip install --no-cache-dir /tweeviz-ui

WORKDIR /tweeviz-ui

ENTRYPOINT ["./tweeviz_ui.py"]
