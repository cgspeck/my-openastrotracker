//
// arduino lcd keypad shield
//
// design by Egil Kvaleberg, 24 May 2015
//
// TODO:
// update with real measurements from original Uno drawings
// https://www.wayneandlayne.com/blog/2010/12/19/nice-drawings-of-the-arduino-uno-and-mega-2560/
// (incomplete) drawings of the LCD shield:
//  http://www.dfrobot.com/wiki/index.php?title=Arduino_LCD_KeyPad_Shield_%28SKU:_DFR0009%29
// display module dimensions:
//  https://www.adafruit.com/datasheets/rgblcddimensions.gif
// what about screws?
//
// notes:
// design origin is top surface of center of lcd/keypad pcbwith_battery ? batt[0]+wall+2*tol : 0
//
// extra PCB in example is 20x33.7

Print_part = "bottom"; // [ top, bottom, button, buttons, all ]
Board = "MEGA"; // [ MEGA, UNO ]
Buck_converter = "LARGE"; // [ LARGE, SMALL, NONE ]

USB_cutout = 1; // [ 1:true, 0:false ] 
Power_cutout = 1; // [ 1:true, 0:false ] 
RJ45_cutouts = 1; // [ 1:true, 0:false ] 
DEBUG = 0; // [ 1:true, 0:false ]
$fn = 30;  // resolution of curved surfaces

/* [Hidden] */

//usb_loc = (Board=="MEGA" ? 84.50 : 84.00);
//power_loc = (Board=="MEGA" ? 56.50 : 53.50);
with_mega = (Board=="MEGA" ? 1 : 0);
with_big_buck = (Buck_converter=="LARGE" ? 1 : 0);
with_small_buck = 1 - with_big_buck;

usb_loc = (Board=="MEGA" ? 85.00 : 85.00);
power_loc = (Board=="MEGA" ? 55.25 : 54.50);

with_battery = 0; // [ 1:true, 0:false ] 
extra_length = 0; //20.6; // size of extra length, if any, set to 0 otherwise
extra_width = 0; //20.6; // size of extra room, if any, set to 0 otherwise
have_power_switch = 0; // [ 1:true, 0:false ] 
have_up_key = 1; // [ 1:true, 0:false ] 
have_down_key = 1; // [ 1:true, 0:false ] 
have_left_key = 1; // [ 1:true, 0:false ] 
have_right_key = 1; // [ 1:true, 0:false ] 
have_select_key = 1; // [ 1:true, 0:false ] 
have_reset_key = 1; // [ 1:true, 0:false ] 
have_plugrow_upper = 0; // [ 1:true, 0:false ]
have_plugrow_lower = 0; // [ 1:true, 0:false ]
countersink = 0.00;


echo("Board = ",Board);
echo("usb_loc = ",usb_loc);
echo("power_loc = ",power_loc);

mil2mm = 0.0254;
DATUMX = 1120; // BUG: approx, in mils
DATUMY = 1050; // exact, in mils

batt = [17.0, 53.0, 26.0]; // 
mega = [33.0, 53.3, 26.0]; // 
s_buck = [43.18, 20.83, 1.5];  // DC-DC buck converter
big_buck = [36, 66, 1.5];  // DC-DC buck converter
pcb = [80.0, 58.0, 1.5]; // lcd/keypad shield, net (dwg is 80x58 mm)

pcb2floor = 17.0 + (RJ45_cutouts>0 ? 4.9 : 0); // bottom of top pcb
pcb2roof = 10.8;
lcdpcb2roof = 6.7;
pcb2lower = 12.8; // distance between main pcbs (top to top)
lcdpcbdx = 0.0;
lcdpcbdy = (14.0 - 7.5)/2 + 0.5; // 0.5 is fudge, don't ask
lcdpcb = [80.0, 36.0, 1.6]; // size (dwg is 80x36mm)
lcdframe = [71.8, 24.8, 3.8]; // net size (dwg is 71.3 x 26.3)
window = [64.0, 14.0]; // size (dwg 64.5 x 16.4, not critical)
windowdx = (4.2 - 4.6)/2;
windowdy = (19.6 - 14.0)/2 + 0.5; // 0.5 is fudge, don't ask
pcbmntdia = 3.1; // lcd mounting holes (dwg is 2.5)
pcbmntdx = 75.0/2; // distance between lcd mounting holes (dwg is 75.00)
pcbmntdy = 31.0/2; // (dwg is 31.00) 
pcbmnt2dia = 3.5; // uno mounting holes (dwg is 3.2)
pcbmnt2dx = (600-DATUMX)*mil2mm; // 
pcbmnt2dy = (2000-DATUMY)*mil2mm;
pcbmnt2adx = (550-DATUMX)*mil2mm;
pcbmnt2bdx = (3550-DATUMX)*mil2mm;
pcbmnt2cdx = (3800-DATUMX)*mil2mm;
pcbmnt3dx = (2600-DATUMX)*mil2mm;  // 
pcbmnt3dy = (300-DATUMY)*mil2mm;
pcbmnt3ady = (1400-DATUMY)*mil2mm;
s_buckmnt1x = (3307.1-DATUMX)*mil2mm;
s_buckmnt1y = (-137.8-DATUMY)*mil2mm;
pcbmnthead = 6.2; // countersunk
pcbmntthreads = 2.5;
s_buckmnt1dx = -pcb[0]/2 + 6.604;
s_buckmnt1dy = -pcb[1]/2 - 0.5 - 2.54;
s_buckmnt2dx = -pcb[0]/2 + 36.576;
s_buckmnt2dy = -pcb[1]/2 - 0.5 - 18.542;

b_buckmnt1dx = -pcb[0]/2 + 3.5;
b_buckmnt1dy = -pcb[1]/2 - 3.5;
b_buckmnt2dx = (with_mega) ? -pcb[0]/2 + 63.5 : -pcb[0]/2 + 33.5; 
b_buckmnt2dy = (with_mega) ? -pcb[1]/2 - 33.5 : -pcb[1]/2 - 63.5; 
echo(b_buckmnt1dx,b_buckmnt1dy,b_buckmnt2dx,b_buckmnt2dy);

breakaway = 0.3; // have hidden hole for screw, 0 for no extra pegs 

button = [-(pcb[0]/2-25.2+6.0/2), -(pcb[1]/2-3.6-6.0/2), 5.3]; // coordinates, and total height from pcb
button_dia = 4.8;
button_dy1 = 4.7;
button_dy2 = -2.0;
button_dx1 = 15.2 - 6.0;
button_dx2 = 23.2 - 6.0;
trimpot = [9.5, 4.4]; // trimpot size, no margin
trimpotdx = -(pcb[0]/2  - 3.9 - 9.5/2);
trimpotdy = pcb[1]/2 - 0.9 - 4.4/2; 
trimmer_dia = 2.8; // 2.3 with no margin
trimmer = [-(pcb[0]/2-4.0-trimmer_dia/2), pcb[1]/2-0.7-trimmer_dia/2, 0]; // coordinates of trimmer hole
lowerpcbrx = 9.5; // room at contacts, with margin 
powersy = 8.9; // power contact width, dwg is 8.9
powerdy = ((475+125)/2-DATUMY)*mil2mm;
usbsy = 12.3;
usbdy = ((1725+1275)/2-DATUMY)*mil2mm;

plugrow1 = [(1800-DATUMX)*mil2mm, (pcb[1]/2-0.5-2.56/2)]; // coordinates D7 pin
plugrow2 = [(1300-DATUMX)*mil2mm, -(pcb[1]/2-0.5-2.56/2)]; // coordinates RST pin

frame_w = 2.5; // assembly frame width
snap_dia = 1.8; // snap lock ridge diameter
snap_len = 20.0; // snap lock length
tol = 0.5; // general tolerance
swtol = 0.35; // tolerance for switch
wall = 1.6; // general wall thickness
thinwall = 0.4;
corner_r = 2.0; //wall; // casing corner radius
corner2_r = wall+tol+wall; // corners of top casing
d = 0.01;

echo("X datum ref:",-13.2,(600-DATUMX)*mil2mm);
echo(pcbmnt2dy-pcbmnt3ady, (2000-1400)*mil2mm); // 15.325, dwg is 15.24
echo(pcbmnt3dy+pcbmnt2dy, (300-100)*mil2mm); // 5.075, dwg is 5.08
echo(pcbmnt2dy, (1050-100)*mil2mm); // 24.125, dwg is 24.13
echo(powerdy+pcbmnt2dy, ((475+125)/2-100)*mil2mm); // 5.575 dwg is 5.08
echo("USBDY",pcbmnt2dy - usbdy, (2000-(1725+1275)/2)*mil2mm); // 13.025 dwg is 12.7
//echo(plugrow1[1]+pcbmnt2dy, (1050-100)*mil2mm); // 5.02 dwg is 5.08
//echo(pcbmnt3dx-pcbmnt2dx, (2600-600)*mil2mm); // 50.2, dwg is 50.8 
//echo(pcbmnt2dx-pcbmnt2adx, (600-550)*mil2mm); // 1.3, dwg is 1.27
//echo("p1",plugrow1[0]-pcbmnt2dx, (1800-600)*mil2mm); // upper, 30.48 dwg is 30.08
//echo(plugrow2[0]-pcbmnt2adx, (1300-550)*mil2mm); // lower, 19.18 dwg is 19.05
//echo(pcbmnt2dia, 125*mil2mm); // 3.5, dwg is 3.175
//echo(box);
//echo(s_buckmnt1dx,s_buckmnt1dy,s_buckmnt2dx,s_buckmnt2dy);

extra_x = extra_width + (with_battery ? batt[0]+wall+2*tol : 0) + (with_mega ? mega[0]+tol : 0); // extra space in x
box = [pcb[0], pcb[1]+(with_big_buck ? (with_mega ? big_buck[0]+0.5 : big_buck[1]+0.5) : (RJ45_cutouts ? 36 : (with_small_buck ? s_buck[1]+0.5 : 0))) + extra_length, pcb[2]];
echo ("extra length",box[1]-pcb[1]);

module nut(af, h) { // af is 2*r
	cylinder(r=af/2/cos(30), h=h, $fn=6);
}

module c_cube(x, y, z) {
	translate([-x/2, -y/2, 0]) cube([x, y, z]);
}

module cr_cube(x, y, z, r) {
	hull() {
		for (dx=[-1,1]) for (dy=[-1,1]) translate([dx*(x/2-r), dy*(y/2-r), 0]) cylinder(r=r, h=z);
	}
}

module cr2_cube(x, y, z, r1, r2) {
	hull() {
		for (dx=[-1,1]) for (dy=[-1,1]) translate([dx*(x/2-r1), dy*(y/2-r1), 0]) cylinder(r1=r1, r2=r2, h=z);
	}
}


switchneck = 6.0; // neck of toggle switch
switchbody = 15.0; // height of switch body, including contacts
module tswitch(extra) { // standard toggle switch
	if (have_power_switch) translate([-pcb[0]/2, -3.5, wall + pcb2floor/2 + 4.0]) rotate([90, 0, 0])  rotate([0, -90, 0]) {
		cylinder(r=switchneck/2+extra, h=9.0);
		cylinder(r=2.0/2, h=19.0);
		rotate([180, 0, 0]) c_cube(13.2+2*extra, 8.0+2*extra, 10.5+2*extra);
		for (dx = [-5.08, 0, 5.08]) rotate([180, 0, 0]) translate([dx, 0, 0]) cylinder(r=1.1, h=switchbody);
	}
}

module switchguard() { 
	r = 3.0;
	w = 11.5;
	len = 15.0;
	h = wall + pcb2floor/2 + 1.5;

	if (have_power_switch) translate([-pcb[0]/2-tol, -3.5, 0]) {
		rotate ([0, 0, 90]) difference () {
			union () {
				translate([0, r/2, 0]) c_cube(len, r, h);
				translate([0, w/2+wall, 0]) cr_cube(len, w+2*wall, h, r);
			}
			union () {
				translate([0, wall/2, -d]) c_cube(len, wall+2*d, h+2*d);
				translate([0, w/2+wall, -d]) cr_cube(len-2*wall, w, h+2*d, r*0.8);
			}
		}
	}
}

module old_bottom() {

    // cutout for power jack
    module power_usb(extra) { 
       if (Power_cutout) {
			echo("POWER:",[-pcb[0]/2, powerdy, wall+4.0+(pcb2floor-pcb2lower-pcb[2])-2*extra-countersink]);
			translate([-pcb[0]/2, powerdy, wall+4.0+(pcb2floor-pcb2lower-pcb[2])-2*extra-countersink]) 
				c_cube(2*(lowerpcbrx-tol), powersy+2*extra, pcb[2]+pcb2lower+2*extra-4.0);
       }

    // cutout for USB jack
        if (USB_cutout) {
			echo("USB:",[-pcb[0]/2, usbdy, wall+4.0+(pcb2floor-pcb2lower-pcb[2])-2*extra-countersink]);
			translate([-pcb[0]/2, usbdy, wall+4.0+(pcb2floor-pcb2lower-pcb[2])-2*extra-countersink]) 
				c_cube(2*(lowerpcbrx-tol), usbsy+2*extra, pcb[2]+pcb2lower+2*extra-4.0);
        }

    // cutouts for RJ45 jacks
        if (RJ45_cutouts) {
			echo("RJ45:",[pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol, 0]) rotate([0,0,90]) rj45VolumeBlock(); 
			echo("RJ45:",[pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol+18, 0]) rotate([0,0,90]) rj45VolumeBlock(); 
			translate([pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol, 0]) rotate([0,0,90]) rj45VolumeBlock(); 
			translate([pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol+18, 0]) rotate([0,0,90]) rj45VolumeBlock(); 
        }
    }


	module add() {
        // outer shell of box bottom
		hull () for (x = [-1, 1]) for (y = [-1, 1]) {
			echo("OUTER:",[x*(pcb[0]/2+tol+wall-corner_r) + (x>0 ? extra_x : 0), (y<0 ? y*(box[1]-pcb[1]/2+tol+wall-corner_r) : y*(pcb[1]/2+tol+wall-corner_r)), corner_r],corner_r);
			translate([x*(pcb[0]/2+tol+wall-corner_r) + (x>0 ? extra_x : 0), (y<0 ? y*(box[1]-pcb[1]/2+tol+wall-corner_r) : y*(pcb[1]/2+tol+wall-corner_r)), corner_r]) {
				sphere(r = corner_r );
				cylinder(r = corner_r, h = wall+pcb2floor+pcb[2]-corner_r );
		}
    }

        // clips to hold top on
		translate([-pcb[0]/2-tol-wall, -(box[1]-pcb[1])/2-snap_len/2, wall+pcb2floor+pcb[2]-frame_w/2]) rotate([-90, 0, 0]) cylinder(r=snap_dia/2, h=snap_len );

		translate([pcb[0]/2+tol+wall+extra_x, -(box[1]-pcb[1])/2-snap_len/2, wall+pcb2floor+pcb[2]-frame_w/2]) rotate([-90, 0, 0]) cylinder(r=snap_dia/2, h=snap_len );

		translate([(extra_x-snap_len)/2, pcb[1]/2+tol+wall, wall+pcb2floor+pcb[2]-frame_w/2]) rotate([0, 90, 0]) cylinder(r=snap_dia/2, h=snap_len );

		translate([(extra_x-snap_len)/2, -box[1]+pcb[1]/2-tol-wall, wall+pcb2floor+pcb[2]-frame_w/2]) rotate([0, 90, 0]) cylinder(r=snap_dia/2, h=snap_len );
	}

	module sub() {

        // pcb standoffs
        module pedestal(dx, dy, hg, dia) {
            translate([dx, dy, wall]) {
				cylinder(r = dia/2+wall, h = hg );
                // pegs through pcb mount holes
                if (breakaway > 0) translate([0, 0, hg]) 
                        cylinder(r = dia/2 - tol, h = pcb[2] );
            }
        }

        // screw hole in pcb standoffs
        module pedestal_hole(dx, dy, hg, dia, breakaway=0.0) {
            translate([dx, dy, breakaway]) {	
				cylinder(r = dia/2, h = wall+hg-2*breakaway );
				cylinder(r = 1.0/2, h = wall+hg+pcb[2]+d ); // needed to 'expose' internal structure so it does not get removed
//				cylinder(r1 = pcbmnthead/2 - breakaway, r2 = 0, h = pcbmnthead/2 - breakaway ); // countersunk head
		    }
        }
		difference () {
			// pcb itself
			echo("INNER:",[-(box[0]/2+tol), -(box[1]-pcb[1]/2+tol), wall]);
			echo("CUBE:",[2*tol+box[0]+extra_x, 2*tol+box[1], pcb2floor+box[2]+d]);

			translate([-(box[0]/2+tol), -(box[1]-pcb[1]/2+tol), wall])
				cube([2*tol+box[0]+extra_x, 2*tol+box[1], pcb2floor+box[2]+d]);
            
			// less pcb mount pedestals to lcd shield pcb]) 
            difference ( ){
                pedestal(lcdpcbdx-pcbmntdx, lcdpcbdy-pcbmntdy, pcb2floor-countersink, pcbmntdia);   
                tswitch(tol);
            }    
// upper left shield mount
//            pedestal(lcdpcbdx-pcbmntdx, lcdpcbdy+pcbmntdy, pcb2floor-countersink, pcbmntdia); 

//  upper left pcb mount
            echo("UL MOUNT",pcbmnt2dx, pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);
            pedestal(pcbmnt2dx, pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);

//  lower left pcb mount
            echo("LL MOUNT",pcbmnt2adx, -pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);
            pedestal(pcbmnt2adx, -pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);

//  lower right uno mount
            echo("LM MOUNT",pcbmnt3dx, pcbmnt3dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);
            pedestal(pcbmnt3dx, pcbmnt3dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);

//  upper right uno mount 
            echo("UM MOUNT",pcbmnt3dx, pcbmnt3ady, pcb2floor-pcb2lower-countersink, pcbmnt2dia);
            pedestal(pcbmnt3dx, pcbmnt3ady, pcb2floor-pcb2lower-countersink, pcbmnt2dia);

            if (with_mega) {

//  upper right mega mount
                echo("UR MOUNT",pcbmnt2bdx, pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);
                pedestal(pcbmnt2bdx, pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);

//  lower right mega mount
                echo("LR MOUNT",pcbmnt2cdx, -pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);
                pedestal(pcbmnt2cdx, -pcbmnt2dy, pcb2floor-pcb2lower-countersink, pcbmnt2dia);
            }
            
            if (with_small_buck) {
                echo("SB:",s_buckmnt1dx, s_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia);   
                pedestal(s_buckmnt1dx, s_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia);   
                echo("SB:",s_buckmnt2dx, s_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia); 
                pedestal(s_buckmnt2dx, s_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia); 
                echo("SB:",s_buckmnt2dx, s_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia, breakaway=0);   
                pedestal(s_buckmnt2dx, s_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia, breakaway=0);   
                echo("SB:",s_buckmnt1dx, s_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia, breakaway=0); 
                pedestal(s_buckmnt1dx, s_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia, breakaway=0); 
            }  

            if (with_big_buck) {
                echo("BB:",b_buckmnt1dx, b_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia);   
                echo("BB:",b_buckmnt2dx, b_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia); 
                echo("BB:",b_buckmnt2dx, b_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia);   
                echo("BB:",b_buckmnt1dx, b_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia); 
                pedestal(b_buckmnt1dx, b_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia);   
                pedestal(b_buckmnt2dx, b_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia); 
                pedestal(b_buckmnt2dx, b_buckmnt1dy, pcb2floor-pcb2lower-countersink, pcbmntdia/*, breakaway=0*/);   
                pedestal(b_buckmnt1dx, b_buckmnt2dy, pcb2floor-pcb2lower-countersink, pcbmntdia/*, breakaway=0*/); 
            }  


            // walls for contacts
            difference () {
                union () {
                    translate([0, wall, -0*tol]) power_usb(tol);
                    translate([0, -wall, -0*tol]) power_usb(tol);
                    translate([0, wall, -(wall+pcb2floor-pcb2lower-pcb[2]-tol)-4.0]) power_usb(tol);
                    translate([0, wall, -(wall+pcb2floor-pcb2lower-pcb[2]-tol)-2.0]) power_usb(tol);
                    translate([0, -wall, -(wall+pcb2floor-pcb2lower-pcb[2]-tol)-4.0]) power_usb(tol);
                    translate([0, -wall, -(wall+pcb2floor-pcb2lower-pcb[2]-tol)-2.0]) power_usb(tol);
                }
                translate([d, 0, 0]) power_usb(tol);
            }
		}
		// hole for countersunk pcb mounting screws, hidden (can be broken away)
		//for (dx = [-pcbmntdx]) for (dy = [-pcbmntdy, pcbmntdy]) pedestal_hole(lcdpcbdx + dx, lcdpcbdy + dy, pcb2floor, pcbmntdia);
//        pedestal_hole(pcbmnt2dx, pcbmnt2dy, pcb2floor-pcb2lower, pcbmnt2dia);
//        pedestal_hole(pcbmnt3dx, pcbmnt3dy, pcb2floor-pcb2lower, pcbmnt2dia);
        // hole for usb and power
        power_usb(tol);
        // hole for switch
        tswitch(tol);
        // extra room
        if (extra_width > 0) translate([pcb[0]/2+tol+wall+extra_width/2, 0, wall]) {
            translate([0, pcb[1]/2 - 7.0/2, pcb2floor*.8]) rotate([0, -90, 0]) cylinder(r=7.0/2, h=extra_width); // hole in internal wall
            for (dx = [-5.0, 5.0]) translate([dx, pcb[1]/2 - 6.0/2, pcb2floor*.5]) rotate([0, -90, -90]) cylinder(r=6.0/2, h=extra_width ); // holes in external wall
            difference () {
                c_cube(extra_width, pcb[1]+2*tol, batt[2]+2*tol);
                for (dy = [0, 20]) translate([0, dy, 0]) rotate([45, 0, 0]) {
                    for (dx = [(extra_width/2-wall/2), -(extra_width/2-wall/2)]) { 
                        translate([dx, 0, 0]) c_cube(wall, wall, 30);
                        translate([dx, pcb[2] + 2*tol + wall, 0]) c_cube(wall, wall, 30);
                    }
                }
            }
        }
        // room for battery
        if (with_battery) translate([pcb[0]/2+2*tol+wall+batt[0]/2+(extra_width>0 ? extra_width+wall : 0), 0, wall]) {
            c_cube(batt[0]+2*tol, pcb[1]+2*tol, batt[2]+2*tol);
            translate([0, pcb[1]/2 - 4.0/2, pcb2floor*.8]) rotate([0, -90, 0]) cylinder(r=4.0/2, h=batt[0]); // hole in internal wall
        }
	}
	difference () {
		add();
		sub();
	}
                    if (RJ45_cutouts) {
			echo("RJ45 rec:",[pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol, 0]) rotate([0,0,90]) rj45Receiver(); 
			echo("RJ45 rec:",[pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol+18, 0]) rotate([0,0,90]) rj45Receiver(); 
			translate([pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol, 0]) rotate([0,0,90]) rj45Receiver(); 
			translate([pcb[0]/2+extra_x+tol+wall, -box[1]+pcb[1]/2-tol+18, 0]) rotate([0,0,90]) rj45Receiver(); 
    }

    switchguard();
    //power_usb(0);
    //tswitch(0);
}

/*
 * The RJ45 keystone receiver
 */
module rj45Receiver() {
    translate([0,9.9,0]) rotate([90,0,0]) {
	difference() {
        difference() { 
            cube([18, 25, 9.9]);
            translate([0,0,9.9]) rotate([0,90,0]) difference() {
            cube([corner_r,corner_r,18]); 
            translate([corner_r,corner_r,0]) cylinder(r=corner_r,h=18);}}
		translate([1.55, 2.6, 0]) {
			cube([14.9, 19.44, 7.9]);
		}
		translate([1.55, 2.6, 7.9]) {
			cube([14.9, 16.25, 2]);
		}
		translate([1.55, 17.45, 7.2]) {
			rotate(v=[1, 0, 0], a=-27.3) {
				cube([14.9, 3.5, 3]);
			}
		}
		translate([1.55, 1.43, 1.35]) {
			cube([14.9, 22.14, 6.8]);
		}
	}
	translate([0, 22.04, -1.35]) {
		intersection() {
			cube([18, 2.96, 1.35]);
			union() {
				translate([0, 1.61, 0]) {
					cube([20.42, 1.61, 1.35]);
				}
				translate([0, 1.35, 1.35]) {
					rotate(v=[0, 1, 0], a=90) {
						cylinder(h=20.42, r=1.35);
					}
				}
			}
		}
	}

	translate([0, 0, -1.35]) {
		intersection() {
			cube([18, 2.6, 1.35]);
			union() {
				cube([20.42, 1.25, 1.35]);
				translate([0, 1.25, 1.35]) {
					rotate(v=[0, 1, 0], a=90) {
						cylinder(h=20.42, r=1.35);
					}
				}
			}
		}
	}
}}

/*
 * So a hole can be cut for the keystone socket
 */
module rj45VolumeBlock() {
	translate([0,9.9,0]) rotate([90,0,0]) 
    		translate([1.55, 1.43, 0]) 
			cube([14.9, 22.14, 11.25]);
}


module top() {

	module add() {
		hull () for (x = [-1, 1]) for (y = [-1, 1]) {
            echo([x*(pcb[0]/2+tol+wall-corner_r) + (x>0 ? extra_x : 0), (y<0 ? y*(box[1]-pcb[1]/2+tol+wall-corner_r) : y*(pcb[1]/2+tol+wall-corner_r)), -frame_w]);
			translate([x*(pcb[0]/2+tol+wall-corner_r) + (x>0 ? extra_x : 0), (y<0 ? y*(box[1]-pcb[1]/2+tol+wall-corner_r) : y*(pcb[1]/2+tol+wall-corner_r)), -frame_w]) 
				cylinder(r = corner_r+tol+wall, h = d ); // include frame
			translate([x*(pcb[0]/2+tol+wall-corner2_r) + (x>0 ? extra_x : 0), (y<0 ? y*(box[1]-pcb[1]/2+tol+wall-corner_r) : y*(pcb[1]/2+tol+wall-corner2_r)), pcb2roof+wall-corner2_r]) 
					sphere(r = corner2_r );	
		}
	}

	module sub() {
		module button_frame(dx, dy) {
          // less button frame pluss one wall
			translate(button) translate([dx, dy, wall+swtol]) 
				cylinder(r = button_dia/2 + swtol+wall, h=pcb2roof);
       }  
       module button_hole(dx, dy, en) {  
           translate([button[0]+dx, button[1]+dy, 0]) 
                cylinder(r = button_dia/2 + swtol, h=pcb2roof+wall+(en ? d : -breakaway));
       }
		module button_room(dx, dy) {
          // room required for button collar
			translate(button) translate([dx, dy, -10]) 
				cylinder(r = button_dia/2 + swtol+wall, h=10+wall+swtol);
       } 
		module plugrow_frame(xy, start, pins) {
			frmheight = 3.0;
			translate([xy[0]+(start+(pins-1)/2)*2.56, xy[1], wall+swtol+frmheight]) 
				c_cube(pins*2.56+2*tol+2*wall, 2.56+2*tol+2*wall, pcb2roof-frmheight);
       }
		module plugrow_hole(xy, start, pins) {
			translate([xy[0]+(start+(pins-1)/2)*2.56, xy[1], 0]) 
				c_cube(pins*2.56+2*tol, 2.56+2*tol, pcb2roof+wall);
       }
		// room for bottom case within frame 
		hull () for (x = [-1, 1]) for (y = [-1, 1])
			translate([x*(pcb[0]/2+tol+wall-corner_r) + (x>0 ? extra_x : 0), (y<0 ? y*(box[1]-pcb[1]/2+tol+wall-corner_r) : y*(pcb[1]/2+tol+wall-corner_r)), -frame_w/*-d*/]) 
                cylinder(r = corner_r+tol, h = /*d+*/frame_w ); 

		// snap lock
		translate([-pcb[0]/2-tol-wall, -(box[1]-pcb[1])/2-snap_len/2, -frame_w/2]) rotate([-90, 0, 0]) cylinder(r=snap_dia/2, h=snap_len );

		translate([pcb[0]/2+tol+wall+extra_x, -(box[1]-pcb[1])/2-snap_len/2, -frame_w/2]) rotate([-90, 0, 0]) cylinder(r=snap_dia/2, h=snap_len );

		translate([(extra_x-snap_len)/2, pcb[1]/2+tol+wall, -frame_w/2]) rotate([0, 90, 0]) cylinder(r=snap_dia/2, h=snap_len );

		translate([(extra_x-snap_len)/2, -box[1]+pcb[1]/2-tol-wall, -frame_w/2]) rotate([0, 90, 0]) cylinder(r=snap_dia/2, h=snap_len );

		difference() { 
			// room for pcb
			translate([extra_x/2, -(box[1]-pcb[1])/2, -d]) cr_cube(2*tol+pcb[0]+extra_x, 2*tol+box[1], d+pcb2roof, 1.0);
			union () {
				// less lcd frame 
				translate([windowdx, windowdy, pcb2roof-lcdframe[2]]) 
					c_cube(lcdframe[0]+2*wall+2*tol, lcdframe[1]+2*wall+2*tol, lcdframe[2]);
              // buttons
				 button_frame(0, button_dy1);
              button_frame(0, button_dy2);
              button_frame(button_dx2, 0); // reset
              button_frame(button_dx1, 0);
              button_frame(-button_dx2, 0);
              button_frame(-button_dx1, 0);
				// plug rows
				if (have_plugrow_upper) 
					plugrow_frame(plugrow1, 0, 7);
				if (have_plugrow_lower) {
					difference () {
						plugrow_frame(plugrow2, 0, 6);
			          button_room(button_dx2, 0); // reset
					}
					plugrow_frame(plugrow2, 6+2, 5);
				}
			}

		}
		// lcd module, adding margin within frame only
		translate([windowdx, windowdy, pcb2roof-lcdframe[2]-d]) 
			c_cube(lcdframe[0], lcdframe[1], lcdframe[2]+tol);
		// lcd window
		translate([windowdx, windowdy, 0])
			c_cube(window[0], window[1], pcb2roof+tol+wall+d);
		// trimpot body
		translate([trimpotdx, trimpotdy, pcb2roof-lcdframe[2]-d]) 
			c_cube(trimpot[0]+2.0, trimpot[1]+2.0, lcdframe[2]+tol);
		// button hole
       button_hole(0, button_dy1, have_up_key); // up
       button_hole(0, button_dy2, have_down_key); // down
       button_hole(button_dx2, 0, have_reset_key); // reset
       button_hole(button_dx1, 0, have_right_key); // right
       button_hole(-button_dx2, 0, have_select_key); // select
       button_hole(-button_dx1, 0, have_left_key); // left
		// plug rows
		if (have_plugrow_upper) 
			plugrow_hole(plugrow1, 0, 7);
		if (have_plugrow_lower) {
			plugrow_hole(plugrow2, 0, 6);
			plugrow_hole(plugrow2, 6+2, 5);
		}
		// trimmer hole for screw
		translate(trimmer) {
			cylinder(r = trimmer_dia/2 + tol, h=pcb2roof+tol+wall+d);
		}
       // extra room 
       if (extra_width > 0) translate([pcb[0]/2+tol+wall+extra_width/2, 0, -d]) {
            cr_cube(extra_width, pcb[1]+2*tol, pcb2roof, 1.0);
       }
       // room for battery
       if (with_battery) translate([pcb[0]/2+2*tol+wall+batt[0]/2+(extra_width>0 ? extra_width+wall : 0), 0, -d]) {
            cr_cube(batt[0]+2*tol, pcb[1]+2*tol, pcb2roof, 1.0);
       }
	}
	difference () {
		add();
		sub();
	}
   
	// pcb support pegs
	for (dx = [-pcbmntdx, pcbmntdx]) for (dy = [-pcbmntdy, pcbmntdy])
		translate([lcdpcbdx + dx, lcdpcbdy + dy, pcb2roof-lcdpcb2roof-countersink]) {
            cylinder(r = pcbmntdia/2 +wall, h = lcdpcb2roof+countersink );
            translate([0, 0, -pcb[2]]) cylinder(r = pcbmntdia/2 - tol, h = lcdpcb[2]+d ); // pegs
         }	
    difference () {
        translate([pcbmnt2dx, pcbmnt2dy, 0]) {
            cylinder(r = pcbmnt2dia/2 +wall, h = pcb2roof );
            translate([0, 0, -pcb[2]]) cylinder(r = pcbmnt2dia/2 - tol, h = pcb[2]+d ); // pegs
            translate([0, (pcb[1]/2-pcbmnt2dy)/2 + wall, 0]) c_cube(wall, pcb[1]/2-pcbmnt2dy, pcb2roof); // support
         }  
         // lcd/keypad pcb plus margin of 2.0 
         translate([lcdpcbdx, lcdpcbdy, -d]) 
			c_cube(lcdpcb[0], lcdpcb[1] + 2*tol, d + 2.0 + pcb2roof-lcdpcb2roof); 
     }   
        
    translate([pcbmnt3dx, pcbmnt3dy, 0]) {
        cylinder(r = pcbmnt2dia/2 +wall, h = pcb2roof );
        translate([0, 0, -pcb[2]]) cylinder(r = pcbmnt2dia/2 - tol, h = pcb[2]+d ); // pegs
        translate([(pcb[0]/2-pcbmnt3dx)/2+wall, 0, 0]) c_cube(pcb[0]/2-pcbmnt3dx, wall, pcb2roof); // support
    }

    if (with_small_buck) {
        echo (pcb2floor,pcb2lower,pcb2roof);
        translate([s_buckmnt1dx, s_buckmnt1dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
//        translate([s_buckmnt1dx, s_buckmnt2dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
//        translate([s_buckmnt2dx, s_buckmnt1dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
        translate([s_buckmnt2dx, s_buckmnt2dy, -pcb2lower+tol]) cylinder(r =pcbmnt2dia, h = pcb2lower+pcb2roof );  
        }  

    if (with_big_buck) {
        translate([b_buckmnt1dx, b_buckmnt1dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
        translate([b_buckmnt1dx, b_buckmnt2dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
        translate([b_buckmnt2dx, b_buckmnt1dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
        translate([b_buckmnt2dx, b_buckmnt2dy, -pcb2lower+tol]) cylinder(r =pcbmnt2dia, h = pcb2lower+pcb2roof );  
        }  

    if (with_mega) {
        translate([pcbmnt2bdx, -pcbmnt2dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
        translate([pcbmnt2cdx, pcbmnt2dy, -pcb2lower+tol]) cylinder(r = pcbmnt2dia, h = pcb2lower+pcb2roof );  
    }
} 

module button(hx=2) {
    hh = 0.7 + pcb2roof+wall-button[2];
    echo("hh: ",hh);
    cylinder(r=button_dia/2 + wall*0.5, h=wall ); // collar is wall*0.5
    cylinder(r=button_dia/2, h=hh+hx );
    translate([0, 0, hh+hx-button_dia*sin(60)]) intersection () {
        sphere(r=button_dia );
        cylinder(r=button_dia/2, h=10);
    }
}

module buttonbar(x0, y0, x1, y1) {
    translate([x0-wall/2, y0-wall/2, 0]) cube([wall+x1-x0, wall+y1-y0, wall]);   
}

//
// comment out the various pieces here
//

if (Print_part == "button") button();

bardist = 9.0;
if (Print_part == "buttons") { // with bar that connects

	buttonbar(-(button_dx1+button_dx2)/2, bardist, button_dx2, bardist);  
    if (have_select_key) 
      translate([-button_dx2, 0, 0]) {
		buttonbar(0, 0, 0, bardist/2);
        buttonbar(0, bardist/2, (button_dx2-button_dx1)/2, bardist/2);
        buttonbar((button_dx2-button_dx1)/2, bardist/2, (button_dx2-button_dx1)/2, bardist);
		button(2.5);
	}
    if (have_left_key) translate([-button_dx1, 0, 0]) {
		buttonbar(0, 0, 0, bardist);
		 button(2.5);
	}
    if (have_up_key) translate([0, button_dy1, 0])  {
		buttonbar(-button_dx1/2, 0, -button_dx1/2, bardist-button_dy1);
		buttonbar(-button_dx1/2, 0, 0, 0);
		button(2.5);
	}
    if (have_down_key) translate([0, button_dy2, 0]) {
		buttonbar(button_dx1/2, 0, button_dx1/2, bardist-button_dy2);
		buttonbar(0, 0, button_dx1/2, 0);
		button(2.5);
	}
    if (have_right_key) translate([button_dx1, 0, 0])  {
		buttonbar(0, 0, 0, bardist);
		button(2.5);
	}
    if (have_reset_key) 
        translate([button_dx2, 0, 0]) {
		  buttonbar(0, 0, 0, bardist);
		  button(0.5);
        }
}

//------------------------------------------------------

module arduino_bottom() {

  union() {  
    difference() {
      hull() {
        translate([2,2,2]) sphere(r=2);
        translate([116.5,2,2]) sphere(r=2);
        translate([116.5,113,2]) sphere(r=2);
        translate([2,113,2]) sphere(r=2);
        translate([2,2,2]) cylinder(r=2,h=36);
        translate([116.5,2,2]) cylinder(r=2,h=36);
        translate([116.5,113,2]) cylinder(r=2,h=36);
        translate([2,113,2]) cylinder(r=2,h=36);
      }
      if (DEBUG) {
          translate([9,0,2]) cube([100.5,2,36]);
          translate([9,113,2]) cube([100.5,2,36]);
          translate([0,9,2]) cube([2,97,36]);
          translate([116.5,9,2]) cube([2,97,36]);
      }

      translate([2,2,2]) difference() {
        cube([114.5,111,36]);

        // Upper left PCB standoff
        translate([27.302,97.38,0]) cylinder(h=8,d=6);
        translate([27.302,97.38,8]) cylinder(h=2.5,d=3);
        // Lower left PCB standoff
        translate([26.022,49.37,0]) cylinder(h=9.0,d=6);
        translate([26.022,49.37,9]) cylinder(h=1.5,d=3);
        // Upper middle PCB standoff
        translate([78.112,82.39,0]) cylinder(h=9.0,d=6);
        translate([78.112,82.39,9]) cylinder(h=1.5,d=3);
        // Lower middle PCB standoff
        translate([78.112,54.45,0]) cylinder(h=9.0,d=6);
        translate([78.112,54.45,9]) cylinder(h=1.5,d=3);

        if (Board == "MEGA") {
          // Upper right Mega standoff
          translate([102.222,97.63,0]) cylinder(h=9.0,d=6);
          translate([102.222,97.63,9]) cylinder(h=1.5,d=3);
          // Lower right Mega standoff
          translate([108.572,49.37,0]) cylinder(h=9.0,d=6);
          translate([108.572,49.37,9]) cylinder(h=1.5,d=3);
        }

        if (with_small_buck) {
          translate([ 8,32,0]) cylinder(h=9.0,d=6);
          translate([ 8,32,9]) cylinder(h=1.5,d=2.5);
          translate([38,16,0]) cylinder(h=9.0,d=6);
          translate([38,16,9]) cylinder(h=1.5,d=2.5);
          translate([38,32,0]) cylinder(h=9.0,d=6);
          translate([ 8,16,0]) cylinder(h=9.0,d=6);
        }

        if (with_big_buck) {
          translate([ 8,42,0]) cylinder(h=9.0,d=6);
          translate([ 8,42,9]) cylinder(h=1.5,d=2.5);
          translate([69,42,0]) cylinder(h=9.0,d=6);
          translate([69,42,9]) cylinder(h=1.5,d=2.5);
          translate([69,11,0]) cylinder(h=9.0,d=6);
          translate([69,11,9]) cylinder(h=1.5,d=2.5);
          translate([ 8,11,0]) cylinder(h=9.0,d=6);
          translate([ 8,11,9]) cylinder(h=1.5,d=2.5);
        }

        if (USB_cutout) {
          translate([0,usb_loc-13.3/2-2,0])
            cube([11,2,21.8]);
          translate([0,usb_loc-13.3/2,0])
            cube([11,13.3,10.5]);
          translate([0,usb_loc+13.3/2,0])
            cube([11,2,19.8]);
        }

        if (Power_cutout) {
          translate([0,power_loc-9.9/2-2,0])
            cube([11,2,19.8]);
          translate([0,power_loc-9.9/2,0])
            cube([11,9.9,10.5]);
          translate([0,power_loc+9.9/2,0])
            cube([11,2,21.8]);
        }
      }

      if (USB_cutout)
          translate([0,usb_loc-13.3/2+2,10.5+2])
            cube([2,13.3,11.3]);

      if (Power_cutout)
        translate([0,power_loc-9.9/2+2,10.5+2])
          cube([2,9.9,11.3]);

      if (RJ45_cutouts) {
        translate([116.5+2,8+2,0]) rotate([0,0,90])
          rj45VolumeBlock(); 
        translate([116.5+2,26+2,0]) rotate([0,0,90])
          rj45VolumeBlock(); 
      }
    }

    if (RJ45_cutouts) {
      translate([116.5+2,8+2,0]) rotate([0,0,90])
        rj45Receiver(); 
      translate([116.5+2,26+2,0]) rotate([0,0,90])
        rj45Receiver(); 
    }

    difference() {
      union() {
        translate([5.5,5.5,2]) cylinder(h=31.5,d=7);
        translate([2,2,2]) cube([3.5,7,31.5]);
        translate([2,2,2]) cube([7,3.5,31.5]);

        translate([113,5.5,2]) cylinder(h=31.5,d=7);
        translate([109.5,2,2]) cube([7,3.5,31.5]);
        translate([113,2,2]) cube([3.5,7,31.5]);

        translate([113,109.5,2]) cylinder(h=31.5,d=7);
        translate([109.5,109.5,2]) cube([7,3.5,31.5]);
        translate([113,106,2]) cube([3.5,7,31.5]);
          
        translate([5.5,109.5,2]) cylinder(h=31.5,d=7);
        translate([2,106,2]) cube([3.5,7,31.5]);
        translate([2,109.5,2]) cube([7,3.5,31.5]);  
      }
      translate([5.5,5.5,2]) cylinder(h=31.5,d=2.8);
      translate([113,5.5,2]) cylinder(h=31.5,d=2.8);
      translate([113,109.5,2]) cylinder(h=31.5,d=2.8);
      translate([5.5,109.5,2]) cylinder(h=31.5,d=2.8);
    }
  }
}

module arduino_top(ct=2.5) {

  difference() {
    union() {  
      difference() {
        hull() {
          echo("ct: ",ct);
          translate([2,2,2]) sphere(r=2);
          translate([116.5,2,2]) sphere(r=2);
          translate([116.5,113,2]) sphere(r=2);
          translate([2,113,2]) sphere(r=2);
          translate([2,2,2]) cylinder(r=2,h=ct-2);
          translate([116.5,2,2]) cylinder(r=2,h=ct-2);
          translate([116.5,113,2]) cylinder(r=2,h=ct-2);
          translate([2,113,2]) cylinder(r=2,h=ct-2);
        }
        translate([0,0,ct]) cube([118.5,115,2]);

        // screw holes
        translate([5.5,5.5,0]) cylinder(h=ct,d=3.5);
        translate([113,5.5,0]) cylinder(h=ct,d=3.5);
        translate([113,109.5,0]) cylinder(h=ct,d=3.5);
        translate([5.5,109.5,0]) cylinder(h=ct,d=3.5);
      
        // display cutout
        translate([6+3.8,66+6,0]) cube([64,14,ct]);

        // adjustment screw
        translate([7+2.25/2,103-2.25/2,0]) cylinder(h=ct,d=3.5);

        // button holes
        translate([24,54,0]) {
          translate([0,4.7,0]) cylinder(h=ct,d=5.2);
          translate([0,-2.7,0]) cylinder(h=ct,d=5.2);
          translate([-17.2,0,0]) cylinder(h=ct,d=5.2);
          translate([-9.2,0,0]) cylinder(h=ct,d=5.2);
          translate([9.2,0,0]) cylinder(h=ct,d=5.2);
          translate([17.2,0,0]) cylinder(h=ct,d=5.2);
        }

      }

          // Upper left LCD shield standoff
          translate([4.625,95.375,0]) cylinder(h=9.0,d=6);
          translate([4.625,95.375,9]) cylinder(h=1.5,d=2.5);
          // Lower left LCD shield standoff
          translate([4.625,95.375-31,0]) cylinder(h=9.0,d=6);
          translate([4.625,95.375-31,9]) cylinder(h=1.5,d=2.5);

          // Upper right LCD shield standoff
          translate([4.625+75,95.375,0]) cylinder(h=9.0,d=6);
          translate([4.625+75,95.375,9]) cylinder(h=1.5,d=2.5);

          // Lower right LCD shield standoff
          translate([4.625+75,95.375-31,0]) cylinder(h=9.0,d=6);
          translate([4.625+75,95.375-31,9]) cylinder(h=1.5,d=2.5);

          translate([2,2,0]) {
            if (Board == "MEGA") {
              // Upper right Mega standoff
              translate([102.222,97.63,0]) cylinder(h=27,d=5);
              // Lower right Mega standoff
              translate([108.572,49.37,0]) cylinder(h=27,d=5);
            }

            if (with_small_buck) {
              translate([ 8,32,0]) cylinder(h=27,d=6);
              translate([38,16,0]) cylinder(h=27,d=6);
//              translate([38,32,0]) cylinder(h=27,d=6);
//              translate([ 8,16,0]) cylinder(h=27,d=6);
              if (DEBUG) {
                translate([ 8,32,27]) cylinder(h=1.5,d=2.5);
                translate([38,16,27]) cylinder(h=1.5,d=2.5);
              }
            }
        
            if (with_big_buck) {
              translate([ 8,42,0]) cylinder(h=27,d=6);
              translate([69,42,0]) cylinder(h=27,d=6);
              translate([69,11,0]) cylinder(h=27,d=6);
              translate([ 8,11,0]) cylinder(h=27,d=6);
            }
          }
        
      difference() {
        union() {
          // cover stand-offs  
          translate([5.5,5.5,ct]) cylinder(h=4,d=7);
          translate([2,2,ct]) cube([3.5,7,4]);
          translate([2,2,ct]) cube([7,3.5,4]);

          translate([113,5.5,ct]) cylinder(h=4,d=7);
          translate([109.5,2,ct]) cube([7,3.5,4]);
          translate([113,2,ct]) cube([3.5,7,4]);

          translate([113,109.5,ct]) cylinder(h=4,d=7);
          translate([109.5,109.5,ct]) cube([7,3.5,4]);
          translate([113,106,ct]) cube([3.5,7,4]);
          
          translate([5.5,109.5,ct]) cylinder(h=4,d=7);
          translate([2,106,ct]) cube([3.5,7,4]);
          translate([2,109.5,ct]) cube([7,3.5,4]);  
        }

        translate([5.5,5.5,ct]) cylinder(h=4,d=3.5);
        translate([113,5.5,ct]) cylinder(h=4,d=3.5);
        translate([113,109.5,ct]) cylinder(h=4,d=3.5);
        translate([5.5,109.5,ct]) cylinder(h=4,d=3.5);
      
      }

      // display frame
      difference() {
        translate([4.25,64.75,ct]) cube([76,28.5,3]);
        translate([6.25,66.75,ct]) cube([72,24.5,3]);
      }

      // buttons
      difference() {
        translate([24,54,ct]) {
          translate([0,4.7,0]) cylinder(h=5,d=9);
          translate([0,-2.7,0]) cylinder(h=5,d=9);
          translate([-17.2,0,0]) cylinder(h=5,d=9);
          translate([-9.2,0,0]) cylinder(h=5,d=9);
          translate([9.2,0,0]) cylinder(h=5,d=9);
          translate([17.2,0,0]) cylinder(h=5,d=9);
        }
        translate([24,54,ct]) {
          translate([0,4.7,0]) cylinder(h=7,d=5.2);
          translate([0,-2.7,0]) cylinder(h=7,d=5.2);
          translate([-17.2,0,0]) cylinder(h=7,d=5.2);
          translate([-9.2,0,0]) cylinder(h=7,d=5.2);
          translate([9.2,0,0]) cylinder(h=7,d=5.2);
          translate([17.2,0,0]) cylinder(h=6,d=5.2);
        }
      }
    }
    translate([0,0,ct]) cube([2.5,115,25]);
    translate([0,0,ct]) cube([118.5,2.5,25]);
    translate([0,112.5,ct]) cube([118.5,2.5,25]);
    translate([116,0,ct]) cube([2.5,115,25]);
  }

}

if (Print_part=="bottom" || Print_part=="all") {
//        translate([0, 0, 0]) bottom();
        translate([0,0,0]) arduino_bottom();
}

if (Print_part=="top" || Print_part=="all") 
//    translate([268.5*0,0,40]) 
//    rotate([0,180,0])
    mirror([1,0,0]) arduino_top();


