distributorHeadWidth=30;
distributorHeadLength=90;

bottomPartInsetX=2;
bottomPartInsetY=2;

/*
 * Cuts holes in a part that is arranged flat on X/Y plane
 * through a thickness of the z-size.
 */
module holes(columns, rows, dia, partXSize, partYSize, partZSize, 
        holePolySides, enableRotation) {
    // half of the angle for one side (divides 180, not 360)
    // Also note that the same thing CANNOT be done with an
    // if () {} statement here because the value assignment is
    // invisible outside the scope of the if block.
    // See: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/General#Scope_of_variables
    rotationAngle = (enableRotation) ? 180/holePolySides : 0;
    for (x = [1 : 1 : columns]) {
        // The low-y end starts at 2
        //    row 0 would be on the x-axis
        //    row 1 would be through the end with the spreader points
        // The high-y end stops at holeRows+1 to have the right number of rows.
        //    example: holeRows = 8 -> loops 2-9, so 2,3,4,5,6,7,8,9 == 8 rows
        for (y = [2 : 1 : rows+1]) {
            // The spacing of the rows adds 3 non-rows to start and finish
            //    between the spreader tip "end pieces"
            translate([
                    x*(partXSize/(columns+1)),
                    y*(partYSize/(rows+3)),
                    -overlap]) {
                rotate([0,0,rotationAngle]) {
                    cylinder(d=dia, h=partZSize+overlap*2, $fn=holePolySides);    
                }
            }
        }
    }
}

module diskEndedPlate(width, length, thickness) {
    union() {
        translate([width/2,width/2,0]) 
            cylinder(d=width, h=thickness);
        translate([width/2,length-width/2,0]) 
            cylinder(d=width, h=thickness);
        translate([0,width/2,0]) 
            cube([width, 
                length-width, thickness]);
    }
}
