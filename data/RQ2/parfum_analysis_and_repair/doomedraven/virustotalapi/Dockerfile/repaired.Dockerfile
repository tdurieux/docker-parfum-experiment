FROM python:2-slim
LABEL maintainer "Peter Benjamin <petermbenjamin@gmail.com>"
WORKDIR /src/vtapi
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT [ "python", "vt/vt.py" ]
