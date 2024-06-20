from copy import copy, deepcopy
from dataclasses import asdict, dataclass, field
import multiprocessing
import sys
import os
from pathlib import Path

sys.path.append(
    f"{os.environ.get('SN_DIR')}"
)  # just for the sake of using this script inside sponge_networks

from typing import Annotated, Any, Callable, Optional, Self, TypedDict
from typing_extensions import override
import sponge_networks as sn
from sponge_networks.utils.utils import do_multiple
from sponge_networks.display import DrawableGraph, scale_graph_pos
from functools import partial
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


@dataclass
class TypicalProperties:
    n_cols: int = 4
    n_rows: int = 2
    layout: sn.sponge_networks._LayoutDict = field(
        default_factory=lambda: {
            "weights_horizontal": 3,
            "weights_up_down": 5,
            "weights_down_up": 1,
            "weights_loop": 1,
            "weights_sink_edge": 1,
            "generate_sinks": True,
        }
    )
    visual_sink_edge_length: float = 0.7


typical_properties = asdict(TypicalProperties())


def build_typical(overrides: dict) -> sn.SpongeNetwork[sn.sponge_networks.SpongeNode]:
    it = deepcopy(typical_properties)
    sn.utils.utils.set_object_property_nested(it, overrides, priority="right")
    return sn.build_sponge_network(**it)


some_sponge_network = build_typical({"grid_type": "grid_2d"})
some_sponge_network_without_sinks = build_typical(
    {"grid_type": "grid_2d", "layout": {"generate_sinks": False}}
)


@dataclass
class FontPos(sn.display.JustDrawableConfig):
    fontsize: Optional[float] = None
    scale_graph_pos_factor: Optional[float] = None

    @override
    def property_setter(self, drawable: DrawableGraph) -> None:
        G = drawable.drawing_graph
        if self.fontsize:
            G.graph["node"]["fontsize"] = self.fontsize
            G.graph["edge"]["fontsize"] = self.fontsize
        if self.scale_graph_pos_factor:
            scale_graph_pos(G, self.scale_graph_pos_factor)

    @override
    @classmethod
    def generate_default_config(cls) -> Self:
        sdi = sn.display.JustDrawableConfig.default_instance()
        return cls(
            fontsize=None,
            scale_graph_pos_factor=None,
            **(asdict(sdi)),
        )


@dataclass
class FontPosSim(sn.display.SimulationWithChangingWidthConfig):
    fontsize: Optional[float] = None
    scale_graph_pos_factor: Optional[float] = None

    @override
    def property_setter(self, drawable: DrawableGraph) -> None:
        G = drawable.drawing_graph
        if self.fontsize:
            G.graph["node"]["fontsize"] = self.fontsize
            G.graph["edge"]["fontsize"] = self.fontsize
        if self.scale_graph_pos_factor:
            scale_graph_pos(G, self.scale_graph_pos_factor)

    @override
    @classmethod
    def generate_default_config(cls) -> Self:
        sdi = sn.display.SimulationWithChangingWidthConfig.default_instance()
        return cls(
            fontsize=None,
            scale_graph_pos_factor=None,
            **(asdict(sdi)),
        )


def process_all_generation(funcs: list[Callable[[], None]]) -> None:
    n_pools = min(os.cpu_count() or 1, len(funcs))
    pool_obj = multiprocessing.Pool(n_pools)
    pool_obj.map(lambda f: f(), funcs)


def write_img(images_folder: Path, concrete_path: Path | str, data: Any) -> None:
    p = images_folder / concrete_path
    ext = p.suffix[1:]
    p.parent.mkdir(parents=True, exist_ok=True)
    f = p.write_text if ext in ["svg"] else p.write_bytes
    f(data)


def create_all_images(images_folder: Path) -> None:
    write_to = partial(write_img, images_folder)

    def gen_1() -> None:
        img1 = basic_network.plot(
            scale=1.0,
            prop_setter=FontPos(
                fontsize=17,
                scale_graph_pos_factor=0.4,
            ),
        )
        write_to("basic_network/plot.svg", img1.data)

        sim1 = basic_network.run_simulation([8, 1, 0], n_iters=1)
        img2 = basic_network.plot_with_states(
            sim1,
            max_node_width=0.6,
            scale=1.0,
            prop_setter=FontPosSim(
                fontsize=15,
                scale_graph_pos_factor=0.9,
            ),
        )[0]
        write_to("basic_network/sim.svg", img2.data)

    def gen_2() -> None:
        sim = stop_network.run_simulation([4, 4, 0, 0], n_iters=10)
        imgs = stop_network.plot_with_states(
            sim.sliced[0, -1],
            prop_setter=FontPosSim(fontsize=13, scale_graph_pos_factor=0.9),
        )
        write_to("stop_network/sim1.svg", imgs[0].data)
        write_to("stop_network/sim2.svg", imgs[-1].data)

    def gen_3() -> None:
        img = some_sponge_network.resource_network.plot(
            scale=1.5, prop_setter=FontPos(fontsize=15.5)
        )
        write_to("some_sponge_network/plot.svg", img.data)

    def gen_4() -> None:
        img = some_sponge_network_without_sinks.resource_network.plot(
            scale=1.5, prop_setter=FontPos(fontsize=15.5)
        )
        write_to("some_sponge_network_without_sinks/plot.svg", img.data)

    def gen_5() -> None:
        img = some_sponge_network_without_sinks.resource_network.plot(
            scale=1.4, prop_setter=partial(scale_graph_pos, scale=0.8)
        )
        write_to("some_sponge_network_without_sinks2/plot.svg", img.data)

    def gen_6() -> None:
        nw_triangular = build_typical(
            {"grid_type": "triangular", "n_cols": 5, "n_rows": 3}
        )
        img = nw_triangular.resource_network.plot(
            scale=1.5,
            prop_setter=FontPos(
                fontsize=14,
                scale_graph_pos_factor=0.8,
            ),
        )
        write_to("network_types_example/triangular.svg", img.data)

        nw_hexagonal = build_typical(
            {"grid_type": "hexagonal", "n_cols": 4, "n_rows": 2}
        )
        img = nw_hexagonal.resource_network.plot(
            scale=1.5,
            prop_setter=FontPos(
                fontsize=18,
                scale_graph_pos_factor=0.8,
            ),
        )
        write_to("network_types_example/hexagonal.svg", img.data)

    def gen_7() -> None:
        nw_triangular = build_typical(
            {"grid_type": "triangular", "n_cols": 4, "n_rows": 2}
        )
        img = nw_triangular.resource_network.plot(
            scale=1.4,
            prop_setter=FontPos(
                fontsize=14,
                scale_graph_pos_factor=0.8,
            ),
        )
        write_to("network_types_example_sym/triangular.svg", img.data)

        nw_hexagonal = build_typical(
            {"grid_type": "hexagonal", "n_cols": 3, "n_rows": 2}
        )
        img = nw_hexagonal.resource_network.plot(
            scale=1.5,
            prop_setter=FontPos(
                fontsize=14.5,
                scale_graph_pos_factor=0.8,
            ),
        )
        write_to("network_types_example_sym/hexagonal.svg", img.data)

        nw_triangular_single = build_typical(
            {"grid_type": "triangular", "n_cols": 1, "n_rows": 5}
        )
        img = nw_triangular_single.resource_network.plot(
            scale=1.4,
            prop_setter=FontPos(
                fontsize=14,
                scale_graph_pos_factor=0.8,
            ),
        )
        write_to("network_types_example_sym/triangular_single.svg", img.data)

    def gen_8() -> None:
        nw = build_typical({"grid_type": "triangular", "n_cols": 6, "n_rows": 2})
        qn = sn.QuotientSpongeNetwork(nw, [[(0, 1), (3, 0)]])
        sim_q = qn.quotient_sponge_network.run_sponge_simulation(
            [0, 30, 0, 0], n_iters=2
        )
        imgs = qn.quotient_network.plot_with_states(
            sim_q,
            scale=1.2,
            prop_setter=FontPosSim(
                fontsize=14,
                scale_graph_pos_factor=0.9,
            ),
            max_node_width=0.7,
        )
        write_to("qn_1/1.svg", imgs[0].data)
        write_to("qn_1/2.svg", imgs[1].data)

    def gen_9() -> None:
        nw = build_typical({"grid_type": "triangular", "n_cols": 6, "n_rows": 2})
        qn = sn.quotient_sponge_network_on_cylinder(nw)

        img = qn.quotient_network.plot(scale=1.2, prop_setter=FontPos(fontsize=14))
        write_to("cylinder_triangular_1/plot.svg", img.data)

        sim_q = qn.quotient_sponge_network.run_sponge_simulation(
            [10, 10, 10], n_iters=7
        )
        first_and_last = sim_q.sliced[0, -1]
        imgs = qn.quotient_network.plot_with_states(
            first_and_last,
            scale=1.2,
            prop_setter=FontPosSim(fontsize=14),
            max_node_width=1,
        )
        write_to("cylinder_triangular_1/1.svg", imgs[0].data)
        write_to("cylinder_triangular_1/2.svg", imgs[1].data)

    def gen_10() -> None:
        nw = build_typical({"grid_type": "triangular", "n_cols": 5, "n_rows": 2})
        qn = sn.quotient_sponge_network_on_cylinder(nw)

        img = qn.quotient_network.plot(scale=1.35, prop_setter=FontPos(fontsize=14))
        write_to("cylinder_triangular_2/plot.svg", img.data)

    def gen_11() -> None:
        nw = sn.ResourceNetwork[int](
            nx.from_numpy_array(
                np.array(
                    [
                        [0, 3, 1],
                        [4, 0, 0],
                        [2, 0, 0],
                    ]
                ),
                create_using=nx.DiGraph,
            )
        )
        write_to("noninjective_network/plot.svg", nw.plot(scale=2.0).data)

    def gen_12() -> None:
        nw = sn.build_sponge_network(
            grid_type="grid_2d",
            n_cols=4,
            n_rows=2,
            layout={
                "weights_sink_edge": 1,
                "weights_loop": 1,
                "weights_horizontal": 2,
                "weights_up_down": 5,
                "weights_down_up": 1,
                "generate_sinks": True,
            },
            visual_sink_edge_length=0.7,
        )
        sim = nw.run_sponge_simulation([8, 20, 0, 20, 8])
        sim_ = sim.sliced[0, 4]
        imgs = nw.resource_network.plot_with_states(sim_, scale=1.4)
        write_to("sponge_symmetrical_sim/1.svg", imgs[0].data)
        write_to("sponge_symmetrical_sim/2.svg", imgs[1].data)

    def gen_13() -> None:
        nw = sn.build_sponge_network(
            grid_type="grid_2d",
            n_cols=6,
            n_rows=3,
            layout={
                "weights_sink_edge": 1,
                "weights_loop": 1,
                "weights_horizontal": 2,
                "weights_up_down": 5,
                "weights_down_up": 1,
                "generate_sinks": True,
            },
            visual_sink_edge_length=1,
        )

        qn = sn.quotient_sponge_network_on_cylinder(nw)
        sim_q = qn.quotient_sponge_network.run_sponge_simulation([12, 0, 12, 0, 12, 0])
        sim_ = sim_q.sliced[0, 3]
        imgs = qn.quotient_network.plot_with_states(
            sim_,
            scale=1.4,
            prop_setter=FontPosSim(fontsize=13.5, scale_graph_pos_factor=0.7),
        )
        write_to("sponge_symmetrical_2_sim/1.svg", imgs[0].data)
        write_to("sponge_symmetrical_2_sim/2.svg", imgs[1].data)

    do_multiple(
        gen_1,
        # gen_2,
        # gen_3,
        # gen_4,
        # gen_5,
        # gen_6,
        # gen_7,
        # gen_8,
        # gen_9,
        # gen_10,
        # gen_11,
        # gen_12,
        # gen_13,
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
