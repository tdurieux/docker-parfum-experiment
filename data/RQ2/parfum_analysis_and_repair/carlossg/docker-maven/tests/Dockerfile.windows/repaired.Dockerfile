FROM TO_BE_REPLACED

COPY settings.xml C:/ProgramData/Maven/Reference/
COPY pom.xml C:/Temp/pom.xml
COPY src/ C:/Temp/src

RUN mvn -B -f C:/Temp/pom.xml -s C:/ProgramData/Maven/Reference/settings-docker.xml dependency:resolve