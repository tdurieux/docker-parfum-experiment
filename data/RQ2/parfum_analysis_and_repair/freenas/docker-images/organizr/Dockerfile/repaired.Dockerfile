FROM lsiocommunity/organizr:latest
LABEL org.freenas.interactive="false"                                   \
      org.freenas.version="38"                                          \
      org.freenas.upgradeable="true"                                    \
      org.freenas.expose-ports-at-host="true"                           \
      org.freenas.autostart="true"                                      \
      org.freenas.web-ui-protocol="http"                                \
      org.freenas.web-ui-port=80                                        \
      org.freenas.web-ui-path=""                                        \
      org.freenas.port-mappings="80:80/tcp"                             \
      org.freenas.volumes="[						                                \
          {								                                              \
              \"name\": \"/config\",					                          \
              \"descr\": \"Configuration files directory\"		          \
          }								                                              \
      ]"                                                                \
       org.freenas.settings="[      						                        \
          {								                                              \
              \"env\": \"PUID\",					                              \
              \"descr\": \"UserID\",	                                  \
              \"optional\": true					                              \
          },								                                            \
          {								                                              \
              \"env\": \"PGID\",					                              \
              \"descr\": \"GroupID\",		                                \
              \"optional\": true					                              \
          },								                                            \
          {								                                              \
              \"env\": \"TZ\",					                                \
              \"descr\": \"Timezone - eg Europe/London\",	           		\
              \"optional\": true					                              \
          }								                                              \
      ]"