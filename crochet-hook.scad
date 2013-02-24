hooksize = 6.1;
d = hooksize;
r = hooksize/2;
length_above_grip = hooksize * 7.5;   // measured from the centre-point of the grip
length_below_grip = hooksize * 12; // measured from the centre-point of the grip
length = length_above_grip + length_below_grip;
hook_lower_angle = 80;
hook_upper_angle = 30;
grip_length = 20;
grip_slope=5;
grip_depth=d/5;

// Right-angled triangle with interior angle <angle>.
module triangle(radius, angle)
{
  o=radius*sin(angle);
  a=radius*cos(angle);
  polygon(points=[[0,0], [a,0], [a,o]]);
}

// module triangle_prism() copied from:
// https://github.com/elmom/MCAD/blob/master/regular_shapes.scad
module triangle_prism(height, radius, angle)
{
  linear_extrude(height=height, center = true) triangle(radius, angle);
}

module trapezium_prism(trap_height, flat_width, slope_width, height)
{
  max_x = slope_width + flat_width/2;
  linear_extrude(height=height, center=true)
    polygon(points=[[-max_x, 0],
                    [-flat_width/2, trap_height],
                    [flat_width/2, trap_height],
                    [max_x, 0]]);
}

module grip()
{
	trapezium_prism(grip_depth, grip_length, grip_slope, d);
}

rotate(a=[90, 0, 0])
        difference()
        {
                union()
                {
                        translate (v=[0, 0, length_above_grip])
                                scale([1.0, 1.0, 2.0])
                                sphere(r = r, anglesteps = 10, sweepsteps = 10);
                        translate (v=[0, 0, -length_below_grip])
                                cylinder(r = r, h = length);
                }
                translate (v= [0 , -r/4, length_above_grip])
                        rotate(a=[270, 0, 90])
                        difference() {
                                triangle_prism(d, 4*d, hook_lower_angle);
                                triangle_prism(d, 4*d, hook_upper_angle);
                        }
		translate([0, r, 0])
			rotate(a=[0, 90, 180])
				grip();
		translate([0, -r, 0])
			rotate(a=[0, 90, 0])
				grip();
        }
