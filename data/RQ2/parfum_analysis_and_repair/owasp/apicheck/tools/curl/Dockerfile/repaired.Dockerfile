FROM python:3.8.3 as build

WORKDIR /app
COPY . /app

RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"
RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir .

FROM python:3.8.3-alpine

RUN apk update && apk --no-cache add curl bash jq

COPY --from=build /venv /venv
ENV PATH="/venv/bin:$PATH"

WORKDIR /app
COPY . /app
RUN chmod +x gcurl

ENTRYPOINT ["/app/gcurl"]
