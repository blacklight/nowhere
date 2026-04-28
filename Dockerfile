FROM node:22-alpine AS build

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app
COPY pnpm-lock.yaml pnpm-workspace.yaml ./
COPY nowhere/packages/codec/package.json nowhere/packages/codec/package.json
COPY nowhere/packages/web/package.json nowhere/packages/web/package.json
COPY nowhr/package.json nowhr/package.json

RUN pnpm install

COPY nowhere/ nowhere/
COPY nowhr/ nowhr/

RUN cd nowhere/packages/web && pnpm prepare
RUN cd nowhr && pnpm build

FROM nginx:alpine

COPY --from=build /app/nowhr/build /usr/share/nginx/html
RUN printf 'server {\n\
    listen 80;\n\
    server_name _;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
\n\
    location / {\n\
        try_files $uri $uri/ /404.html;\n\
    }\n\
\n\
    location ~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?|ttf|eot)$ {\n\
        expires 1y;\n\
        add_header Cache-Control "public, immutable";\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
