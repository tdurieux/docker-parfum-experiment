FROM alpine
ARG SECRET
RUN echo $SECRET

FROM alpine
RUN echo "$SECRET" > test_file