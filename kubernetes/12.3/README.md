# Домашнее задание к занятию "12.3 Развертывание кластера на собственных серверах, лекция 1"

1. Требования к кластеру
   
   Ресурсы:

    | Service name                                                    | CPU (Cores) | MEM (Mb) | DATA (Gb) | Count |
    | ------------------------------------- | ----- | ------- | ----- | ----- |
    | Database | 1   | 4096     | 50   | 3 |
    | Cache    | 1    | 4096     | 20   | 3 |
    | UI       | 0.1   | 50     | 5   | 5 |
    | Server API      | 1   | 600     | 20   | 10 |
    | Summary      | 16.5   |   30826  | 435   |  |
    | Summary (rounded)      | 17   |   32768  | 450   |  |

    Кластер:

    | Service name                                                    | CPU (Cores) | MEM (Mb) | DATA (Gb) | Count |
    | ------------------------------------- | ----- | ------- | ----- | ----- |
    | Control plane | 2   | 2024     | 50   | 1 |
    | Node    | 8    | 16384     | 300   | 3 |
    | Summary      | 24   |   49152  | 900   |  |

** Объем дисков мною был выбран произвольно с уклоном на правдоподобность, т.к. в задаче нет требований к дискам

** Округление по всем характеристикам произведено в большую сторону

** Расчеты характеристик кластера `kubernetes` производил со скидкой на запас прочности, что бы при изменении требований к производительности было куда масштабироваться, не начиная экстренно подключать к кластеру новые ноды