FROM azureaivideo/grocerycontainerl:3

# Throw away the megabyte of console dump in the 'Received input:' line
ENTRYPOINT ["sh", "-c", "runsvdir /var/runit | sed 's/^Received input.*/Received input .../'"]