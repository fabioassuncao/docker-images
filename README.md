# Codions Docker
Imagens docker personalizadas para desenvolvimento e produção

## Importante
Este projeto possui partes do repositório [codecasts/ambientum](https://github.com/codecasts/ambientum)

## Imagens disponíveis
| Repositório             | Imagens/Tags        | Descrição                            |
| ----------------------- | ------------------- | ------------------------------------ |
| codions/**debian**      | `stretch`, `latest` | Debian 9 Stretch                     |
|                         | `jessie`            | Debian 8 Jessie                      |
| codions/**ubuntu**      | `16.04`, `latest`   | Ubuntu 16.04 LTS                     |
| codions/**php**         | `7.1`, `latest`     | PHP v7.1 para linha de comando       |
|                         | `7.1-nginx`         | PHP v7.1 com servidor web NGINX      |
|                         | `7.1-apache`        | PHP v7.1 com servidor web Apache     |
|                         | `5.6`               | PHP v5.6 para linha de comando       |
|                         | `5.6-apache`        | PHP v5.6 com servidor web Apache     |
| codions/**node**        | `9`, `latest`       | Node.js v9.x                         |
|                         | `8`, `lts`          | Node.js v8.x                         |
| codions/**mysql**       | `5.7`, `latest`     | MySQL Server v5.7 (with sql-mode='') |
|                         | `5.6`               | MySQL Server v5.6                    |
| codions/**mariadb**     | `10.3`, `latest`    | MariaDB Server v10.3                 |
|                         | `10.2`              | MariaDB Server v10.2                 |
| codions/**mailcatcher** | `latest`            | MailCatcher 0.6.4                    |

> Para mais ferramentas, veja o repositório [codions/docker-commands](https://github.com/codions/docker-commands). É basicamente um conjunto de scripts que permite que você utilize atalhos para substituir os comandos no terminal como o php e node utilizando versões baseadas em containers.

## Contribuição

1. Fork este repositório!
2. Crie sua feature a partir da branch **develop**: `git checkout -b feature/my-new-feature`
3. Escreva e comente seu código.
4. Commit suas alterações: `git commit -am 'Add some feature'`
5. Faça um `push` para a branch: `git push origin feature/my-new-feature`
6. Faça um `pull request` para a branch **develop**

## Créditos

[Fábio Assunção](https://github.com/fabioassuncao) e todos os [contribuidores](https://github.com/codions/docker-images/graphs/contributors).

## Licença

Licenciado sob a licença MIT.
