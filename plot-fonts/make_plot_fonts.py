"""Make the KaTeX fonts used for maths in the book's plots (see tex-labels.R).

KaTeX's letters are small for their point size: the x-height of KaTeX_Main and
KaTeX_Math is about 0.44 em, against 0.53 em for Fira Sans, the plots' text
font. Plotmath can't change size within a label, so these copies are scaled up
by 1.2 instead, by lowering unitsPerEm from 1000 to 833. Hinting is removed, as
its instructions were written for the original unitsPerEm.

Usage (needs fontTools): python3 make_plot_fonts.py <dir with KaTeX .ttf files>
e.g. /usr/share/fonts/truetype/katex from the Debian/Ubuntu package fonts-katex.
The KaTeX fonts are MIT licensed (LICENSE-KaTeX.txt).
"""

import sys
from pathlib import Path

from fontTools.ttLib import TTFont
from fontTools.ttLib.tables import ttProgram

SCALE = 1.2
FONTS = ["KaTeX_Main-Regular", "KaTeX_Math-Italic", "KaTeX_Math-BoldItalic"]

src = Path(sys.argv[1])
out = Path(__file__).parent
for name in FONTS:
    font = TTFont(src / f"{name}.ttf")
    font["head"].unitsPerEm = round(font["head"].unitsPerEm / SCALE)
    for table in ("fpgm", "prep", "cvt "):
        if table in font:
            del font[table]
    for glyph in font["glyf"].glyphs.values():
        if hasattr(glyph, "program"):
            glyph.program = ttProgram.Program()
            glyph.program.fromBytecode(b"")
    # A family name of its own, so it can't be confused with the installed fonts
    family, style = name.split("-")
    for record in font["name"].names:
        if record.nameID in (1, 4, 16):
            record.string = record.toUnicode().replace(family, f"{family}_Plot")
    font.save(out / f"{family}_Plot-{style}.ttf")
