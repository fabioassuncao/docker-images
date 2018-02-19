# Codions Docker
Imagens docker personalizadas para desenvolvimento e produção

## Importante
Este projeto possui partes do repositório [codecasts/ambientum](https://github.com/codecasts/ambientum)

## Imagens disponíveis
| Repositório             | Imagens/Tags     | Descrição                            | Documentação |
| ----------------------- | ---------------- | ------------------------------------ | :----------: |
| codions/**php**         | `7.1`, `latest`  | PHP v7.1 para linha de comando       |     WIP      |
|                         | `7.1-nginx`      | PHP v7.1 com servidor web NGINX      |              |
|                         | `7.1-apache`     | PHP v7.1 com servidor web Apache     |              |
| codions/**node**        | `9`, `latest`    | Node.js v9.x                         |              |
|                         | `8`, `lts`       | Node.js v8.x                         |              |
| codions/**mysql**       | `5.7`, `latest`  | MySQL Server v5.7 (with sql-mode='') |              |
|                         | `5.6`            | MySQL Server v5.6                    |              |
| codions/**mariadb**     | `10.3`, `latest` | MariaDB Server v10.3                 |              |
|                         | `10.2`           | MariaDB Server v10.2                 |              |
| codions/**mailcatcher** | ` latest`        | MailCatcher 0.6.4                    |              |


## Guia de uso rápido dos comandos

### Substituindo comandos locais:
Uma das características deste projeto é permitir que você substitua os comandos com a versão baseada no docker.

Há um conjunto de atalhos que podem ajudar com essa tarefa, mas para isso será necessário fazer a instalação

#### Instalação:
```
curl -sSL https://raw.githubusercontent.com/codions/docker-images/master/commands/installer.sh | bash
```

Depois de fazer a instalação dos comandos, seguindo as instruções acima, você poderá usá-los imediatamente.

#### Importante: A primeira execução pode levar algum tempo, uma vez que irá baixar as imagens

Tudo que for relacionado ao Node.JS pode ser executado prefixando o comando `n`. Por exemplo, digamos que precisamos instalar o Gulp
```
n npm install -g gulp
n gulp --version
```

Tudo relacionado ao PHP pode ser executado prefixando o comando `p`. Por exemplo, digamos que queremos executar o composer

```
p composer global require some/package-here
```

Ou até mesmo executar um único arquivo com PHP:
```
p php test.php
```

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
