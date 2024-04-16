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

convert-to-docx:
  #!/usr/bin/env nu
  cd typst
  sd -s '"./template.typ"' '"./template_to_export.typ"' main.typ
  try { pandoc main.typ -o ../ignored/main.docx }
  sd -s '"./template_to_export.typ"' '"./template.typ"' main.typ
