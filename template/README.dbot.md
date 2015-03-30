# Docker Exec Bot

Scripts for batch docker-exec tasks.

# Installation

```sh
$ git clone https://github.com/docker-exec/docker-exec-bot.git
$ cd docker-exec-bot
$ cp .dbot-placeholder .dbot
```

Complete the required properties in the '.dbot' configuration file. A personal access token can be generated on GitHub and used in place of an account password.

# Usage

```
Usage:
    ./dbot.sh -t <type> -o <operation>
    ./dbot.sh -g <global operation>

Options:
    -t {{types}}
    -o {{ops}}
    -g {{global-ops}}
```
