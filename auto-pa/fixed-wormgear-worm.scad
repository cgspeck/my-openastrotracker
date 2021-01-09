
fn=72*4;
$fn=fn;

clearance_loose=0.4;
clearance_tight=0.2;

de_minimus=0.01;

module cylinder_outer(height,radius,fn=fn) {
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}

base_height=6;

module ReplacementBaseSolid() {
    cylinder_outer(base_height, 8);
}

module GoodPartMask() {
    translate([0, 0, base_height]) cylinder_outer(100, 100);
}

screw_shaft_tran_y=3;
module ScrewShaftCutout() {
    cutout_len = 60;
    translate([0, cutout_len / 2, screw_shaft_tran_y]) {
        rotate([90, 0, 0]) {
            cylinder_outer(cutout_len, 1.5+clearance_tight);
        }
    }
}

module StepperShaftCutout() {
    x=5 + clearance_tight;
    y=3 + clearance_tight;
    z=6+2 + clearance_tight;
    translate([0,0,z/2]) cube([x, y, z], center=true);
}

module 3SNutCutout() {
    x=5.4 + 2 * clearance_tight;
    y=1.8 + 2 * clearance_tight;
    z=5.4 + 0.4 + (screw_shaft_tran_y / 2);
    translate([-x / 2, -y / 2 ,0]) cube([x, y, z]);
}

nut_cutout_tran_y=4.5;

module GoodPartofWormGear() {
    intersection() {
        import("Alt_wormgear_worm.stl");
        GoodPartMask();
    }
}


GoodPartofWormGear();

difference() {
    ReplacementBaseSolid();
    ScrewShaftCutout();
    StepperShaftCutout();
    translate([0, nut_cutout_tran_y, 0]) {
        3SNutCutout();
    }
    translate([0, -nut_cutout_tran_y, 0]) {
        3SNutCutout();
    }
}

