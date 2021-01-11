use <board-holder.scad>


module MegaFrame() {
    board_dimensions=[
        101.6,
        53.3
    ];
    hole_pts=[
        [14+1.3, 2.6],
        [14+1.3+50.8+24.1, 2.6],
        [14+1.3+50.8, 2.6+15.2],
        [14+1.3+50.8, 2.6+15.2+27.9],
        [14+1.3, 2.6+15.2+27.9+5.1],
        [14+1.3+82, 2.6+15.2+27.9+5.1],
    ];

    fixing_holes=0;
    fixing_hole_distance=[10,10];
    BoardHolder6Pt(
        board_dimensions,
        hole_pts,
        fixing_holes,
        fixing_hole_distance
    );
}

MegaFrame();
