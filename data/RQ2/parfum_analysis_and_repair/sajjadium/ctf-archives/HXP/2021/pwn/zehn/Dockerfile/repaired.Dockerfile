# Running locally:
# 1) echo 'hxp{FLAG}' > flag.txt
# 2) docker build -t zehn .
# 3) docker run -p 55557:1024 --rm --cap-add=SYS_ADMIN --security-opt apparmor=unconfined -it zehn