# Flash Studio em português do Brasil

O pacote traduz a interface que usa os catálogos gettext do Flash Studio. Use o instalador oficial da FlashForge e copie apenas o arquivo de idioma.

## Instalador para Windows

Baixe [Instalar-Flash-Studio-PT-BR.exe](installer/Instalar-Flash-Studio-PT-BR.exe?raw=true) e abra o arquivo com o Flash Studio fechado. Após a confirmação do Windows, o instalador procura a instalação automaticamente. Se precisar localizar a pasta manualmente, selecione a pasta que contém `flash-studio.exe`. Depois, abra o Flash Studio e selecione **Português (Brasil)** nas preferências.

O instalador inclui o catálogo e funciona offline. Se já existir um catálogo pt-BR, a primeira versão encontrada é preservada como `Orca-Flashforge.mo.bak` na mesma pasta. O executável não tem assinatura digital e o Windows pode mostrar um aviso do SmartScreen.

SHA-256 do instalador: `bcbfb6606fdd735bf082df86b582cdd8aa90536a0cf6d252e3af2f0fccfd53fd`.

O [código-fonte NSIS](installer/Instalar-Flash-Studio-PT-BR.nsi) pode ser compilado na raiz do repositório com `makensis -DCATALOG=../resources/i18n/pt_BR/Orca-Flashforge.mo installer/Instalar-Flash-Studio-PT-BR.nsi` no Linux, ou `makensis /DCATALOG=..\resources\i18n\pt_BR\Orca-Flashforge.mo installer\Instalar-Flash-Studio-PT-BR.nsi` no Windows.

## Instalação manual no Windows

1. Baixe [Orca-Flashforge.mo](resources/i18n/pt_BR/Orca-Flashforge.mo?raw=true) e feche o Flash Studio.
2. Na pasta de instalação, localize `resources\i18n` e confirme que as pastas dos outros idiomas contêm arquivos `Orca-Flashforge.mo`.
3. Crie a pasta `pt_BR` dentro de `i18n` e copie o arquivo para `resources\i18n\pt_BR\Orca-Flashforge.mo`. Se já existir um catálogo nesse caminho, guarde uma cópia antes de substituir.
4. Abra o Flash Studio, selecione **Português (Brasil)** nas preferências de idioma e reinicie o aplicativo se solicitado.

Após atualizar o Flash Studio, confira se o catálogo continua na pasta. Para desfazer, selecione outro idioma nas preferências e remova o arquivo copiado, ou restaure a cópia anterior.

## Fonte e manutenção

O [catálogo editável](localization/i18n/pt_BR/Orca-Flashforge_pt_BR.po) usa o modelo `localization/i18n/OrcaSlicer.pot` deste fork. Foram mantidas 4.304 traduções do catálogo pt-BR existente e incorporadas 13 do [OrcaSlicer](https://github.com/OrcaSlicer/OrcaSlicer/blob/main/localization/i18n/pt_BR/OrcaSlicer_pt_BR.po) com as mesmas chaves de mensagem e marcadores de formatação. O modelo tem 4.344 entradas, das quais 27 ficaram sem tradução. Textos fora desse modelo, inclusive interfaces que usam outros mecanismos de idioma, podem aparecer em inglês. A compatibilidade em execução no Windows ainda precisa ser testada.

Para recompilar só o catálogo, use GNU gettext na raiz do repositório:

```sh
msgfmt --check-format -o resources/i18n/pt_BR/Orca-Flashforge.mo localization/i18n/pt_BR/Orca-Flashforge_pt_BR.po
```

Os catálogos de origem são dos projetos Orca-Flashforge e OrcaSlicer e seguem a licença AGPL-3.0 do repositório.
