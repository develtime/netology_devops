# Домашнее задание к занятию «2.1. Системы контроля версий.»

В рамках домашнего задания была создана директория terraform с файлом [.gitignore](../../terraform/.gitignore) для игнорирования следующих файлов:

- Все файлы расположенные в директориях ".terraform" на любой вложенности
- Все файлы с расширением ".tfstate" или содержащие ".tfstate." в названии
- Файл с названием "crash.log"
- Все файлы с расширением ".tfvars"
- Файлы с названием "override.tf" или "override.tf.json", а так же файлы заканчивающиеся на "_override.tf" и "_override.tf.json"
- Файлы ".terraformrc" и "terraform.rc"

