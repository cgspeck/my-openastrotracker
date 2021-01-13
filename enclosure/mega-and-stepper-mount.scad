use <board-holder.scad>

fn=72*3;
$fn=fn;

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


mega_board_dimensions=[
    101.6,
    53.3
];

mega_rot=30;

min_thickness=2.4;

module MegaWithLCDFrame(cutouts=false) {
    hole_pts=[
        [14+1.3, 2.5],
        [14+1.3+50.8, 2.5+5.1],
        [14+1.3+50.8+24.1+10, 2.5],
        [14+1.3+50.8+24.1, 2.5+5.1+27.9+15.2],
        [14+1.3+50.8, 2.5+5.1+27.9],
        [14+1.3, 2.5+5.1+27.9+15.2],
    ];

    fixing_holes=0;
    fixing_hole_distance=[10,10];
    frame_height=6;
    pillar_height=3;
    frame_total_height=frame_height+pillar_height;

    screen_pts = [
        [-8, 2.5+5.1+10],
        [14+1.3+50.8+24.1 - 1.5, 2.5+5.1+10],
        [14+1.3+50.8+24.1 - 1.5, 2.5+5.1+10 + 26],
        [-8,  2.5+5.1+10 + 26],
    ];
    screen_height=26.1;

    pot_pt = [-8, 53.3+1, 0];
    translate([-mega_board_dimensions.x/2, -mega_board_dimensions.y/2, 0]) {
        BoardHolder6Pt(
            mega_board_dimensions,
            hole_pts,
            fixing_holes,
            fixing_hole_distance,
            frame_height=frame_height,
            pillar_height=pillar_height
        );

        if (cutouts) {
            translate([0, 0, frame_total_height]) {
                linear_extrude(screen_height) polygon(points=screen_pts);
                translate(pot_pt) cylinder_outer(screen_height, .75);
            }
        }
    }

}

mega_frame_tran=[
    0,
    -(cos(mega_rot) * mega_board_dimensions.y) / 2,
    // Sine = Opposite / Hypotenuse
    (sin(mega_rot) * mega_board_dimensions.y) / 2,
];

front_cube_dim=[
    114,
    cos(mega_rot) * mega_board_dimensions.y,
    min_thickness
];
front_cube_tran=[
    0,
    -front_cube_dim.y / 2,
    0
];


translate(mega_frame_tran) rotate([mega_rot,0,0]) MegaWithLCDFrame();
translate(front_cube_tran) cube(front_cube_dim, center=true);

transition_floor_dim=[
    121.5,
    2,
    min_thickness
];
transition_floor_tran=[
    0,
    transition_floor_dim.y / 2,
    0
];

translate(transition_floor_tran) cube(transition_floor_dim, center=true);

case_front_holes_t_y=2+16;
case_holes_dx=80;
case_rear_holes_t_y=2+16+60;
case_hole_dim=2;

module rhs_case_holes(cutouts_only=false) {
    t1 = [
        case_holes_dx/2,
        case_rear_holes_t_y,
        0
    ];
    t2 = [
        case_holes_dx/2,
        case_front_holes_t_y,
        0
    ];
    if (cutouts_only) {
        translate(t1) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
        translate(t2) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
    } else {
        translate(t1) cylinder_outer(min_thickness, case_hole_dim, center=true);
        translate(t2) cylinder_outer(min_thickness, case_hole_dim, center=true);
    }
}

module lhs_case_holes(cutouts_only=false) {
    t1 = [
        -case_holes_dx/2,
        case_rear_holes_t_y,
        0
    ];
    t2 = [
        -case_holes_dx/2,
        case_front_holes_t_y,
        0
    ];
    if (cutouts_only) {
        translate(t1) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
        translate(t2) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
    } else {
        translate(t1) cylinder_outer(min_thickness, case_hole_dim, center=true);
        translate(t2) cylinder_outer(min_thickness, case_hole_dim, center=true);
    }
}

difference() {
    multiHull() {
        rhs_case_holes();
    }
    rhs_case_holes(true);
}

difference() {
    multiHull() {
        lhs_case_holes();
    }
    lhs_case_holes(true);
}

