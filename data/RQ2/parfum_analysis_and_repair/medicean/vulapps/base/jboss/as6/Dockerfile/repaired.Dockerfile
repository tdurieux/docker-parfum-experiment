FROM tutum/jboss:as6
ENV JBOSS_PASS admin123

EXPOSE 8080
CMD ["/run.sh"]