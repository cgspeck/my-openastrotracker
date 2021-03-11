include <common.scad>

module JSTSMPanelCutout(circuits=2, panel_thickness=1.4, clearance=clearance_tight, thickness_clearance=0) {
    // https://cdn-shop.adafruit.com/datasheets/JSTSM.pdf
    // indexed by circuit count starting at 0
    assert(circuits >= 2 && circuits <= 12);
    b_start_measure = panel_thickness < 1.0 ? 9.6 :
        panel_thickness > 1.5 ? 10 : 9.8;

    a_measure = 5.7 + (circuits - 2) * 2.5;
    b_measure = b_start_measure + (circuits - 2) * 2.5;
    thickness = panel_thickness + thickness_clearance;
    2clearance = clearance * 2;

    a_cube_dim = [
        a_measure + 2clearance,
        5.15 + 2clearance,
        thickness,
    ];

    b_cube_dim = [
        b_measure + 2clearance,
        4.15 + 2clearance,
        thickness,
    ];

    notch_cube_dim = [
        4.0 + 2clearance,
        5.15 + 1.6 + 2clearance,
        thickness
    ];

    cube(a_cube_dim, center=true);
    cube(b_cube_dim, center=true);
    translate([0,1.6/2,0]) cube(notch_cube_dim, center=true);
}

difference() {
    BlankFacePlate();
    panel_thickness=1.2;
    additional_padding=2-panel_thickness;
    translate([
        ext_transition_tran.x,
        ext_transition_tran.y,
        ext_transition_tran.z,
    ]) cube([
        ext_transition_dim.x-10,
        ext_transition_dim.y + (additional_padding * 2),
        ext_transition_dim.z-10
    ], center=true);

    translate([
        0,
        additional_padding + panel_thickness / 2,
        15
    ]) {
        translate([
            -40,
            0,
            5
        ]) {
            rotate([90,0,0]) JSTSMPanelCutout(4, panel_thickness=panel_thickness);
            translate([0,0,15]) rotate([90,0,0]) JSTSMPanelCutout(4, panel_thickness=panel_thickness);

            translate([
                25,
                0,
                0
            ]) {
                translate([0,0,0]) rotate([90,0,0]) JSTSMPanelCutout(5, panel_thickness=panel_thickness);
                translate([0,0,15]) rotate([90,0,0]) JSTSMPanelCutout(5, panel_thickness=panel_thickness);
            }
        }

        translate([
            25,
            0,
            5
        ]) {
            translate([0,0,15]) rotate([90,0,0]) JSTSMPanelCutout(6, panel_thickness=panel_thickness);
        }
    }

    // power
    translate([
        25,
        additional_padding + panel_thickness,
        15
    ]) {
        rotate([90,0,0]) cylinder_outer(panel_thickness, (8/2) + clearance_loose);
    }

    // fan switch
    translate([
        -28,
        additional_padding + panel_thickness,
        45
    ]) {
        rotate([90,0,0]) cylinder_outer(panel_thickness, (4.72/2) + clearance_loose);
    }
}
