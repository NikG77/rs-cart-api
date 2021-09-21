FROM node:12-alpine as base

WORKDIR /app
COPY package*.json ./
RUN npm install

WORKDIR /app
COPY . .
RUN npm run build

FROM node:12-alpine as application

ENV NODE_ENV=production

WORKDIR /app
COPY --from=base /app/package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080
CMD ["node", "/app/dist/main.js"]
