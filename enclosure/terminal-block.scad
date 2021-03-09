include <MCAD/nuts_and_bolts.scad>

fn=72*3;
$fn=fn;

module cylinder_outer(height,radius,fn=fn)
{
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

module TerminalBlock(
    terminal_count=1,
    terminal_width=10,
    nut_section_height=METRIC_NUT_THICKNESS[3] * 1.5,
    bridge_section_height=2.4,
    ridge_width=1.2,
    ridge_height=4,
    base_only=false,
    ridge=true,
    cutout_only=false,
    clearance_loose=0.4,
    de_minimus=0.01
    )
{
    full_height=nut_section_height+bridge_section_height;
    full_length=terminal_count * terminal_width + (terminal_count - 1) * ridge_width;
    term_cube_dim=[terminal_width,terminal_width,full_height];

    difference() {
        union() {
            if (!cutout_only) {
                cube([
                    full_length,
                    terminal_width,
                    full_height
                ]);
            }

            if (ridge && !base_only && !cutout_only) {
                for (i=[1:terminal_count])
                {
                    start_x = (i - 1) * (terminal_width + ridge_width);
                    ridge_x = start_x - ridge_width;
                    translate([start_x, 0, 0])
                    {
                        if (i > 1)
                        {
                            translate([
                                - ridge_width,
                                0,
                                0
                            ]) cube([
                                ridge_width,
                                terminal_width,
                                full_height + ridge_height
                            ]);
                        }
                    }
                }
            }
        }

        if (cutout_only ||  !base_only) {
            for (i=[1:terminal_count])
            {
                start_x = (i - 1) * (terminal_width + ridge_width);
                ridge_x = start_x - ridge_width;
                nut_tran=[
                    term_cube_dim.x / 2,
                    term_cube_dim.y / 2,
                    0
                ];
                translate([start_x, 0, 0])
                {
                    translate(nut_tran)
                    {
                        nutHole(3);
                        cylinder_outer(full_height + de_minimus, (3 + clearance_loose) / 2);
                    }
                }
            }
        }
    }


}

TerminalBlock();

translate([0,20,0]) TerminalBlock(2);

translate([0,40,0]) TerminalBlock(4);

translate([0,60,0]) TerminalBlock(4, base_only=true, ridge=false, cutout_only=false);

translate([0,80,0]) TerminalBlock(4, base_only=true, ridge=true, cutout_only=false);

translate([0,100,0]) TerminalBlock(4, base_only=false, ridge=true, cutout_only=true);




