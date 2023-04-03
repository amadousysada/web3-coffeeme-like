FROM node:16-bullseye-slim as base

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        python3 && \
    rm -fr /var/lib/apt/lists/* && \
    rm -rf /etc/apt/sources.list.d/*

RUN npm install --global --quiet truffle ganache

FROM base as truffle

RUN mkdir -p /home
WORKDIR /home

COPY app /home
COPY truffle-config.js /home
COPY contracts /home/contracts
COPY migrations /home/migrations/
COPY test /home/test/

# CMD ["truffle", "version"]

WORKDIR /home/app
RUN yarn install --silent


FROM base as ganache

RUN mkdir -p /home
WORKDIR /home
EXPOSE 8545

ENTRYPOINT ["ganache", "--host", "0.0.0.0"]