# Pull base image.
FROM public.ecr.aws/m5u3u5p2/handoff-base:0.1

MAINTAINER Daigo Tanaka <daigo.tanaka@gmail.com>

COPY . /app/
RUN chmod 777 -R /app

WORKDIR /app

RUN ./script/install_handoff

# It is recommended to make virtual envs for each process
RUN handoff workspace install -p project -w workspace

# Make sure to delete these directories in case sensitive information was accidentally copied.