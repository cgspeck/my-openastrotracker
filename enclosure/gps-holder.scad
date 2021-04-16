min_thickness=2.4;

overall_dim=[65, 37 + min_thickness, 8 + min_thickness * 2];
antenna_dim=[29,29,8];
chip_dim=[26.2, 37, 6];
chip_pin_dim=[20, 10, overall_dim.z];

difference() {
    cube(overall_dim);
    translate([0,0,min_thickness]) {
        translate([min_thickness, 0, 0]) {
            cube(antenna_dim);
        }

        translate([min_thickness + 10,0,0]) {
            cube([10, overall_dim.y, overall_dim.z]);
        }

        translate([min_thickness + antenna_dim.x + 5, 0, 0]) {
            cube(chip_dim);
            translate([(chip_dim.x - chip_pin_dim.x)/2,0,0]) cube(chip_pin_dim);
            translate([3,0,0]) cube([9, overall_dim.y, overall_dim.z]);
        }
    }
}
