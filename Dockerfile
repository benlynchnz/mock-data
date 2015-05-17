FROM iojs:2.0.0

MAINTAINER Ben Lynch <ben@jude.io>

RUN npm install -g node-gyp && \
    node-gyp clean && \
    npm cache clean

EXPOSE 3000

RUN mkdir -p ~/build
WORKDIR ~/build

COPY package.json package.json
COPY build build

RUN npm install

CMD ["npm", "start"]

