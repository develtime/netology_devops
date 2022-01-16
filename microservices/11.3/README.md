# Домашнее задание к занятию "11.3 Микросервисы: подходы"

1. Обеспечить разработку
   
   Если мы говорим про необходимость облачной системы, то на сегодняшний день это `Kubernetes` как стандарт де-факто, естественно, если мы как компания обладаем средствами, то так же это может быть `OpenShift`. В случае с вопросом обеспечения команды системой контроля версий и сборочной линией, все намного разнообразней, можем выбрать связку из `Bitbucket` и `Jenkins`, можем выбрать `Gitlab` (платный или community зависит от средств), в целом никто не запрещает использовать `Gitlab` только как систему контроля версий, а сборку осуществлять через `Jenkins` тем более что они оба в нашем случае будут поднимать агентов в `Kubernetes`, из личного опыта знаю что связка `Kubernetes` + `Gitlab` в целом уже решает много вопросов на этапе разработки. В качестве системы хранения артефактов можно выбрать `Nexus`, `Artifactory` или собственное хранилице `Gitlab` (если у нас лицензия), мое личное предпочтение `Nexus`, я бы выбрал его. А для хранения секретов я бы предложил использовать `Vault` который стал тоже неким стандартом на сегодняшний день, в целом, других решений даже не знаю.

2. Логи

    На самом деле, что касается сбора и хранения логов, на рынке в настоящее время есть много решений, но из личного опыта, я не встречал еще никого кто бы использовал не стек `ELK`. На данный момент самое распространенное решение, простое в настройке, легко масштабируемое, удобное в использование (имеется ввиду `Kibana`), имеет возможность обвесить `Kibana` всевозможными расширениями функционала, единственный минус как по мне, это очень большая дороговизна по ресурсам, кластер `Elasticsearch` будет просить от нас много. Так же знаю, но не использовал никогда, что в настоящее время набирает популярность `Grafana Loki` или так называемый стек `PLG` иногда использут части от одного стека, части от другого.

3. Мониторинг
   
   Естественно что касается мониторинга, мы можем найти в сети огромное море решений, но я бы не смотрел ни на что кроме как на `Prometeus`, да, в целом, если у нас небольшой проект и большим он становится не собирается, можно было бы использовать и `Zabbix`. В настоящее время существует много компаний, которые когда-то давно начали использовать `Zabbix`, в целом их все устраивает и переразворачивать стек мониторинга никто не хочет, но для разварачивание с нуля, я бы использовал только `Prometeus`. Примущества в том что `Prometeus` более гибко настраивается, сам собирает метрики ровно столько сколько "считает нужным", хранит данные в `TSDB`, можно легко размаштабировать, активно развивается, так же немаловажно, что с помощью таких решений как `Victoria Metrics` можно реализовать очень мощное геораспределенное хранилище логов, в то время как `Zabbix` будет писать нам данные в реляционнцю базу и при больших объемах данных мониторинга, просто не справится с задачей. В итоге мой выбор это связка `Node exporter`, `Метрики приложений`, `Prometeus` и `Grafana`.