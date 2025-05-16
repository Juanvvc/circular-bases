// Rounded bases, plain and textured
// (c) 2024, Juan Vera. Based on a previous design in Blender

/* Parameters */

// Diameter of the base (mm)
base_w = 25; // [10:100]
// Secondary diameter of the base (mm). Only used for the horse bases
base_w2 = 50; // [10:100]
base_texture=0; //  [0:Plain, 1:PlainHorses, 2:Bricks, 3:BricksHorses, 4:Plates, 5:Grid]
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

module base_body(hole_r, hole_d) {
    difference() {
        // the dimensions are constant and equal to a 25mm base I modeled in blendered years ago
        // I want this model to be a copy of that base
        difference() {
            scale([1, 1, 0.62]) sphere(r=25 / 2, $fn=50);
            union() {
                translate([0, 0, 5+2.5]) cube([30, 30, 10], center=true);
                translate([0, 0, -5]) cube([30, 30, 10], center=true);
                if(hole_r > 0) {
                    cylinder(h=2*hole_d, r=hole_r, center=true);
                }
            }
        }
    }
}

module magnet_encase(magnet_d, magnet_h, encase_d, encase_h) {
    difference() {
        cylinder(d=encase_d, h=encase_h);
        cylinder(d=magnet_d, h=magnet_h*2, $fn=100, center=true);
    }
}

////////////////////// plain surface
module base_plain(base_w, magnet_d, magnet_h) {
    scale([base_w / 25, base_w / 25, 1]) {
        union() {
            base_body(hole_r, hole_d);
            translate([0, 0, 2.11]) cylinder(h=base_upper_h, r=base_upper_r);
        }
    }
    magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}
module base_plain_horses(base_w1, base_w2, magnet_d, magnet_h) {
    scale([base_w1 / 25, base_w2 / 25, 1]) {
        union() {
            base_body(hole_r, hole_d);
            translate([0, 0, 2.11]) cylinder(h=base_upper_h, r=base_upper_r);
        }
    }
    translate([0, base_w2/4, 0]) magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
    translate([0, -base_w2/4, 0]) magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}

////////////////////// bricks surface
module brick(x, y, h, r=1, fn=16, f=brick_f) {
    /* A brick using hull()
    hull() {
        translate([-x/2, -y/2, base_upper_h/2]) sphere(r=0.5, $fn=12);
        translate([x/2, -y/2, base_upper_h/2]) sphere(r=0.5, $fn=12);
        translate([x/2, y/2, base_upper_h/2]) sphere(r=0.5, $fn=12);
        translate([-x/2, y/2, base_upper_h/2]) sphere(r=0.5, $fn=12);
        
        translate([-x/2, -y/2, -base_upper_h/2]) sphere(r=0.5, $fn=12);
        translate([x/2, -y/2, -base_upper_h/2]) sphere(r=0.5, $fn=12);
        translate([x/2, y/2, -base_upper_h/2]) sphere(r=0.5, $fn=12);
        translate([-x/2, y/2, -base_upper_h/2]) sphere(r=0.5, $fn=12);
    }*/
    
    /* A brick using simple shapes. Faster? */
    translate([r, r, -r]) union() {
        translate([0, 0, r]) sphere(r=r, $fn=fn);
        translate([x-2*r, 0, r]) sphere(r=r, $fn=fn);
        translate([0, y-2*r, r]) sphere(r=r, $fn=fn);
        translate([x-2*r, y-2*r, r]) sphere(r=r, $fn=fn);
        
        translate([0, y-2*r, r]) rotate([90, 0, 0]) rotate([0, 0, 180/fn]) cylinder(r=r, h=y-2*r, $fn=fn);
        translate([x-2*r, y-2*r, r]) rotate([90, 0, 0]) rotate([0, 0, 180/fn]) cylinder(r=r, h=y-2*r, $fn=fn);
        
        translate([0, y-2*r, r]) rotate([0, 90, 0]) rotate([0, 0, 180/fn]) cylinder(r=r, h=x-2*r, $fn=fn);
        translate([0, 0, r]) rotate([0, 90, 0]) rotate([0, 0, 180/fn]) cylinder(r=r, h=x-2*r, $fn=fn);
        
        translate([0, 0, 0]) cube([x-2*r, y-2*r, r*2*f]);
    }
    
    /* A brick using a cuboid
    You also need:
    include <BOSL/constants.scad>
    use <BOSL/shapes.scad>
    cuboid([x,y,h], fillet=0.5);
    */
}
module bricks_surface(brick_x, brick_y, brick_o, base_w, base_w2, sep_x=1.2, sep_y=1.2, brick_r=1) {
    intersection() {
        // brick_x, brick_y: size of the brick
        // brick_o: offset of each line of the brick
        // base_w: size of the base
        scale([base_w/25, base_w2/25, 1]) cylinder(h=10, r=base_upper_r);
        first_x = base_w / brick_x / 2 + 1;
        first_y = base_w2 / brick_y / 2;
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
module base_bricks(base_w, magnet_d, magnet_h) {
    scale([base_w / 25, base_w / 25, 1]) base_body(hole_r, hole_d);
    translate([0, 0, 2.11]) {
        // use these number for the custom brick
        bricks_surface(brick_x, brick_y, brick_offset, base_w, base_w, brick_sep_x, brick_sep_y);
        // use these numbers for the hull() brick
        //bricks_surface(5.6, 3.9, 3.1, base_w, base_w, 1.2, 1.3);
    }
    magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}
module base_bricks_horses (base_w1, base_w2, magnet_d, magnet_h) {
    union() {
        scale([base_w/25, base_w2/25, 1]) base_body(hole_r, hole_d);
        translate([0, 0, 2.11]) {
            // use these number for the custom brick
            bricks_surface(brick_x, brick_y, brick_offset, base_w, base_w2, brick_sep_x, brick_sep_y);
            // use these numbers for the hull() brick
            // bricks_surface(5.6, 3 * 25 / base_w2, base_w2, 3.1, 25, 1.2, 1.7);
        }
    }
    translate([0, base_w2/4, 0]) magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
    translate([0, -base_w2/4, 0]) magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}
module base_plates(base_w, magnet_d, magnet_h) {
    scale([base_w / 25, base_w / 25, 1]) base_body(hole_r, hole_d);
    translate([0, 0, 2.11]) {
        
        // use these number for the custom brick
        bricks_surface(10, 10, 0, base_w, base_w, 0.99, 0.99);
        // use these numbers for the hull() brick
        //bricks_surface(10, 10, 0, base_w);
    }
    magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}

////////////////////// grill surface
module grill_surface(grill_w, grill_s, base_w) {
    intersection() {
        cylinder(h=10, r=base_upper_r * base_w / 25);
        first_x = base_w / grill_w / 2 + 1;
        union() {
            for(i=[-first_x:first_x]) {
                translate([i*grill_w, -base_w/2, 0]) cube([grill_s, base_w*2, base_upper_h]);
                translate([-base_w/2, i*grill_w, 0]) cube([base_w*2, grill_s,  base_upper_h]);
            }
        }
    }
}
module base_grill(base_w, magnet_d, magnet_h) {
    scale([base_w / 25, base_w / 25, 1]) {
        union() {
            base_body(hole_r, hole_d);
        }
    }
    translate([0, 0, 2.11]) grill_surface(2, 0.5, base_w);
    magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}

//////////////////////////////// bricks

module base(base_texture, base_w, magnet_d, magnet_h) {
    if(base_texture == 0) { // plain
        base_plain(base_w, magnet_d, magnet_h);
    }
    if(base_texture == 1) { // plain horses
        base_plain_horses(base_w, base_w2, magnet_d, magnet_h);
    }
    if(base_texture == 2) { // bricks
        base_bricks(base_w, magnet_d, magnet_h);
    }
    if(base_texture == 3) { // bricks horses
        base_bricks_horses(base_w, base_w2, magnet_d, magnet_h);
    }
    if(base_texture == 4) { // plates
        base_plates(base_w, magnet_d, magnet_h);
    }
    if(base_texture == 5) { // grill
        base_grill(base_w, magnet_d, magnet_h);
    }
}

base(base_texture, base_w, magnet_d, magnet_h);





