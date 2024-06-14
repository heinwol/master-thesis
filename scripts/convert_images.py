from pathlib import Path
import hashlib
import subprocess


# https://stackoverflow.com/a/44873382/10240583
def md5sum(filename: Path) -> bytes:
    with open(filename, "rb") as f:
        return hashlib.file_digest(f, "md5").digest()


cache_path = Path("assets/.img_cache")
convert_path = Path("assets/converted")
generated_path = Path("assets/generated")

pe = {"parents": True, "exist_ok": True}


def main() -> None:
    cache_path.mkdir(**pe)
    convert_path.mkdir(**pe)
    for subdir in generated_path.iterdir():
        convert_subdir = convert_path.joinpath(subdir.name)
        convert_subdir.mkdir(**pe)
        cache_subdir = cache_path.joinpath(subdir.name)
        cache_subdir.mkdir(**pe)
        for svg_image in subdir.iterdir():
            if svg_image.suffix != ".svg":
                continue
            image_hash = md5sum(svg_image)
            res_image = convert_subdir.joinpath(svg_image.stem + ".png")
            res_cache = cache_subdir.joinpath(svg_image.stem + ".md5")
            if not (
                res_image.exists()
                and res_cache.exists()
                and res_cache.read_bytes() == image_hash
            ):
                subprocess.run(
                    [
                        "inkscape",
                        "--export-background-opacity=0",
                        "--export-type=png",
                        "--export-dpi=150",
                        rf"--export-filename={res_image}",
                        rf"{svg_image}",
                    ]
                )
                res_cache.write_bytes(image_hash)


if __name__ == "__main__":
    main()
    # typer.run(main)
