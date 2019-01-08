FROM alpine:3.8

ARG VCS_REF
ARG BUILD_DATE
ARG VERSION

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/apihackers/docker-ansible" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

COPY requirements.pip /tmp/requirements.pip

RUN apk add --no-cache python ca-certificates openssl git openssh-client && \
    apk add --no-cache --virtual .build-deps build-base python-dev libffi-dev openssl-dev && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.pip && \
    apk del .build-deps && \
    rm -r /root/.cache


ENV WORKSPACE /workspace

RUN mkdir $WORKSPACE

VOLUME $WORKSPACE

WORKDIR $WORKSPACE

ENV SSH_PRIVATE_KEY ""
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
# CMD [ "ansible-playbook" ]
