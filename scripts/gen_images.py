import os
from typing import Annotated, Any, Optional
import sponge_networks as sn
import typer
import networkx as nx
import numpy as np
from pathlib import Path

basic_network = sn.ResourceNetwork(
    nx.from_numpy_array(
        np.array(
            [
                [0, 3, 1],
                [4, 1, 0],
                [2, 2, 0],
            ]
        ),
        create_using=nx.DiGraph,
    )
)


def with_red_weights(G: nx.DiGraph) -> None:
    G.graph["edge"]["fontcolor"] = "red"


def write_img(p: Path, data: Any) -> None:
    ext = p.suffix[1:]
    p.parent.mkdir(parents=True, exist_ok=True)
    f = p.write_text if ext in ["svg"] else p.write_bytes
    f(data)


def create_all_images(images_folder: Path) -> None:
    img = basic_network.plot(scale=1.2, prop_setter=with_red_weights)
    write_img(images_folder.joinpath("basic_network/plot.svg"), img.data)


def main(
    images_folder: Annotated[
        Optional[Path],
        typer.Argument(help="where to write"),
    ] = None
) -> None:
    wd = os.environ.get("WORKDIR") or "./assets/images"
    images_folder = images_folder or Path(wd)
    images_folder.mkdir(parents=True, exist_ok=True)
    create_all_images(images_folder)


if __name__ == "__main__":
    typer.run(main)
