# Сторонние компоненты

Проект использует внешние библиотеки и бинарники, **не входящие в этот репозиторий**.

## SQLite

- **Компонент:** `sqlite3.dll` (официальная сборка SQLite)
- **Лицензия:** [Public Domain](https://www.sqlite.org/copyright.html)
- **Установка:** см. раздел «Установка» в [README.md](README.md)

## SynEdit (SQL-редактор)

- **Назначение:** подсветка SQL, редактор запросов (`TSynEdit`, `SynHighlighterSQL`)
- **Репозиторий:** https://github.com/SynEdit/SynEdit
- **Лицензия:** MPL 1.1 / GPL (см. репозиторий SynEdit)
- **Установка в Delphi:** установите пакет SynEdit в IDE (Component → Install Packages) или добавьте исходники в Library Path

Без SynEdit проект не соберётся: компоненты указаны в `MainForm.pas` / `MainForm.dfm`.

## Исходный Firefox-расширение

- **Проект:** [lazierthanthou/sqlite-manager](https://github.com/lazierthanthou/sqlite-manager)
- **Лицензия:** MPL 1.1
- Delphi-версия — порт с сохранением идеи и лицензии оригинала.
