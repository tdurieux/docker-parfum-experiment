FROM fnproject/fn-java-fdk:
WORKDIR /function
COPY classes /function/app/
COPY dependency/* /function/app/
CMD ["io.micronaut.oraclecloud.function.http.HttpFunction::handleRequest"]