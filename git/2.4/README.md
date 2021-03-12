# Домашнее задание к занятию «2.4. Инструменты Git»

В рамках домашнего задание необходимо было ответить на следующие вопросы: 

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.
2. Какому тегу соответствует коммит `85024d3`?
3. Сколько родителей у коммита `b8d720`? Напишите их хеши.
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.
5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).
6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.
7. Кто автор функции `synchronizedWriters`? 

Ответы:

1. С помощью команды `git show aefea`, был найден полный хеш коммита `aefead2207ef7e2aa5dc81a34aedf0cad4c32545` и комментарий к нему `Update CHANGELOG.md`
2. С помощью команды `git show 85024d3` или команды `git log -1 85024d3` или ` git show-ref --dereference | grep '85024d3'`, был найден тег коммита `v0.12.23`
3. С помощью команды `git log --parents -n 1 b8d720` или команды `git log --pretty=%P -n 1 b8d720` были найдены все родители коммита `56cd7859e05c36c06b56d013b55a252d0bb7e158` и `9ea88f22fc6269854151c571162c5bcf958bee2b`, так же выполняя команду `git show b8d720` увидеть родителей в графе `Merge: 56cd7859e 9ea88f22f`
4. С помощью команды  `git log v0.12.24...v0.12.23 --oneline` или команды `git log v0.12.24...v0.12.23 --oneline --pretty='%H %s'`

    | SHA | Subject |
    |----|----|
    | b14b74c4939dcab573326f4e3ee2a62e23e12f89 | [Website] vmc provider links |
    | 3f235065b9347a758efadc92295b540ee0a5e26e | Update CHANGELOG.md |
    | 6ae64e247b332925b872447e9ce869657281c2bf | registry: Fix panic when server is unreachable |
    | 5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 | website: Remove links to the getting started guide's old location |
    | 06275647e2b53d97d4f0a19a0fec11f6d69820b5 | Update CHANGELOG.md |
    | d5f9411f5108260320064349b757f55c09bc4b80 | command: Fix bug when using terraform login on Windows |
    | 4b6d06cc5dcb78af637bbb19c198faff37a066ed | Update CHANGELOG.md |
    | dd01a35078f040ca984cdd349f18d0b67e486c35 | Update CHANGELOG.md |
    | 225466bc3e5f35baa5d07197bbc079345b77525e | Cleanup after v0.12.23 release |
 
    так же помощью команды `git log v0.12.24...v0.12.23 --oneline --pretty='%H %B'` можно получить более развернутые сообщение к коммитам

5. С помощью команды `git log -S 'func providerSource(' --oneline` можно узнать что функция была создана в коммите `8c928e835`, далее с помощью `git show 8c928e835`, можно узнать более подробную информацию о том когда кем и в каком файле была создана данная функция, так же можно использовать форматирование такое как `git log -S'func providerSource(' --pretty='%H [%cn <%ce>] | %cs | %s'`
6. С помощью команды `git grep 'func globalPluginDirs('` можно найти файлы в которых содержится функция с таким названием, затем с помощью команды `git log -L :globalPluginDirs:plugins.go` можно узнать все коммиты в которых делались какие-либо изменения в данной функции:

    | SHA | Subject |
    |----|----|
    | 78b12205587fe839f10d946ea3fdc06719decb05 | Remove config.go and update things using its aliases |
    | 52dbf94834cb970b510f2fba853a5b49ad9b1a46 | keep .terraform.d/plugins for discovery |
    | 41ab0aef7a0fe030e84018973a64135b11abcd70 | Add missing OS_ARCH dir to global plugin paths |
    | 66ebff90cdfaa6938f26f908c7ebad8d547fea17 | move some more plugin search path logic to command |
    | 8364383c359a6b738a436d1b7745ccdce178df47 | Push plugin discovery down into command package |

7. С помощью команды `git log -S'func synchronizedWriters('` и `git show <commit>` удалось выяснить что автором функции `synchronizedWriters` был Martin Atkins `5ac311e2a91e381e2f52234668b49ba670aa0fe5` от 03.05.2017, после чего данная функция была удалена пользователем James Bardin `bdfea50cc85161dea41be0fe3381fd98731ff786` 30.11.2020