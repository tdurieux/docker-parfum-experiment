FROM alpine

RUN apk update
RUN apk add --no-cache wget curl nmap libcap

RUN echo "#!/sh\n" > test_memory.sh
RUN echo "cat /proc/meminfo; mpstat; pmap -x 1" >> test_memory.sh
RUN chmod 755 test_memory.sh

CMD ["sh", "test_memory.sh"]
