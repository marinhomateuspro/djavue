FROM python:3.6-alpine

RUN apk add  --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.14/main/ nodejs=14.19.0-r0
RUN apk add openrc bash curl vim nano git zip unzip nginx make gcc g++ libc-dev linux-headers npm postgresql-libs musl-dev postgresql-dev && \
    mkdir -p /run/nginx && \
    pip install uwsgi uwsgitop

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    echo "export LS_OPTIONS='--color=auto'" >>~/.bashrc && \
    echo "alias ls='ls \$LS_OPTIONS'" >>~/.bashrc && \
    echo "alias ll='ls \$LS_OPTIONS -l'" >>~/.bashrc && \
    echo "alias l='ls \$LS_OPTIONS -lA'" >>~/.bashrc

RUN mkdir /dkdata
WORKDIR /app

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY frontend/package.json frontend/package.json
COPY frontend/package-lock.json frontend/package-lock.json
RUN cd frontend && npm install && npm install -g pm2
COPY frontend frontend
RUN cd frontend && npm run build

ENV SHELL=/bin/bash PYTHONUNBUFFERED=1 NODE_ENV=production API_MOCK=0 PYTHONIOENCODING=UTF-8 LANG=en_US.UTF-8 DJANGO_STATIC_ROOT=/dkdata/static DJANGO_LOG_FILE=/dkdata/djavue.log UWSGI_PROCESSES=3 PORT=3000 HOST=0.0.0.0 API_BASE_URL=http://localhost:8000

COPY . /app
COPY docker/bin/* /usr/bin/
COPY docker/compose/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY docker/compose/nginx/proxy_params /etc/nginx/proxy_params