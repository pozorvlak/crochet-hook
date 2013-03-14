/* [Overall size] */
// The diameter of the hook
diameter = 6; // [2.00:US - UK 14, 2.25:US 1/B UK 13, 2.50:US - UK 12, 2.75:US C UK 11, 3.00:US - UK 11, 3.25:US D UK 10, 3.50:US 4/E UK 9, 3.75:US F UK -, 4.00:US 6 UK 8, 4.25:US G UK -, 4.50:US 7 UK 7, 5.00:US 8/H UK 6, 5.50:US 9/I UK 5, 6.00:US 10/J UK 4, 6.50:US 10.5/K UK 3, 7.00:US - UK 2, 8.00:US - UK 0, 9.00:US 15/N UK 00, 10.00:US P UK 000, 16:US Q UK -]
d = diameter;
r = diameter/2;
length = 150; // [30:300]
/* [Hook and throat] */
// How sharply the throat slopes down from the shaft (in degrees)
throat_angle = 10;
hook_lower_angle = 90 - throat_angle;
// The length of the pointy curled-over bit
hook_length = 5;
// How long the narrowed section at the point is
narrowing_length = 10;
// How long the sloping section from shaft to narrowing is
narrowing_slope = 20;
// How much the throat narrows on each side, as a fraction of the diameter
narrowing_ratio = 0.16;
narrowing_depth = d * narrowing_ratio;
// [Thumb rest]
// The length of the thumb rest
grip_length = 20;
// How long the sloping sections from shaft and handle to thumb rest are
grip_slope=5;
// How thick the thumb rest is, as a fraction of the diameter
grip_thickness = 0.6;
grip_depth=d * (1 - grip_thickness)/2;
// Distance from the centre-point of the thumb rest to the tip of the point
length_above_grip = 60;
// measured from the centre-point of the thumb rest to the end of the handle
length_below_grip = length - length_above_grip;
/* [Hidden] */
hook_upper_angle = 0;

$fn = 30;

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

module grip_side()
{
	trapezium_prism(grip_depth, grip_length, grip_slope, d);
}

module grip()
{
        translate([0, r, 0])
                rotate(a=[0, 90, 180])
                        grip_side();
        translate([0, -r, 0])
                rotate(a=[0, 90, 0])
                        grip_side();
}

module narrowing_side()
{
	trapezium_prism(narrowing_depth, narrowing_length, narrowing_slope, d);
}

module narrowing()
{
        translate(v=[r, 0, length_above_grip])
                rotate(a=[-90, 90, 0])
                        narrowing_side();
        translate(v=[-r, 0, length_above_grip])
                rotate(a=[-90, 90, 180])
                        narrowing_side();
}

module outer_shell()
{
        union()
        {
                translate (v=[0, 0, length_above_grip])
                        scale([1.0, 1.0, 2.0])
                        sphere(r = r, anglesteps = 10, sweepsteps = 10);
                translate (v=[0, 0, -length_below_grip])
                        cylinder(r = r, h = length);
        }
}

module throat()
{
        translate (v= [0 , -r/4, length_above_grip])
                rotate(a=[270, 0, 90])
                difference() {
                        triangle_prism(d, 4*d, hook_lower_angle);
                        triangle_prism(d, 4*d, hook_upper_angle);
                }
}

module hook()
{
        intersection() {
                outer_shell();
                translate(v=[0, r, length_above_grip - hook_length])
                        cylinder(h=hook_length, r1=0, r2=r, center=false);
        }
}

rotate(a=[90, 0, 0]) {
        difference() {
                union() {
                        difference()
                        {
                                outer_shell();
                                throat();
                                grip();
                        }
                        hook();
                }
		// Narrow the head, for Greater Pointiness
                narrowing();
        }
}
