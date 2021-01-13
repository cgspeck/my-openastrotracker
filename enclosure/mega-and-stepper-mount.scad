use <board-holder.scad>

fn=72*3;
$fn=fn;

module cylinder_outer(height,radius,center=false, fn=fn){
    fudge = 1/cos(180/fn);
    cylinder(h=height,r=radius*fudge, center=center);
}

module MegaFrame() {
    board_dimensions=[
        101.6,
        53.3
    ];
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
    BoardHolder6Pt(
        board_dimensions,
        hole_pts,
        fixing_holes,
        fixing_hole_distance
    );

    screen_pts = [
        [-8, 2.5+5.1+10],
        [14+1.3+50.8+24.1 - 1.5, 2.5+5.1+10],
        [14+1.3+50.8+24.1 - 1.5, 2.5+5.1+10 + 26],
        [-8,  2.5+5.1+10 + 26],
    ];
    linear_extrude(60) polygon(points=screen_pts);
    pot_pt = [-8, 53.3+1, 0];

    translate(pot_pt) cylinder_outer(60, .75);

}

MegaFrame();
