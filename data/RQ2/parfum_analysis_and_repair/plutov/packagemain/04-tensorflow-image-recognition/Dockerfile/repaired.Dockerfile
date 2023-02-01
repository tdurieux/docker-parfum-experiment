FROM ctava/tfcgo

RUN mkdir -p /model && \
  curl -f -o /model/inception5h.zip -s "https://download.tensorflow.org/models/inception5h.zip" && \
  unzip /model/inception5h.zip -d /model

WORKDIR /go/src/imgrecognition
COPY . .
RUN go build
ENTRYPOINT [ "/go/src/imgrecognition/imgrecognition" ]