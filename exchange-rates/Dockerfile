# ARG USE_FOR_APP_ROOT_ON_BUILD="/ng-app"
# ARG ANGULAR_BUILD_TARGET="docker"
# ARG USE_FOR_APP_ROOT_ON_BUILD="/ng-app"
# ARG TARGET_UNDER_DIST="exchange-rates"

FROM node:16-alpine AS builder

RUN apk update \
 && apk upgrade \
 && apk add --no-cache --update nodejs npm \
 && rm -rf /var/cache/apk/*

ARG USE_FOR_APP_ROOT_ON_BUILD="/ng-app"
ARG ANGULAR_BUILD_TARGET="docker"

ENV APP_ROOT=${USE_FOR_APP_ROOT_ON_BUILD}

WORKDIR ${APP_ROOT}

COPY package*.json ${APP_ROOT}/
RUN npm ci

COPY . ${APP_ROOT}
RUN $(npm bin)/ng build --configuration=${ANGULAR_BUILD_TARGET}

FROM nginx:1.23.0-alpine AS app

RUN apk update \
 && apk upgrade \
 && rm -rf /var/cache/apk/*

ARG USE_FOR_APP_ROOT_ON_BUILD="/ng-app"
ARG TARGET_UNDER_DIST="exchange-rates"
ENV APP_ROOT="/usr/share/nginx/html"

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder ${USE_FOR_APP_ROOT_ON_BUILD}/dist/${TARGET_UNDER_DIST} ${APP_ROOT}
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
