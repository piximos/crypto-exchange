FROM alpine

ENV VERBOSE="true"
ENV MAJOR_IDENTIFIER="^breaking"
ENV MINOR_IDENTIFIER="^feat"
ENV SUB_PATH="."

RUN apk update &&\
    apk upgrade &&\
    apk add --no-cache git &&\
    rm -rf /var/cache/apk/*

COPY ./script.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
