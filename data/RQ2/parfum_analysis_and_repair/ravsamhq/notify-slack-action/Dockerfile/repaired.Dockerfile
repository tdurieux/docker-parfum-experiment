FROM public.ecr.aws/docker/library/python:3-slim AS builder
ADD . /app
WORKDIR /app

# we are installing a dependency here directly into our app source dir
RUN pip install --no-cache-dir -r requirements.txt --target=/app

# a distroless container image with Python and some basics like SSL certificates
# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/python3-debian10
COPY --from=builder /app /app
WORKDIR /app
ENV PYTHONPATH /app
CMD ["/app/main.py"]
