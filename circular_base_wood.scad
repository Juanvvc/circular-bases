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

wood_type=2; // either 1 or 2

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

module wood_floor() {
    scale([0.5, 0.5, 0.5]) {
        translate([0, 3, 0]) {
            // https://www.thingiverse.com/thing:2666441/files
            // License CC BY-NC
            // DungeonWorks
            import("2x2_Wood_Plank_Floor_1.stl", convexity=10);
        }
    }
}


module plank1() {
   // dimensions: 6x0.5x25
    translate([-2, 0, 12.5]) union() {
        intersection(){
            wood_floor();
            translate([2, -8, -15]) cube([6, 8, 30]);
        }
        translate([2, 0, -12.5]) cube([6, 0.5, 25]);
    }
}
module plank2() {
    // dimensions: 6x0.5x25
    translate([-2, 0, 12.5]) union() {
        intersection(){
            translate([8.4, 0, 0]) wood_floor();
            translate([2, -8, -15]) cube([6, 8, 30]);
        }
        translate([2, 0, -12.5]) cube([6, 0.5, 25]);
    }
}
module plank3() {
    // dimensions: 6x0.5x25
    translate([-2, 0, 12.5]) union() {
        intersection(){
            translate([-4.4, 0, 0]) wood_floor();
            translate([2, -8, -15]) cube([6, 8, 30]);
        }
        translate([2, 0, -12.5]) cube([6, 0.5, 25]);
    }
}
module plank4() {
    // dimensions: 6x0.5x25
    translate([-2, 0, 12.5]) union() {
        intersection(){
            translate([14.9, 0, 0]) wood_floor();
            translate([2, -8, -15]) cube([6, 8, 30]);
        }
        translate([2, 0, -12.5]) cube([6, 0.5, 25]);
    }
}


module wood_surface(wood_type=1) {
    intersection() {
        if(wood_type==1) {
            rotate([270, 0, 0]) scale([0.5, 0.75, 0.5]) translate([0, 3, 0]) {
                // https://www.thingiverse.com/thing:2666441/files
                // License CC BY-NC
                // DungeonWorks
                import("2x2_Wood_Plank_Floor_1.stl", convexity=10);
            }
        } else {
            union() {
                translate([-12.4, 7, 0.6]) rotate([270, 0, 0]) plank3();
                translate([-12.4, -18.2, 0.6]) rotate([270, 0, 0]) plank4();
                
                translate([-6.2, -3, 0.6]) rotate([270, 0, 0]) plank3();
                translate([-6.2, -28.2, 0.6]) rotate([270, 0, 0]) plank4();   
                
                translate([0, 7, 0.6]) rotate([270, 0, 0]) plank3();
                translate([0, -18.2, 0.6]) rotate([270, 0, 0]) plank2();
                
                translate([6.2, -3, 0.6]) rotate([270, 0, 0]) plank2();
                translate([6.2, -28.2, 0.6]) rotate([270, 0, 0]) plank4();
            }
        }
        cylinder(r=base_upper_r, h=2);
    }
}
module base_wood(base_w, magnet_d, magnet_h, wood_type) {
    scale([base_w / 25, base_w / 25, 1]) base_body(hole_r, hole_d);
    translate([0, 0, 2.11]) {
        wood_surface(wood_type=wood_type);        
    }
    magnet_encase(magnet_d, magnet_h, magnet_d+4, 2.45);
}

base_wood(base_w, magnet_d, magnet_h, wood_type);




