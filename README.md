# Docker PHP-FPM base on Alpine Linux

![Build/Publish CI](https://github.com/fabioassuncao/docker-images/workflows/Docker%20Build/Publish%20CI/badge.svg)

Simple docker image for PHP/Laravel development.

### Why should use this image

- Built on the lightweight and
  secure [Alpine Linux](https://www.alpinelinux.org/) distribution
- Multi-platform, supporting AMD4, ARMv6, ARMv7, ARM64
- Very small Docker image size

### How to use

Build image

```shell
VERSION=8.4 make build
```

Release image

```shell
VERSION=8.4 make release
```

How to customize image name

```shell
VERSION=8.4 IMAGE=ghcr.io/fabioassuncao/php make build
```

Check image by PHP version

```shell
VERSION=8.4 make check
```

Check all image

```shell
make check-all
```

Mount your code to be served with container

```shell
docker run --name=app -v /path/to/project:/var/www/html -p 8000:8000 ghcr.io/fabioassuncao/php:8.4
```

Using docker-compose

```
x-function: &common_setup
    image: ghcr.io/fabioassuncao/php:8.4
    restart: always
    environment:
        CONTAINER_ROLE: app
        CONTAINER_MODE: automatic
    networks:
      - laravel
    env_file:
        - .env
    volumes:
        - .:/var/www/html

services:
  app:
    <<: *common_setup
    ports:
      - '8000:8000'

  horizon:
    <<: *common_setup
    environment:
      CONTAINER_ROLE: horizon

  scheduler:
    <<: *common_setup
    environment:
      CONTAINER_ROLE: scheduler

networks:
  laravel:
    driver: bridge

```

### PHP version support
- [x] PHP 8.4 (Lightweight container with PHP 8.4 based on Alpine Linux)
- [x] PHP 8.3 (Lightweight container with PHP 8.3 based on Alpine Linux)
- [x] PHP 8.2 (Lightweight container with PHP 8.2 based on Alpine Linux)
- [x] PHP 8.2-nginx (Lightweight container with PHP 8.2 and nginx based on Debian bullseye)


## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.