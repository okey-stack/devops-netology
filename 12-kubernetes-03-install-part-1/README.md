# Домашнее задание к занятию "12.3 Развертывание кластера на собственных серверах, лекция 1"
Поработав с персональным кластером, можно заняться проектами. Вам пришла задача подготовить кластер под новый проект.

## Задание 1: Описать требования к кластеру
Сначала проекту необходимо определить требуемые ресурсы. Известно, что проекту нужны база данных, система кеширования, а само приложение состоит из бекенда и фронтенда. Опишите, какие ресурсы нужны, если известно:

* база данных должна быть отказоустойчивой (не менее трех копий, master-slave) и потребляет около 4 ГБ ОЗУ в работе;
* кэш должен быть аналогично отказоустойчивый, более трех копий, потребление: 4 ГБ ОЗУ, 1 ядро;
* фронтенд обрабатывает внешние запросы быстро, отдавая статику: не более 50 МБ ОЗУ на каждый экземпляр;
* бекенду требуется больше: порядка 600 МБ ОЗУ и по 1 ядру на копию.

Требования: опишите, сколько нод в кластере и сколько ресурсов (ядра, ОЗУ, диск) нужно для запуска приложения. Расчет вести из необходимости запуска 5 копий фронтенда и 10 копий бекенда, база и кеш.

---
Подсчет:
1. DB - 3 master, 3 slave по 4 GB RAM и 2 CPU - 24GB RAM, 12 CPU 
2. Cash - 5 master по 4 GB RAM и 1 CPU - 20 GB RAM, 5 CPU 
3. frontend - 5 pods по 0,05 GB RAM и 0.25 CPU - 0,25 GB RAM, 1,25 CPU 
4. backend - 10 pods по 0,6 GB RAM и 1 CPU - 6GB RAM, 10CPU 


Итого:  
   * Минимум ресурсов:  51 GB RAM, 28,5 CPU
   * Ноды:
     * 3 control plane node по 2 CPU, 2GB RAM, 50GB (минимум 2 CPU, 2GB RAM, 50GB)
     * 8 worker node (Cash и DB - demonset) по 8GB RAM, 4 CPU, 100GB
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
