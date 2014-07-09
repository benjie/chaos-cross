circleRadius = 31;
circleHeight = 5;
torusRadius = 2;
arrowLength = 50;
arrowWidth = 8;
arrowHeadLength = 25;
arrowHeadWidth = 15;
arrowHeight = 10;
smallArrowLength = 36;
smallArrowWidth = 6;
smallArrowHeadLength = 18;
smallArrowHeadWidth = 12;
smallArrowHeight = 7;
arrowAngle = 30;
arrowCentreProportion = 1/4;
arrowHeadHeightProportion = 1.1;
fiddle = 0.05;
accuracy = 0.2;

sphereRadius = (circleRadius * circleRadius + circleHeight * circleHeight) / (2 * circleHeight);

module arrowHead(length, width, baseHeight, height) {
  linear_extrude(height = baseHeight+fiddle) {
    polygon([[length, 0], [0, -width/2], [0, width/2]]);
  }
  polyhedron(
    points = [[length, 0, baseHeight], [0, -width/2, baseHeight], [0, width/2, baseHeight], [length * arrowCentreProportion, 0, height]],
    faces = [[0, 1, 3], [1, 2, 3], [2, 0, 3]]
  );
};

module arrow(length, shaftWidth, headLength, headWidth, height) {
  difference() {
	translate([-fiddle, -shaftWidth/2, 0]) {
      cube([fiddle+length - headLength * (1 - arrowCentreProportion), shaftWidth, height], center=false);
	}
	translate([-fiddle*2, 0, height]) {
	rotate([arrowAngle, 0, 0]) {
	translate([0, -shaftWidth, 0]) {
      cube([length - headLength/2+fiddle*3, shaftWidth*2, height], center=false);
    }
    }
    }
	translate([-fiddle*2, 0, height]) {
	rotate([-arrowAngle, 0, 0]) {
	translate([0, -shaftWidth, 0]) {
      cube([length - headLength/2+ fiddle*3, shaftWidth*2, height], center=false);
    }
    }
    }
  }
  translate([length - headLength, 0, 0]) {
    arrowHead(headLength, headWidth, height - tan(arrowAngle) * shaftWidth / 2, height*arrowHeadHeightProportion);
  }
};
//cube([arrowLength - arrowHeadLength/2, arrowBodyWidthFactor*arrowHeadWidth, arrowHeight]);
for(i = [0:3]) {
  rotate([0, 0, i*90]) {
    arrow(arrowLength, arrowWidth, arrowHeadLength, arrowHeadWidth, arrowHeight);
  }
}
rotate(45) {
for(i = [0:3]) {
  rotate([0, 0, i*90]) {
    arrow(smallArrowLength, smallArrowWidth, smallArrowHeadLength, smallArrowHeadWidth, smallArrowHeight);
  }
}
}


intersection() {
  translate([0, 0, 100/2-fiddle]) {
    cube([200, 200, 100], center=true);
  } 
  union() {
    translate([0, 0, -(sphereRadius-circleHeight)]) {
      sphere(r=sphereRadius, $fn = 300*accuracy);
    }
    rotate_extrude(convexity = 10, $fn=128*accuracy) {
    translate([circleRadius, 0, 0]) {
      circle(r = torusRadius, $fn=30*accuracy); 
    }
    }
  }
}

