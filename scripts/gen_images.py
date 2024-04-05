import sys
import os
from pathlib import Path

sys.path.append(
    f"{os.environ.get('SN_DIR')}"
)  # just for the sake of using this script inside sponge_networks

from typing import Annotated, Any, Optional
from typing_extensions import override
import sponge_networks as sn
from sponge_networks.utils.utils import partial, do_multiple
import typer
import networkx as nx
import numpy as np

basic_network = sn.ResourceNetwork[int](
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

stop_network = sn.ResourceNetworkGreedy[int](
    nx.from_numpy_array(
        np.array(
            [
                [2, 0, 1, 0],
                [0, 3, 0, 4],
                [2, 2, 2, 5],
                [2, 3, 3, 3],
            ]
        ),
        create_using=nx.DiGraph,
    )
)


class WithEdges(sn.display.DrawableGraphWithContext[sn.display.JustDrawableContext]):
    @override
    def property_setter(self) -> None:
        G = self.drawing_graph
        G.graph["edge"]["fontcolor"] = "red"
        G.graph["edge"]["fontsize"] = self.display_context.scale * 12


# def with_red_weights(G: nx.DiGraph) -> None:


def write_img(images_folder: Path, concrete_path: Path | str, data: Any) -> None:
    p = images_folder / concrete_path
    ext = p.suffix[1:]
    p.parent.mkdir(parents=True, exist_ok=True)
    f = p.write_text if ext in ["svg"] else p.write_bytes
    f(data)


def create_all_images(images_folder: Path) -> None:
    write_to = partial(write_img, images_folder)

    def gen_1() -> None:
        img1 = basic_network.plot(scale=1.2, prop_setter=WithEdges)
        write_to("basic_network/plot.svg", img1.data)

        sim1 = basic_network.run_simulation([8, 1, 0], n_iters=1)
        img2 = basic_network.plot_with_states(sim1, max_node_width=0.3, scale=1.1)[0]
        write_to("basic_network/sim.svg", img2.data)

    def gen_2() -> None:
        sim = stop_network.run_simulation([4, 4, 0, 0], n_iters=10)
        imgs = stop_network.plot_with_states(sim.sliced[0, -1])
        write_to("stop_network/sim1.svg", imgs[0].data)
        write_to("stop_network/sim2.svg", imgs[-1].data)

    do_multiple(
        gen_1,
        gen_2,
    )()


def main(
    images_folder: Annotated[
        Optional[Path],
        typer.Argument(help="where to write"),
    ] = None
) -> None:
    wd = Path(os.environ.get("WORKDIR") or ".") / "assets/generated"
    images_folder = images_folder or wd
    images_folder.mkdir(parents=True, exist_ok=True)
    create_all_images(images_folder)


if __name__ == "__main__":
    typer.run(main)
