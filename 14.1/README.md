# Домашнее задание к занятию "14.1 Создание и использование секретов"

## Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

Выполните приведённые ниже команды в консоли, получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать секрет?

```
openssl genrsa -out cert.key 4096
openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
```
![create](img/create.png)


### Как просмотреть список секретов?

```
kubectl get secrets
kubectl get secret
```
![get](img/get.png)

### Как просмотреть секрет?

```
kubectl get secret domain-cert
kubectl describe secret domain-cert
```
![watch](img/watch.png)

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get secret domain-cert -o yaml
kubectl get secret domain-cert -o json
```
![watch](img/watch_yaml.png)
![watch](img/watch_json.png)

### Как выгрузить секрет и сохранить его в файл?

```
kubectl get secrets -o json > secrets.json
kubectl get secret domain-cert -o yaml > domain-cert.yml
```
![save](img/save.png)

### Как удалить секрет?

```
kubectl delete secret domain-cert
```
![delete](img/delete.png)

### Как загрузить секрет из файла?

```
kubectl apply -f domain-cert.yml
```
![load](img/load.png)

## Задача 2 (*): Работа с секретами внутри модуля

Выберите любимый образ контейнера, подключите секреты и проверьте их доступность
как в виде переменных окружения, так и в виде примонтированного тома.

1. Создадим [deployment](deployment.yml) c секретом и подом
2. Применим все и посмотрим на секрет внтури пода
   ![res](img/res2.png)