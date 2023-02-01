FROM borda/docker_python-opencv-ffmpeg:gpu-py3.7-cv4.3.0

WORKDIR /usr/src/app

RUN pip install --no-cache-dir pipenv

COPY Pipfile* ./
RUN pipenv lock --requirements > requirements.txt
RUN pip install --no-cache-dir -r requirements.txt