FROM ubuntu:20.04
RUN apt update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY otpgateway .
COPY config.sample.toml config.toml
COPY static/smtp.tpl ./static/smtp.tpl
CMD ["./otpgateway", "--config", "./config.toml"]
