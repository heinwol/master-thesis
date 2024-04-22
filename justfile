default:
  just --list

convert-reports:
  #!/usr/bin/env nu
  ls ~/Documents/work/ipu/**/*
  | where type == file
  | $in.name
  | each { path parse }
  | where extension == docx
  | each { pandoc --wrap=none $"($in.parent)/($in.stem).($in.extension)" -o $"($env.HOME)/Documents/work/12_sem/thesis/ignored/($in.stem).typ"}

gen-assets:
  #!/usr/bin/env nu
  try {
    python scripts/gen_images.py
    notify-send 'task: assets: DONE'
  } catch {
    notify-send 'task: assets: FAILED'
  }

gen-assets-dev:
  #!/usr/bin/env nu
  let python = "~/Documents/work/ipu/sponge_networks/.nix-env/bin/python"
  try {
    run-external $python scripts/gen_images.py
    notify-send 'task: assets: DONE'
  } catch {
    notify-send 'task: assets: FAILED'
  }

build-python-env:
  nix build .#python-env --out-link .nix-env

update-lock:
  nix flake lock --update-input sponge-networks
  direnv reload

main_file := "main"

convert-to-docx name=main_file:
  #!/usr/bin/env nu
  cd typst
  cp -f {{name}}.typ {{name}}_temp.typ
  (open {{name}}_temp.typ
    | str replace '"./template.typ"' '"./template_to_export.typ"'
    | str replace -a -r '@(\w+):([^\s]+)(\W)' '@${1}_${2}${3}'
    | str replace -a -r '<(\w+):([^\s]+)>' '<${1}_${2}>'
    | save -f {{name}}_temp.typ
  )
  try {
    (pandoc {{name}}_temp.typ
      --bibliography ../literature/sn_literature.bib
      --csl ../literature/gost-r-7-0-5-2008-numeric.csl
      --citeproc
      --reference-doc "../reference_style.docx"
      -V lang=ru-RU
      -o ../ignored/{{name}}.docx
    )
  }
  rm {{name}}_temp.typ

convert-all-to-docx:
  just convert-to-docx main
  just convert-to-docx request

convert-and-replace:
  just convert-all-to-docx
  cp ./ignored/main.docx "./Корешков МНШ Отчет за 2023-2024.docx"
  cp ./ignored/request.docx "./Корешков МНШ Заявка за 2023-2024.docx"
