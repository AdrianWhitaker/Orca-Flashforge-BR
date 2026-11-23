# Flash Studio em português do Brasil

O pacote traduz a interface que usa os catálogos gettext do Flash Studio. Use o instalador oficial da FlashForge e copie apenas o arquivo de idioma.

## Instalador para Windows

Baixe [Instalar-Flash-Studio-PT-BR.exe](installer/Instalar-Flash-Studio-PT-BR.exe?raw=true) e abra o arquivo com o Flash Studio fechado. Após a confirmação do Windows, o instalador verifica primeiro `C:\Program Files\Flashforge\Flash Studio Desktop\`. Se a busca automática não localizar o Flash Studio, o seletor de pastas do Windows será aberto. Pressione `Ctrl+L`, cole o caminho da pasta que contém `flash studio.exe` (ou `flash-studio.exe` em algumas versões), pressione `Enter` e confirme em **Selecionar pasta**. Depois, abra ou reinicie o Flash Studio. Em um Windows configurado em português, o aplicativo pode carregar o idioma automaticamente.

O instalador inclui o catálogo e funciona offline. Se já existir um catálogo pt-BR, a primeira versão encontrada é preservada como `Orca-Flashforge.mo.bak` na mesma pasta. O executável não tem assinatura digital e o Windows pode mostrar um aviso do SmartScreen.

SHA-256 do instalador: `7ad6c7e00775425056ec22c974f2a30147abea5b2204f457893e3beac1207547`.

O [código-fonte NSIS](installer/Instalar-Flash-Studio-PT-BR.nsi) pode ser compilado na raiz do repositório com `makensis -DCATALOG=../resources/i18n/pt_BR/Orca-Flashforge.mo installer/Instalar-Flash-Studio-PT-BR.nsi` no Linux, ou `makensis /DCATALOG=..\resources\i18n\pt_BR\Orca-Flashforge.mo installer\Instalar-Flash-Studio-PT-BR.nsi` no Windows.

## Instalação manual no Windows

1. Baixe [Orca-Flashforge.mo](resources/i18n/pt_BR/Orca-Flashforge.mo?raw=true) e feche o Flash Studio.
2. Na pasta de instalação, localize `resources\i18n` e confirme que as pastas dos outros idiomas contêm arquivos `Orca-Flashforge.mo`.
3. Crie a pasta `pt_BR` dentro de `i18n` e copie o arquivo para `resources\i18n\pt_BR\Orca-Flashforge.mo`. Se já existir um catálogo nesse caminho, guarde uma cópia antes de substituir.
4. Abra ou reinicie o Flash Studio. Em um Windows configurado em português, o aplicativo pode carregar o idioma automaticamente.

Após atualizar o Flash Studio, confira se o catálogo continua na pasta. Para desfazer, selecione outro idioma nas preferências e remova o arquivo copiado, ou restaure a cópia anterior.

## Cobertura no Flash Studio Desktop 1.7.23

O instalador 1.0.4 acrescenta 1.726 traduções do OrcaSlicer e 14 traduções de comandos de filamentos mistos. A correspondência foi feita usando as chaves do catálogo instalado pela build Windows 1.7.23 (ac437297), incluindo a ajuda de **Altura da primeira camada**. Das 6.148 chaves do catálogo chinês dessa build, 5.066 têm correspondência exata no catálogo brasileiro. As demais ainda podem aparecer em inglês. A página inicial web e a documentação externa aberta pelos links de ajuda não são cobertas pelo catálogo nativo.

## Fonte e manutenção

O [catálogo editável](localization/i18n/pt_BR/Orca-Flashforge_pt_BR.po) usa o modelo `localization/i18n/OrcaSlicer.pot` deste fork. Foram mantidas 4.304 traduções do catálogo pt-BR existente e incorporadas 13 do [OrcaSlicer](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/localization/i18n/pt_BR/OrcaSlicer_pt_BR.po) com as mesmas chaves de mensagem e marcadores de formatação. A versão 1.0.3 preenche as 27 entradas que estavam em branco e acrescenta 23 chaves vistas nas preferências e no código-fonte. O catálogo contém 4.367 entradas traduzidas. A página inicial mostrada em builds recentes usa recursos web separados e não é traduzida pelo catálogo nativo. A compatibilidade em execução no Windows ainda precisa ser testada.

Para recompilar só o catálogo, use GNU gettext na raiz do repositório:

```sh
msgfmt --check-format -o resources/i18n/pt_BR/Orca-Flashforge.mo localization/i18n/pt_BR/Orca-Flashforge_pt_BR.po
```

Os catálogos de origem são dos projetos Orca-Flashforge e OrcaSlicer e seguem a licença AGPL-3.0 do repositório.
