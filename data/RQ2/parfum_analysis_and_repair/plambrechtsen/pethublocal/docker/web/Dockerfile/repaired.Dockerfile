FROM python:3.8-alpine

WORKDIR /code

RUN apk add --no-cache gcc musl-dev linux-headers

COPY packages.txt packages.txt

RUN pip install --no-cache-dir -r packages.txt

EXPOSE 443

COPY . .

ENTRYPOINT ["python", "app.py"]
