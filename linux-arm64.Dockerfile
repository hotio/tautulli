FROM hotio/base@sha256:12a997c30659bf971cda4b0225148f7cdd149f5d14992f65471a92dab1c8eed4
ENV TAUTULLI_DOCKER="True"
EXPOSE 8181

RUN apk add --no-cache python3 py3-lxml py3-openssl py3-setuptools && \
    apk add --no-cache --virtual=build-dependencies py3-pip make gcc g++ python3-dev && \
    pip3 install --no-cache-dir --upgrade plexapi pycryptodomex && \
    apk del --purge build-dependencies

ARG VERSION
ARG BRANCH
RUN curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}" && \
    echo "v${VERSION}" > "${APP_DIR}/version.txt" && \
    echo "${BRANCH}" > "${APP_DIR}/branch.txt"

COPY root/ /
