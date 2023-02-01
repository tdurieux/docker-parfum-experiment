FROM python:3.8.3-alpine3.12

COPY requirements.txt /tmp

# Install build dependencies
RUN apk add --no-cache gcc musl-dev linux-headers make && \
    pip install --requirement /tmp/requirements.txt && \
    apk del gcc musl-dev linux-headers make

RUN addgroup -S app && adduser -S -G app app
RUN apk add --no-cache zsh redis

RUN ln -sf /home/app/.local/bin/rcc /usr/bin/rcc

COPY --chown=app:app . /home/app
COPY --chown=app:app .zshrc /home/app/.zshrc
USER app

WORKDIR /home/app
RUN pip install --user -e .

EXPOSE 8765
CMD ["rcc", "--help"]
