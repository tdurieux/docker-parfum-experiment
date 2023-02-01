FROM python:3-alpine as builder
WORKDIR /src
COPY . .
RUN pip install --no-cache-dir .[docs]
RUN mkdir /out
RUN sphinx-build -W docs /out
FROM nginx
COPY --from=builder /out/ /usr/share/nginx/html
