FROM daqf/aardvark:latest

RUN $AG update && $AG install jq

COPY subset/manual/test_manual .

CMD ./test_manual