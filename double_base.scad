// Rounded double bases, plain and textured
// (c) 2024, Juan Vera. Based on a previous design in Blender

/* Parameters */

// Diameter of the base (mm)
base_w = 25; // [10:100]
// Secondary diameter of the base (mm). Only used for the horse bases
base_texture=0; //  [0:Plain, 1:PlainHorses, 2:Bricks, 3:BricksHorses]
// Diameter of the magnet hole (mm). Add 0.5 for some tolerance
magnet_d = 5.5; // [2:0.5:10]
// Height of the hole (mm). Add 0.1 for some tolerance
magnet_h = 1.1; // [1:0.1:3.1]

/* [Bricks] */
// x size of the bricks (mm)
brick_x = 6.5; // [2:0.5:20]
// y size of the bricks (mm)
brick_y = 4.5; // [2:0.5:20]
// separation of the bricks, in x, relative to brick_x
brick_sep_x=1.01; // [1:0.01:1.5]
// separation of the bricks, in y, relative to brick_y
brick_sep_y=1.01; // [1:0.01:1.5]
// factor to sink the top of the brick
brick_f=0.99; // [0.95:0.01:1]
// offset of the bricks for odd lines lines (mm)
brick_offset=3.25; // [0:0.25:10]

/* [Hidden] */
// note: many dimensions are constant, because I want to match a base I modeled years ago in blender
// DO NOT CHANGE THESE VALUES. The final base will scale these values
// they are relative to a standard 25mm base
hole_r = 25/2-1; // dimensions of the hole. If hole_r==0, do not make a hole
hole_d = 2.1; // depth of the hole
base_total_height = 3.11; // The total height of the base
base_upper_r = 11.87; // The radius of the upper surface of a 25mm base
base_upper_h = 1; // The height of the upper surface of a 25mm base

use <circular_base.scad>;

module double_base_body(hole_r, hole_d) {
    rotate([0, 0, 90]) difference() {
        difference() {
            scale([1, 1, 0.62]) {
                sphere(r=25/2, $fn=50);
                translate([25, 0, 0]) sphere(r=25/2, $fn=50);
                rotate([90, 0, 90]) cylinder(r=25/2, h=25, $fn=50);
            }
            union() {
                translate([0, 0, 5+2.5]) cube([75, 30, 10], center=true);
                translate([0, 0, -5]) cube([75, 30, 10], center=true);
                if(hole_r > 0) {
                    cylinder(h=2*hole_d, r=hole_r, center=true);
                    translate([25, 0, 0]) cylinder(h=2*hole_d, r=hole_r, center=true);
                    translate([0, -hole_r, -hole_d]) cube([25, hole_r*2,2*hole_d]);
                }
            }
        }
    }
}
module base_plain_double(base_w, magnet_d, magnet_h) {
    scale([base_w/25, base_w/25, 1]) union() {
        double_base_body(hole_r, hole_d);
        translate([0, 0, 2.11]) cylinder(h=base_upper_h, r=base_upper_r);
        translate([0, 25, 2.11]) cylinder(h=base_upper_h, r=base_upper_r);
        //translate([base_upper_h, -base_w/2+(base_w/2-base_upper_r), 2.11]) {
        translate([-base_upper_r, 0, 2.11]) {
            cube([base_upper_r*2, 25, base_upper_h]);
        }
    }
    magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
    translate([0, base_w, 0]) magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}

module bricks_surface_double(brick_x, brick_y, brick_o, base_w, sep_x=1.2, sep_y=1.2, brick_r=1) {
    intersection() {
        // brick_x, brick_y: size of the brick
        // brick_o: offset of each line of the brick
        // base_w: size of the base
        scale([base_w/25, base_w/25, 1]) union() {
            cylinder(h=10, r=base_upper_r);
            translate([0, 25, 0]) cylinder(h=10, r=base_upper_r);
            translate([-base_upper_r, 0, 0]) {
                cube([base_upper_r*2, 25, 10]);
            }
        }
        first_x = base_w / brick_x / 2 + 1;
        first_y = 2 * base_w / brick_y;
        // small translation for stetics
        translate([0,0.2,0]) union() {
            for(i=[-first_x:first_x]) {
                for(j=[-first_y:first_y]) {
                    translate([i*sep_x*brick_x + (j%2)*brick_o, j*sep_y*brick_y, 0]) brick(brick_x, brick_y, base_upper_h, r=brick_r);
                }
            }
        }
    }
}
module base_bricks_double(base_w, magnet_d, magnet_h) {
    union() {
        scale([base_w/25, base_w/25, 1]) double_base_body(hole_r, hole_d);
        translate([0, 0, 2.11]) {
            bricks_surface_double(brick_x, brick_y, brick_offset, base_w, brick_sep_x, brick_sep_y);
        }
    }
    magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
    translate([0, base_w, 0]) magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}

module base_double(base_texture, base_w, magnet_d, magnet_h) {
    if(base_texture == 0 || base_texture == 1) { // plain
        base_plain_double(base_w, magnet_d, magnet_h);
    }
    if(base_texture == 2 || base_texture == 3) { // bricks
        base_bricks_double(base_w, magnet_d, magnet_h);
    }
}

base_double(base_texture, base_w, magnet_d, magnet_h);