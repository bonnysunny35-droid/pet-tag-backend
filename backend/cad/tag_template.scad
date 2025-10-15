// --- Pet Tag Template (MVP) ---
tag_shape = is_undef(tag_shape) ? "circle" : tag_shape;
tag_diam = is_undef(tag_diam) ? 35 : tag_diam;
thickness = is_undef(thickness) ? 2.5 : thickness;
hole_diam = is_undef(hole_diam) ? 4 : hole_diam;
name_text = is_undef(name_text) ? "BELLA" : name_text;
text_height = is_undef(text_height) ? 0.8 : text_height;
font = is_undef(font) ? "DejaVu Sans:style=Bold" : font;

module base() {
    if (tag_shape == "circle") {
        cylinder(h = thickness, r = tag_diam/2, $fn=96);
    } else if (tag_shape == "heart") {
        union() {
            translate([-tag_diam*0.2,0,0]) cylinder(h=thickness, r=tag_diam*0.22, $fn=64);
            translate([ tag_diam*0.2,0,0]) cylinder(h=thickness, r=tag_diam*0.22, $fn=64);
            translate([0,-tag_diam*0.18,0]) scale([1.1,1.0,1]) cylinder(h=thickness, r1=tag_diam*0.32, r2=0.1, $fn=3);
        }
    } else if (tag_shape == "bone") {
        union() {
            hull() {
                translate([-tag_diam*0.25,0,0]) cylinder(h=thickness, r=tag_diam*0.18, $fn=64);
                translate([ tag_diam*0.25,0,0]) cylinder(h=thickness, r=tag_diam*0.18, $fn=64);
            }
            translate([-tag_diam*0.35,0,0]) cylinder(h=thickness, r=tag_diam*0.18, $fn=64);
            translate([ tag_diam*0.35,0,0]) cylinder(h=thickness, r=tag_diam*0.18, $fn=64);
        }
    } else {
        cylinder(h = thickness, r = tag_diam/2, $fn=96);
    }
}

module hole() {
    translate([0, tag_diam*0.35, 0]) cylinder(h = thickness+0.2, r = hole_diam/2, $fn=48);
}

module name_emboss() {
    linear_extrude(height = text_height)
        text(name_text, font=font, size = tag_diam*0.18, halign="center", valign="center", $fn=24);
}

difference() { base(); hole(); }
translate([0,0,thickness]) name_emboss();
