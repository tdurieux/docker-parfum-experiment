FROM scratch

ENV A="B C" \
    D=E

LABEL label="$A $D"