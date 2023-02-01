FROM tiangolo/uvicorn-gunicorn:python3.8-slim

# https://stackoverflow.com/questions/55313610/importerror-libgl-so-1-cannot-open-shared-object-file-no-such-file-or-directo
RUN apt-get update
RUN apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y procps gdb && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install --upgrade pip

RUN mkdir /fastapi

COPY requirements.txt /fastapi

WORKDIR /fastapi

RUN pip install --no-cache-dir -r requirements.txt

COPY . /fastapi

EXPOSE 8088

COPY ./start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
