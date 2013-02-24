hooksize = 6.1;
d = hooksize;
r = hooksize/2;
h = hooksize * 15;

// module triangle() & module triangle_prism() copied from:
// https://github.com/elmom/MCAD/blob/master/regular_shapes.scad
// 
module triangle(radius)
{
  o=radius/2;		//equivalent to radius*sin(30)
  a=radius*sqrt(3)/2;	//equivalent to radius*cos(30)
  polygon(points=[[-a,-o],[0,radius],[a,-o]],paths=[[0,1,2]]);
}

module triangle_prism(height,radius)
{
  linear_extrude(height=height, center = true) triangle(radius, center = true);
}

smallradius = r;
largeradius = smallradius * Cphi; 
cutout_angle=15;

difference()
{
	union()
	{
		translate (v=[0,0,h/2]) sphere(r = r, anglesteps = 10, sweepsteps = 10);
		cylinder(r = r, h = h, center = true);
	}
	translate (v= [0 , r*1.6 ,h/2-d]) rotate(a=[cutout_angle,0,0]) rotate(a=[0,90,0]) triangle_prism(d, d*1.2);
}
