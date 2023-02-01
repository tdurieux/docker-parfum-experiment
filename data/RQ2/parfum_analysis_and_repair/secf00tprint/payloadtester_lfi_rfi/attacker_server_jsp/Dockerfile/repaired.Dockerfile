FROM tomcat:9.0.21

LABEL maintainer="secf00tprint@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y netcat vim python3 && rm -rf /var/lib/apt/lists/*;

COPY start.sh .
CMD ["./start.sh"]
