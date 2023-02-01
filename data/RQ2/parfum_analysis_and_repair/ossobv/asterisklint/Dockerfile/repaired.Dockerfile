FROM python:3-alpine AS builder
COPY . /app
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app
RUN pip install --no-cache-dir .


FROM python:3-alpine
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /etc/asterisk
CMD ["asterisklint", "ls"]
