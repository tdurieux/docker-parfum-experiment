FROM python:bullseye

COPY ./ /app


EXPOSE 4200 5000

WORKDIR /app
USER root

RUN apt-get update && apt-get install --no-install-recommends -y sudo nodejs npm lsof default-jdk && rm -rf /var/lib/apt/lists/*;

RUN python adhrit/installer.py

CMD ["python", "run.py"]