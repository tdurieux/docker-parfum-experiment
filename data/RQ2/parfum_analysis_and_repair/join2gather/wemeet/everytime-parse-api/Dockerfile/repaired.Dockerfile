FROM python:3.8

WORKDIR /backend
COPY . .

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y libglib2.0-0 libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN python3.8 -m venv venv
RUN /bin/bash -c "source venv/bin/activate"

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8009

CMD [ "python3", "src/main.py" ]