FROM openjdk:8
EXPOSE 8080
ADD ./build/libs/gumball-v2-2.0.war /srv/gumball.war
CMD java -jar /srv/gumball.war
