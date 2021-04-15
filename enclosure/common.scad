fn=72*3;
$fn=fn;

de_minimus=0.01;
clearance_loose=0.4;
clearance_tight=0.2;
corner_rad=3;
tran_wedge_x_tran=3.4;
tran_wedge_y_tran=2.8;

// 248 top/bottom
// 250 flare in middle

transition_wedge_dim=[
    248/2,
    2.4,
    75
];

ext_transition_dim=[
    transition_wedge_dim.x - tran_wedge_x_tran * 2,
    4.5,
    transition_wedge_dim.z - tran_wedge_y_tran * 2
];

ext_transition_tran=[
    0,
    - ext_transition_dim.y / 2,
    ext_transition_dim.z / 2 + tran_wedge_y_tran
];

transition_wedge_tran=[
    0,
    transition_wedge_dim.y / 2,
    transition_wedge_dim.z / 2
];

faceplate_pillar_tran=[
    0,
    0,
    -7.6
];

module cylinder_outer(height,radius,center=false, fn=fn){
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge, center=center);
}

module doughnut(height,outer_radius,inner_radius,center=true, fn=fn){
    difference() {
        cylinder_outer(height,outer_radius,center=center);
        cylinder_outer(height,inner_radius,center=center);
    }
}

module multiHull(){
    for (i = [1 : $children-1]) {
        hull(){
            children(0);
            children(i);
        }
    }
}

module BlankFacePlate(overlap=false) {
    overlap_adj_x = overlap ?
        tran_wedge_x_tran * 2 - clearance_loose:
        0;

    translate(faceplate_pillar_tran) {
        translate(transition_wedge_tran) cube(transition_wedge_dim, center=true);
        translate([
            ext_transition_tran.x + (overlap_adj_x / 2),
            ext_transition_tran.y,
            ext_transition_tran.z
        ]) cube([
            ext_transition_dim.x + overlap_adj_x,
            ext_transition_dim.y,
            ext_transition_dim.z
        ], center=true);
    }
}
