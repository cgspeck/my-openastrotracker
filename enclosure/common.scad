fn=72*3;
$fn=fn;

de_minimus=0.01;
clearance_loose=0.4;
clearance_tight=0.2;
corner_rad=3;

ext_transition_dim=[
    114,
    3,
    57
];

ext_transition_tran=[
    0,
    - ext_transition_dim.y / 2,
    57 / 2
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

module BlankFacePlate() {
    transition_wedge_dim=[
        121.5,
        2,
        64
    ];
    transition_wedge_tran=[
        0,
        transition_wedge_dim.y / 2,
        transition_wedge_dim.z / 2 - 3
    ];
    translate(transition_wedge_tran) cube(transition_wedge_dim, center=true);
    translate(ext_transition_tran) cube(ext_transition_dim, center=true);
}
