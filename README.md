# express-api

## Run the app

```sh
npm start
```

## Run tests

```sh
npm test
```

The sample tests are in `test/app.test.js`. They start the Express app on a random local port, call the `/` and `/health` routes, and check the JSON responses.

## Run with Docker and SSH

```sh
docker compose up --build
```

The API is available at `http://localhost:3000`.

SSH into the Ubuntu container:

```sh
ssh root@localhost -p 2222
```

The default SSH password is `123456`. For anything beyond local development, override `SSH_PASSWORD` during build.

```sh
SSH_PASSWORD='change-me' docker compose up --build
```
