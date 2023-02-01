FROM java:8
COPY *.jar /apps/admintory.jar
WORKDIR /apps
CMD ["--server.port=8080"]
EXPOSE 8080
ENTRYPOINT ["java","-jar","/apps/admintory.jar"]