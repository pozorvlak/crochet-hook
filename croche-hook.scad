hooksize = 6.1;
d = hooksize;
r = hooksize/2;
h = hooksize * 15;
hook_lower_angle = 80;
hook_upper_angle = 30;

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

rotate(a=[90, 0, 0])
        difference()
        {
                union()
                {
                        translate (v=[0,0,h/2])
                                scale([1.0, 1.0, 2.0])
                                sphere(r = r, anglesteps = 10, sweepsteps = 10);
                        cylinder(r = r, h = h, center = true);
                }
                translate (v= [0 , -r/4, h/2])
                        rotate(a=[270, 0, 90])
                        difference() {
                                triangle_prism(d, 4*d, hook_lower_angle);
                                triangle_prism(d, 4*d, hook_upper_angle);
                        }
        }
