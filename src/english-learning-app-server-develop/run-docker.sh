#!/usr/bin/bash

docker build -t datn-app-server .

docker tag datn-app-server 18120211/datn-app-server

docker stop datn-app-server

docker system prune

docker run -d -p 80:3000 --name=datn-app-server 18120211/datn-app-server

docker exec -d datn-app-server npm run start

docker push 18120211/datn-app-server
