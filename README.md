# Codions Docker
Imagens docker personalizadas para desenvolvimento e produção

## Importante
Este projeto possui partes do repositório [codecasts/ambientum](https://github.com/codecasts/ambientum)

## Imagens disponíveis
| Repositório             | Imagens/Tags     | Descrição                                                    |
| ----------------------- | ---------------- | ------------------------------------------------------------ |
| codions/**php**         | `7.1`, `latest`  | PHP v7.1 para linha de comando                               |
|                         | `7.1-nginx`      | PHP v7.1 com servidor web NGINX                              |
|                         | `7.1-apache`     | PHP v7.1 com servidor web Apache                             |
| codions/**node**        | `9`, `latest`    | Node.js v9.x                                                 |
|                         | `8`, `lts`       | Node.js v8.x                                                 |
| codions/**mysql**       | `5.7`, `latest`  | MySQL Server v5.7 (with sql-mode='')                         |
|                         | `5.6`            | MySQL Server v5.6                                            |
| codions/**mariadb**     | `10.3`, `latest` | MariaDB Server v10.3                                         |
|                         | `10.2`           | MariaDB Server v10.2                                         |
|                         | `5.5`            | MariaDB Server v5.5                                          |
| codions/**postgres**    | `9.6`, `latest`  | PostgreSQL Server v9.6                                       |
|                         | `9.5`            | PostgreSQL Server v9.5                                       |
|                         | `9.4`            | PostgreSQL Server v9.4                                       |
| codions/**redis**       | `4.0`, `latest`  | Redis Server v4.0                                            |
|                         | `3.2`            | Redis Server v3.2                                            |
|                         | `3.0`            | Redis Server v3.0                                            |
| codions/**mailcatcher** | `latest`         | MailCatcher é uma alternativa *self-hosted* para Mailtrap.io |


## Contribuição

1. Fork este repositório!
2. Crie sua feature a partir da branch **develop**: `git checkout -b feature/my-new-feature`
3. Escreva e comente seu código.
4. Commit suas alterações: `git commit -am 'Add some feature'`
5. Faça um `push` para a branch: `git push origin feature/my-new-feature`
6. Faça um `pull request` para a branch **develop**

## Créditos

[Fábio Assunção](https://github.com/fabioassuncao) e todos os [contribuidores](https://github.com/fabioassuncao/docker-images/graphs/contributors).

## Licença

Licenciado sob a licença MIT.
