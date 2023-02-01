FROM python:3.9.9-slim
RUN apt-get update && \
    apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /empty_dir
EXPOSE 80
CMD python -m http.server 80
