# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.  
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE  
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
FROM baozhida/selenium-base:3.3.1  
MAINTAINER baozhia <baozhida88@126.com>  
  
#========================  
# Selenium Configuration  
#========================  
  
EXPOSE 4444  
  
ENV GRID_THROW_ON_CAPABILITY_NOT_PRESENT true  
# In milliseconds  
ENV GRID_NEW_SESSION_WAIT_TIMEOUT -1  
ENV GRID_JETTY_MAX_THREADS -1  
# In milliseconds  
ENV GRID_NODE_POLLING 5000  
# In milliseconds  
ENV GRID_CLEAN_UP_CYCLE 5000  
# In seconds  
ENV GRID_TIMEOUT 180  
# In seconds  
ENV GRID_BROWSER_TIMEOUT 0  
ENV GRID_MAX_SESSION 15  
# In milliseconds  
ENV GRID_UNREGISTER_IF_STILL_DOWN_AFTER 30000  
  
COPY generate_config /opt/selenium/generate_config  
COPY entry_point.sh /opt/bin/entry_point.sh  
RUN chmod +x /opt/selenium/generate_config \  
&& chmod +x /opt/bin/entry_point.sh \  
&& sh /opt/selenium/generate_config > /opt/selenium/config.json  
RUN chown -R uiauto /opt/selenium  
  
USER uiauto  
  
CMD ["/opt/bin/entry_point.sh"]  

