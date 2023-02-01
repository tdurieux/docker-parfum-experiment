# In production this should probably be busybox, but let's use ubuntu for a
# fair comparison 
# docker run -d -p 3306:3306 -e MYSQL_PASS="password" tutum/mysql