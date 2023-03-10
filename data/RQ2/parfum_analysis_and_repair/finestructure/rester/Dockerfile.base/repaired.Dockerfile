FROM swift:5.2.4

WORKDIR /package

COPY . ./

RUN swift package resolve
RUN swift package clean