plate_dim_outer=[
    122,
    64,
    1.8
];

plate_dim_inner=[
    114,
    57,
    2.6
];

module Plate() {
    cube(plate_dim_outer, center=true);
    translate([0,0, plate_dim_inner.z - plate_dim_outer.z]) cube(plate_dim_inner, center=true);
}

module LCDShield(punchouts=false) {
    // standoffs for the screen
    lc
}
Plate();
