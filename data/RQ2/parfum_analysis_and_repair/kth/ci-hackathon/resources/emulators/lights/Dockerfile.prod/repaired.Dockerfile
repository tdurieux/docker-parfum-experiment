FROM python:3

ENV LIGHT_CONTROLLER=simulator
ENV APP_PORT=80
ENV APP_HOST=0.0.0.0
ENV APP_DEBUG=False
export PROTOCOL=https

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY  ./src/light_controller /app
COPY requirements.txt /app

WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]

EXPOSE 80

CMD ["server.py"]