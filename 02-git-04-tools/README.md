1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`. \
   `git show --pretty=format:"%H -> %s" --no-patch aefea`
   > aefead2207ef7e2aa5dc81a34aedf0cad4c32545 -> Update CHANGELOG.md
2. Какому тегу соответствует коммит `85024d3`? \
   `git show --pretty=format:"%d" --no-patch 85024d3`
   >  (tag: v0.12.23)
3. Сколько родителей у коммита `b8d720`? Напишите их хеши.\
   Перейдем в коммит `git checkout b8d720`. Посмотрим граф и кол-во предков коммита -`git log --oneline --graph -n 5`
   Смотрим 1 родителя `git show b8d720^` и второго родителя `git show b8d720^2`
   > Родителей 2. \
   > 56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.\
   `git log --oneline --pretty=format:"%H %s" v0.12.23..v0.12.24`
   > 33ff1c03bb960b332be3af2e333462dde88b279e v0.12.24 \
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links\
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md\
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable\
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location\
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md\
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows\
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md\
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md\
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release

5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).\
   `git grep -n 'func providerSource(.*)'`
   `git log -L:providerSource:provider_source.go --reverse -1`
   > commit 5af1e6234ab6da412fb8637393c5a17a1b293663
6. Найдите все коммиты в которых была изменена функция `globalPluginDirs` \
   ` git grep -p 'globalPluginDirs' `\
   `git log --no-patch --oneline -L:globalPluginDirs:plugins.go`
   > 78b122055 Remove config.go and update things using its aliases\
52dbf9483 keep .terraform.d/plugins for discovery\
41ab0aef7 Add missing OS_ARCH dir to global plugin paths\
66ebff90c move some more plugin search path logic to command\
8364383c3 Push plugin discovery down into command package

7. Кто автор функции `synchronizedWriters`? 
   Ищем коммит с созданием функции `git grep -p synchronizedWriters $(git log --pretty=format:"%H" -S "synchronizedWriters")`\
   Смотрим автора `git show --no-patch --pretty=format:"%an" 5ac311e2a91e381e2f52234668b49ba670aa0fe5`
   > Martin Atkins

