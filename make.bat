set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"

md output

%OPENSCAD% -D base_texture="""plain""" -D base_w=25 -o output\base_25mm.png -q --autocenter circular_base.scad
%OPENSCAD% -D base_texture="""plain_horses""" -D base_w=30 -D base_w2=50 -o output\base_30x50mm.png -q --autocenter circular_base.scad
%OPENSCAD% -D base_texture="""plain""" -D base_w=20 -o output\base_20mm.stl -q --export-format binstl circular_base.scad
%OPENSCAD% -D base_texture="""plain""" -D base_w=25 -o output\base_25mm.stl -q --export-format binstl circular_base.scad
%OPENSCAD% -D base_texture="""plain""" -D base_w=32 -o output\base_30mm.stl -q --export-format binstl circular_base.scad
%OPENSCAD% -D base_texture="""plain""" -D base_w=32 -o output\base_32mm.stl -q --export-format binstl circular_base.scad
%OPENSCAD% -D base_texture="""plain""" -D base_w=40 -o output\base_40mm.stl -q --export-format binstl circular_base.scad
%OPENSCAD% -D base_texture="""plain""" -D base_w=50 -o output\base_50mm.stl -q --export-format binstl circular_base.scad
%OPENSCAD% -D base_texture="""plain_horses""" -D base_w=30 -D base_w2=50 -o output\base_30x50mm.stl -q --export-format binstl circular_base.scad


%OPENSCAD% -D base_texture="""bricks""" -D base_w=25 -o output\base_25mm_bricks.png -q --autocenter circular_base.scad
%OPENSCAD% -D base_texture="""bricks_horses""" -D base_w=30 -D base_w2=50 -o output\base_30x50mm_bricks.png -q --autocenter circular_base.scad
%OPENSCAD% -D base_texture="""bricks""" -D base_w=25 -o output\base_25mm_bricks.stl -q --export-format binstl circular_base.scad
%OPENSCAD% -D base_texture="""bricks_horses""" -D base_w=30 -D base_w2=50 -o output\base_30x50mm_bricks.stl -q --export-format binstl circular_base.scad


%OPENSCAD% -D base_texture="""plates""" -D base_w=25 -o output\base_25mm_plates.png -q --autocenter circular_base.scad
%OPENSCAD% -D base_texture="""plates""" -D base_w=25 -o output\base_25mm_plates.stl -q --export-format binstl circular_base.scad

%OPENSCAD% -D base_texture="""grill""" -D base_w=25 -o output\base_25mm_grill.png -q --autocenter circular_base.scad
%OPENSCAD% -D base_texture="""grill""" -D base_w=25 -o output\base_25mm_grill.stl -q --export-format binstl circular_base.scad

