FROM python:3.7-alpine
RUN echo "while true; do echo 'Hello World of untrusted images :('; sleep 3; done" >> hello.sh
CMD ["sh", "hello.sh"]