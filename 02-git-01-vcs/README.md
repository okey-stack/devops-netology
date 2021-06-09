* `**/.terraform/*`
  GIT проигнорирует содержимое во дирректорий .terraform (в том числе и вложенных) как и саму дирректорию т.к. все файлы в ней будут проигнорированы
* `*.tfstate` `*.tfstate.*` GIT проигнорирует файлы в текущей дирректории с расширением .tfstate и расширением .tfstate.любое_символы_далее
* `crash.log` GIT проигнорирует файлы в текущей дирректории crash.log
* `*.tfvars`GIT проигнорирует файлы в текущей дирректории с расширением .tfstate
* `override.tf` `override.tf.json` `*_override.tf` `*_override.tf.json` 
  GIT проигнорирует файлы в текущей дирректории crash.log, override.tf.json, все файлы заканчивающиеся на _override.tf и _override.tf.json   
* `!example_override.tf` GIT включит будет отслеживать файл !example_override.tf, несмотря на игнор файлов *_override.tf
* `*tfplan*` GIT проигнорирует файлы в текущей дирректории которые в своем имени имеют строку tfplan
* `.terraformrc` `terraform.rc` GIT проигнорирует файлы в текущей дирректории terraform.rc .terraformrc