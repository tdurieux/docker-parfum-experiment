# Use Alpine Linux for minimal image size
FROM openjdk:8-alpine
RUN apk add --no-cache wget ttf-dejavu

# Run as a normal user, not root
RUN adduser -D -u 1000 irpf
USER irpf

WORKDIR /home/irpf

# Download and expand the app into ~/app
ARG url=http://downloadirpf.receita.fazenda.gov.br/irpf/2019/irpf/arquivos/IRPF2019-1.5.zip
RUN wget "$url" -O app.zip --no-check-certificate && \
    unzip app.zip && \
    rm app.zip

# Run the app
CMD java -jar IRPF2019/irpf.jar
