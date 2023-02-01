# Dockerfile for rpt-client
# 1. mvn clean package -Dmaven.test.skip=true
# 2. Build with: docker build -f Dockerfile -t rpt-client .
# 3. Run with: docker run -d -v /home/rpt/conf:/home/rpt/conf --restart=always --name rpt-client rpt-client