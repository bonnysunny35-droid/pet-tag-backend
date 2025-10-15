import os, subprocess
from pathlib import Path

TEMPLATE = Path(__file__).parent / "tag_template.scad"

OPENSCAD = os.environ.get("OPENSCAD_BIN", "openscad")
XVFB = os.environ.get("XVFB_BIN", "xvfb-run")

def render_stl(
    out_path: str,
    name_text: str = "BELLA",
    tag_shape: str = "circle",
    tag_diam: int = 35,
    thickness: float = 2.5,
    hole_diam: float = 4.0,
    text_height: float = 0.8,
    font: str = "DejaVu Sans:style=Bold",
):
    args = [
        XVFB, "-a", OPENSCAD,
        "-o", out_path,
        "-D", f'name_text="{name_text}"',
        "-D", f'tag_shape="{tag_shape}"',
        "-D", f"tag_diam={tag_diam}",
        "-D", f"thickness={thickness}",
        "-D", f"hole_diam={hole_diam}",
        "-D", f"text_height={text_height}",
        "-D", f'font="{font}"',
        str(TEMPLATE),
    ]
    subprocess.check_call(args)
    return out_path
