FROM devartis/storm:1.0.2  
MAINTAINER devartis  
  
EXPOSE 6700  
EXPOSE 6701  
EXPOSE 6702  
EXPOSE 6703  
EXPOSE 8000  
RUN /usr/bin/config-supervisord.sh supervisor  
RUN /usr/bin/config-supervisord.sh logviewer  
CMD /usr/bin/start-supervisor.sh  
  

