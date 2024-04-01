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
    let res = (python scripts/gen_images.py | complete)
    if $res.exit_code == 0 {
      notify-send 'task: assets: done'
    } else {
      notify-send 'task: assets: failed'
    }
