FROM alexellis2/raspistill:latest
ENTRYPOINT []
RUN apt-get update -qy && apt-get install --no-install-recommends -qy python && rm -rf /var/lib/apt/lists/*;
COPY . .

VOLUME /var/image/

CMD ["python", "take.py", "60"]
