FROM idoge/stat_server:latest

WORKDIR /
EXPOSE 8080 9394

CMD ["/stat_server", "--cloud"]