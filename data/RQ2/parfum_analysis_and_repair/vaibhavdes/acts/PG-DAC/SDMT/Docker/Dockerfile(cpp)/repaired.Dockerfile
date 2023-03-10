1. Create Docker File

vi Dockerfile


FROM ubuntu
RUN apt-get update -y && apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /prog1
COPY file1.c /prog1/
WORKDIR /prog1/
RUN gcc -o file1 file1.c
CMD ["./file1"]


2. Build Image

docker build -t image-exam .

3. Run Image

docker run image-exam
