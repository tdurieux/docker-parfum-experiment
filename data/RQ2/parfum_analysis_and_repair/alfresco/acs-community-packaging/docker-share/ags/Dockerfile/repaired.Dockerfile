### Apply AGS community share AMP to Share image
FROM alfresco/alfresco-share-base:${share.image.tag}

LABEL quay.expires-after=${docker.quay-expires.value}

### Copy the AMP from build context to amps_share
COPY target/alfresco-governance-services-community-share-*.amp /usr/local/tomcat/amps_share/
### Install AMP on share