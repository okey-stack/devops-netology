# Самоконтроль выполненения задания

1. #### Где расположен файл с `some_fact` из второго пункта задания?
  group_vars/{group}/*.yaml  
2. #### Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
  ```ansible-playbook -i playbook/inventory/test.yml playbook/site.yml```    
3. #### Какой командой можно зашифровать файл?
  ```ansible-vault encrypt filename```  
4. #### Какой командой можно расшифровать файл?
  ```ansible-vault decrypt filename```
5. #### Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
  ```ansible-vault view filename```
6. #### Как выглядит команда запуска `playbook`, если переменные зашифрованы?
  ```ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --ask-vault-password```
7. #### Как называется модуль подключения к host на windows?
   ```ansible-doc -t connection -l``` -> winrm                          Run tasks over Microsoft's WinRM  
8. #### Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
  ```ansible-doc -t connection -s ssh```
9. #### Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
  ```text
- remote_user
        User name with which to login to the remote server, normally set
        by the remote_user keyword.
        If no user is supplied, Ansible will let the ssh client binary
        choose the user as it normally
        [Default: (null)]
        set_via:
          env:
          - name: ANSIBLE_REMOTE_USER
          ini:
          - key: remote_user
            section: defaults
          vars:
          - name: ansible_user
          - name: ansible_ssh_user
        
        cli:
        - name: user

```