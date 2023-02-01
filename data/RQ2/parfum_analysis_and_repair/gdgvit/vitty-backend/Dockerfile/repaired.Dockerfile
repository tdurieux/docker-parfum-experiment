FROM ubuntu:latest

WORKDIR /app

RUN apt-get update
RUN apt install --no-install-recommends -y python3-pip python3 && rm -rf /var/lib/apt/lists/*;

ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


COPY . /app

RUN pip3 install --no-cache-dir fastapi uvicorn starlette
RUN apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir python-multipart

CMD ["uvicorn","main:app","--reload","--port","8000","--host","0.0.0.0"]
