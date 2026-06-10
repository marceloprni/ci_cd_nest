FROM node:18 AS build

# ELE CRIA UM DIRETORIO PARA RODAR O CODIGO
WORKDIR /usr/src/app

# 1. Copia os arquivos de configuração do Yarn e os arquivos de dependências
# 2. Copia o restante do código da aplicação
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

COPY . .

RUN yarn run build
RUN yarn workspaces focus --production && yarn cache clean

FROM node:18-alpine3.19

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["yarn", "run", "start:prod"]