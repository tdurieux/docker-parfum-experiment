USER 1200

#========================
# Selenium SessionQueue Configuration
#========================

# In seconds, maps to "--session-request-timeout"
ENV SE_SESSION_REQUEST_TIMEOUT 300
# In seconds, maps to "--session-retry-interval"
ENV SE_SESSION_RETRY_INTERVAL 15

EXPOSE 5559

COPY start-selenium-grid-session-queue.sh \
    /opt/bin/

COPY selenium-grid-session-queue.conf /etc/supervisor/conf.d/