## Откуда что брать:

### Нормативное

- гост для того чтобы понять как писать: https://docs.cntd.ru/document/1200026224

### Typst

- какой-то темплейт для тезиса https://github.com/Dherse/masterproef/blob/main/masterproef/ugent-template.typ
- 

## Useful commands:

```nushell
ls ~/Documents/work/ipu/**/* | where type == file | $in.name | each { path parse } | where extension == docx | each { pandoc --wrap=none $"($in.parent)/($in.stem).($in.extension)" -o $"~/Documents/work/12_sem/thesis/ignored/($in.stem).typ"}
```
