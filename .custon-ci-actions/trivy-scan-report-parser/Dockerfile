FROM alpine

RUN apk update &&\
    apk upgrade &&\
    apk add --no-cache jq &&\
    rm -rf /var/cache/apk/*

COPY ./script.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
