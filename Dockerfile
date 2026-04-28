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
COPY <<'EOF' /etc/nginx/conf.d/default.conf
server {
    listen 80;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /404.html;
    }

    # cache static assets aggressively
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
