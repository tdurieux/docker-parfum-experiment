FROM python:3.10-bullseye  AS build-env

WORKDIR /app
ADD ./ ./

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r ./requirements.txt

FROM gcr.io/distroless/python3-debian10
COPY --from=build-env /app /app
COPY --from=build-env /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

WORKDIR /app
ENV PYTHONPATH=/usr/local/lib/python3.10/site-packages
CMD ["app.py"]