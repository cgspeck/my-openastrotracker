use <MCAD/boxes.scad>
use <board-holder.scad>

fn=72*3;
$fn=fn;

de_minimus=0.01;
clearance_loose=0.4;
clearance_tight=0.2;

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

mega_and_screen_height=26.1;
pillar_height=3;
mega_rot=30;

min_thickness=2.4;

mega_case_dimensions=[
    mega_board_dimensions.x + 24 + 2 * min_thickness,
    mega_board_dimensions.y + 20 + min_thickness,
    mega_and_screen_height + pillar_height + 2 * min_thickness
];

mega_case_rot=[
    mega_rot,
    0,
    0
];

ext_transition_dim=[
    114,
    1.5,
    57
];
ext_transition_tran=[
    0,
    - ext_transition_dim.y / 2,
    57 / 2
];

module LCDButtonCutouts(mode="cutouts", z=5) {
    pts = [
        [0, 0],
        [8, 0],
        [17, 3.5],
        [17, -3.5],
        [26, 0],
        [34, 0],
    ];

    hole_dia=5.2;
    guide_dia=hole_dia + 2.4;


    translate([
        -17,
        0,
        0
    ]) {
        for (i=pts) {
            if (mode=="cutouts") {
                translate([
                    i.x,
                    i.y,
                    0
                ]) cylinder_outer(z, hole_dia/2);
            }
            if (mode=="guides") {
                translate([
                    i.x,
                    i.y,
                    0
                ]) cylinder_outer(z, guide_dia/2);
            }
        }
    }

}

module MegaWithLCDFrame(cutouts=false) {
    hole_pts=[
        [13.97, 2.54],
        [66.04, 7.62],
        [96.52, 2.54],
        [90.17, 50.8],
        [66.1, 35.5],
        [15.24, 50.8],
    ];

    fixing_holes=0;
    fixing_hole_distance=[10,10];
    frame_height=0;

    frame_total_height=frame_height+pillar_height;

    screen_pts = [
        [-8, 2.5+5.1+10],
        [14+1.3+50.8+24.1 - 1.5, 2.5+5.1+10],
        [14+1.3+50.8+24.1 - 1.5, 2.5+5.1+10 + 26],
        [-8,  2.5+5.1+10 + 26],
    ];

    pot_pt = [-8, 53.3+1, 0];
    translate([
        -mega_board_dimensions.x/2,
        -mega_board_dimensions.y/2,
        0
        ]) {
        BoardHolder6Pt(
            mega_board_dimensions,
            hole_pts,
            fixing_holes,
            fixing_hole_distance,
            frame_height=frame_height,
            pillar_height=pillar_height,
            mount_4_type="post"
        );

        if (cutouts) {
            translate([0, 0, frame_total_height]) {
                // screen
                linear_extrude(mega_and_screen_height) polygon(points=screen_pts);
                // brightness pot
                translate(pot_pt) cylinder_outer(mega_and_screen_height, 1.5);
                // usb port
                translate([
                    -20,
                    29-2.5,
                    0
                ]) cube([30,15,10]);
                // reset switch
                translate([
                    26,
                    0,
                    3
                ]) rotate([90,0,0]) cylinder_outer(20, 5/2);
            }
        }
    }

}

front_cube_dim=[
    mega_board_dimensions.x,
    mega_board_dimensions.y,
    min_thickness
];
front_cube_tran=[
    0,
    -(cos(mega_rot) * mega_board_dimensions.y) / 2,
    (sin(mega_rot) * mega_board_dimensions.y) / 2
];


module mega_lower_floor() {
    translate(front_cube_tran) rotate([mega_rot,0,0]) cube(front_cube_dim, center=true);
}

push_fit_tab_width=2;
push_fit_tab_height=10;

module push_fit_tab() {
    z = 10;
    xy_pts = [
        [0,0],
        [push_fit_tab_width, 0],
        [push_fit_tab_width, push_fit_tab_height],
        [-1.5, push_fit_tab_height-3.5],
        [0, push_fit_tab_height-3.5],
    ];
    echo(xy_pts);

    translate([
        0,
        z / 2,
        0
    ]) rotate([90,0,0]) linear_extrude(z) polygon(points=xy_pts);
}

module mega_ext_case(mode="lower_half") {
    mega_case_tran=[
        -mega_case_dimensions.x/2,
        -(cos(mega_rot) * mega_case_dimensions.y + 1 * min_thickness) - 20,
        (sin(mega_rot) * mega_case_dimensions.y + 0.75 * min_thickness) - mega_case_dimensions.z,
    ];

    case_position_tran=[
        0,
        -ext_transition_dim.y,
        0
    ];

    corner_rad=3;

    frame_tran = [
        mega_board_dimensions.x / 2 + 15,
        mega_board_dimensions.y / 2 + 2.4 + 5,
        2.3
    ];

    translate(mega_case_tran) {
        if (mode=="lower_half") {
            rotate(mega_case_rot) translate(case_position_tran) {
                difference() {
                    translate([
                        mega_case_dimensions.x / 2,
                        mega_case_dimensions.y / 2,
                        mega_case_dimensions.z / 2
                    ]) roundedBox(mega_case_dimensions, corner_rad, true);
                    echo("mega_case_dimensions", mega_case_dimensions);
                    internal_dim = [
                        mega_case_dimensions.x - 2*min_thickness,
                        mega_case_dimensions.y - 2*min_thickness,
                        mega_case_dimensions.z - min_thickness,
                    ];
                    translate([
                        internal_dim.x / 2 + min_thickness,
                        internal_dim.y / 2 + min_thickness,
                        internal_dim.z / 2 + min_thickness
                    ]) roundedBox(internal_dim, corner_rad, true);
                    //
                    /*
                    push-fit tab holes
                    z = 10;
                    push_fit_tab_width=2;
                    push_fit_tab_height=10;
                    3.5
                    */
                    push_fit_tab_z_tran=mega_case_dimensions.z - 10 + clearance_loose;
                    push_fit_tab_z_dim=3.5 + clearance_loose;
                    translate([
                        -30,
                        mega_case_dimensions.y /2 - 5 - clearance_loose,
                        push_fit_tab_z_tran
                    ]) cube([200, 10 + 2*clearance_loose, push_fit_tab_z_dim], center=false);
                    translate([
                        mega_case_dimensions.x / 2 - 5 - clearance_loose,
                        -10,
                        push_fit_tab_z_tran
                    ]) cube([10, 30 + 2*clearance_loose, push_fit_tab_z_dim], center=false);
                    translate(frame_tran) MegaWithLCDFrame("cutouts");
                }
                translate(frame_tran) MegaWithLCDFrame();
            }
        } else if (mode=="pad") {
            rotate(mega_case_rot) translate(case_position_tran) {
                mating_x = 60;
                translate([
                    (mega_case_dimensions.x * 2 - mating_x)  / 2,
                    mega_case_dimensions.y / 2,
                    mega_case_dimensions.z / 2
                ]) roundedBox([
                    mating_x,
                    mega_case_dimensions.y,
                    mega_case_dimensions.z
                ], corner_rad, true);
            }
        } else if (mode =="internal_area") {
            rotate(mega_case_rot) translate(case_position_tran) {
                    translate([
                        min_thickness,
                        min_thickness,
                        min_thickness
                    ]) cube([
                        mega_case_dimensions.x - 2*min_thickness,
                        mega_case_dimensions.y - 2*min_thickness,
                        mega_case_dimensions.z - min_thickness,
                    ], center=false);
            }
        } else if (mode=="lid") {
            button_tran_xy = [
                42,-20
            ];
            button_through_z=20;
            button_guide_z=5;
            difference() {
                union() {
                    lid_thickness=min_thickness;
                    // union() {
                        roundedBox([
                            mega_case_dimensions.x,
                            mega_case_dimensions.y,
                            lid_thickness
                        ], corner_rad, true);
                        // roundedBox([
                        //     mega_case_dimensions.x - 20,
                        //     mega_case_dimensions.y - 20,
                        //     lid_thickness
                        // ], corner_rad, true);
                    // }
                    translate([
                        -mega_case_dimensions.x  / 2 + min_thickness + clearance_loose,
                        0,
                        lid_thickness/2
                    ]) push_fit_tab();
                    translate([
                        mega_case_dimensions.x  / 2 - min_thickness - clearance_loose,
                        0,
                        lid_thickness/2
                    ]) rotate([0,0,180]) push_fit_tab();
                    translate([
                        0,
                        -mega_case_dimensions.y  / 2 + min_thickness + clearance_loose,
                        lid_thickness/2
                    ]) rotate([0,0,90]) push_fit_tab();
                    // lugs
                    lug_height=3;
                    lug_xy=10;
                    translate([
                        0,
                        0,
                        2.6
                    ]) difference() {
                            roundedBox([
                            mega_case_dimensions.x - 2 * min_thickness - clearance_loose * 2,
                            mega_case_dimensions.y - 2 * min_thickness - clearance_loose * 2,
                            lug_height
                        ], corner_rad, true);
                        cube([
                            mega_case_dimensions.x - lug_xy * 2,
                            mega_case_dimensions.y,
                            lug_height
                        ], center=true);
                        cube([
                            mega_case_dimensions.x,
                            mega_case_dimensions.y- lug_xy * 2,
                            lug_height
                        ], center=true);
                    }
                    // button guides
                    // button cutouts
                    translate([
                        button_tran_xy.x,
                        button_tran_xy.y,
                        -min_thickness / 2 + min_thickness - de_minimus
                    ]) LCDButtonCutouts("guides", z=button_guide_z);
                }
            // the mega screen and brightness adjuster
            translate([0,0,25]) mirror([0,0,0]) rotate([0,180,0]) MegaWithLCDFrame(cutouts=true);
            // button cutouts
            translate([
                button_tran_xy.x,
                button_tran_xy.y,
                -min_thickness - 3
            ]) LCDButtonCutouts(z=button_through_z);
            }
        }
    }
}

translate([
    65,
    -50,
    0
]) mega_ext_case("lid");

module 40mm_fan_cutout(length=10) {
    holes_dz=32;
    holes_dx=32;
    holes_dia=4 + clearance_loose;

    fan_max_dia=38;
    fan_min_dia=12;

    rot =[
        90,
        0,
        0
    ];

    translate([
        0,
        length/2,
        0
    ]) {
        translate([
            0,
            0,
            holes_dz / 2
        ]) {
            translate([
                holes_dx / 2,
                0,
                0
            ]) rotate(rot) cylinder_outer(length, holes_dia/2);
            translate([
                -holes_dx / 2,
                0,
                0
            ]) rotate(rot) cylinder_outer(length, holes_dia/2);
        }

        translate([
            0,
            0,
            -holes_dz / 2
        ]) {
            translate([
                holes_dx / 2,
                0,
                0
            ]) rotate(rot) cylinder_outer(length, holes_dia/2);
            translate([
                -holes_dx / 2,
                0,
                0
            ]) rotate(rot) cylinder_outer(length, holes_dia/2);
        }

        difference() {
            rotate(rot) cylinder_outer(length, fan_max_dia/2);
            rotate(rot) cylinder_outer(length, fan_min_dia/2);

            segments = 8;
            rot_fact = 360 / segments;
            translate([
                0,
                -length / 2,
                0
            ]) for (i=[0:segments-1]) {
                echo(str("i =", i));
                echo(str("rot_fact * i =", rot_fact * i));
                rotate([
                    0,
                    rot_fact * i,
                    0
                ]) cube([
                    min_thickness,
                    length,
                    40
                ], center=true);
            }

        }
    }
}

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

int_transition_dim=[
    119.6,
    2,
    min_thickness
];
int_transition_tran=[
    0,
    int_transition_dim.y + transition_floor_dim.y / 2,
    min_thickness / 2
];

module int_tran_floor() {
    translate(int_transition_tran) cube(int_transition_dim, center=true);
}

module ext_tran_shield() {
    translate(ext_transition_tran) cube(ext_transition_dim, center=true);
}

module ext_tran_pad() {
    resize_x=40;
    translate([
        ext_transition_tran.x + resize_x,
        ext_transition_tran.y - ext_transition_dim.y / 2 + de_minimus / 2,
        ext_transition_tran.z
    ]) cube([
        resize_x,
        de_minimus,
        ext_transition_dim.z,
    ], center=true);
}


difference() {
    // shield, external interface, bridge and case
    union() {
        mega_ext_case();
        translate(transition_wedge_tran) cube(transition_wedge_dim, center=true);
        ext_tran_shield();
        difference() {
            hull() {
                ext_tran_pad();
                mega_ext_case("pad");
            }
            mega_ext_case("internal_area");
        }
    }
    // internal tunnel
    translate([
        35,
        10,
        38
    ]) rotate([
        80,
        0,
        0
    ]) cylinder_outer(90, 11);
    // fan mount

    translate([
        -25,
        0,
        35
    ]) 40mm_fan_cutout();
}


case_front_holes_t_y=2+16;
case_holes_dx=80;
case_rear_holes_t_y=2+16+60;
case_hole_dim=2;

module rhs_case_holes(cutouts_only=false, front=true, rear=true) {
    t1 = [
        case_holes_dx/2,
        case_rear_holes_t_y,
        min_thickness / 2
    ];
    t2 = [
        case_holes_dx/2,
        case_front_holes_t_y,
        min_thickness / 2
    ];
    if (cutouts_only) {
        translate(t1) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
        translate(t2) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
    } else {
        if (front) {
            translate(t2) cylinder_outer(min_thickness, case_hole_dim * 2, center=true);
        }
        if (rear) {
            translate(t1) cylinder_outer(min_thickness, case_hole_dim * 2, center=true);
        }
    }
}

module lhs_case_holes(cutouts_only=false, front=true, rear=true) {
    t1 = [
        -case_holes_dx/2,
        case_rear_holes_t_y,
        min_thickness / 2
    ];
    t2 = [
        -case_holes_dx/2,
        case_front_holes_t_y,
        min_thickness / 2
    ];
    if (cutouts_only) {
        translate(t1) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
        translate(t2) cylinder_outer(min_thickness, case_hole_dim/2, center=true);
    } else {
        if (front) {
            translate(t2) cylinder_outer(min_thickness, case_hole_dim * 2, center=true);
        }
        if (rear) {
            translate(t1) cylinder_outer(min_thickness, case_hole_dim * 2, center=true);
        }
    }
}

difference() {
    union() {
        multiHull() {
            rhs_case_holes();
        }

        multiHull() {
            lhs_case_holes();
        }

        multiHull() {
            int_tran_floor();
            rhs_case_holes(rear=false);
            lhs_case_holes(rear=false);
        }
    }
    lhs_case_holes(true);
    rhs_case_holes(true);
}

!union() {
    rotate([
        -mega_case_rot.x,
        mega_case_rot.y,
        mega_case_rot.z
    ]) mega_ext_case();

    mega_ext_case("lid");
}


