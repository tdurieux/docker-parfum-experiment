FROM comaes/storm-base  
  
ADD start.sh /  
  
EXPOSE 3772 6627  
WORKDIR /opt/apache-storm  
  
ENTRYPOINT ["/start.sh"]  

