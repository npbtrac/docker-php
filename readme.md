Docker containers for PHP CLI and FPM on Ubuntu, https://hub.docker.com/u/npbtrac.

- You need to pull the image to your local first
```
docker pull npbtrac/php80_cli
```

- To check PHP extensions in the image
```
docker run --rm --interactive --tty -v $PWD:/app npbtrac/php80_cli php -m
```

- To composer install
```
docker run --rm --interactive --tty -e XDEBUG_MODE=off -e COMPOSER=composer.json -v $PWD:/app npbtrac/php80_cli  composer install --no-dev
```

### Credits
- https://github.com/serversideup/docker-php