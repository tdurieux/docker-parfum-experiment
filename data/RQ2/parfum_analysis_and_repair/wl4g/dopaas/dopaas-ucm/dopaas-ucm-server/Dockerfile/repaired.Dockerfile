### Dockerfile for wl4g/${APP_NAME}
### 1. Copy ${APP_NAME}-${APP_VERSION}.tar to current directory.
### 2. Build with: docker build -t com.wl4g/${APP_NAME}:${APP_VERSION} .
### 3. Run with: 
### docker run -p ${APP_PORT}:${APP_PORT} -d -v /mnt/disk1/log/${APP_NAME}:/mnt/disk1/log/${APP_NAME} 
### -v /mnt/disk1/${APP_NAME}:/mnt/disk1/${APP_NAME} --name ${APP_NAME} ${APP_NAME}