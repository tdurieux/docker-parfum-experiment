Create Java File Hello.java with class Hello


Dockerfile

FROM java:8  
COPY . /var/www/java  
WORKDIR /var/www/java  
RUN javac Hello.java  
CMD ["java", "Hello"]  