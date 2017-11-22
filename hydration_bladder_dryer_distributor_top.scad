include <hydration_bladder_dryer_distributor_common.scad>
use <hydration_bladder_dryer_distributor_bottom.scad>

renderResolution=10;
roundness = 1;
$fn=15;

overlap=0.007;

spreaderTipHeight=20;

distributorHeadHoleDia=5;
holeColumns=2;
holeRows=8;

baseCornerInset=5;
baseThickness=10;
hullCenterSize=10;

innerAirPocketWidthPercent=0.75;
innerAirPocketLengthPercent=0.85;
innerAirPocketThicknessPercent=0.70;

cutoutSides=6;

innerAirPocketXOffset = ((1-innerAirPocketWidthPercent)/2)*distributorHeadWidth;
innerAirPocketYOffset = ((1-innerAirPocketLengthPercent)/2)*distributorHeadLength;
innerAirPocketZOffset = ((1-innerAirPocketThicknessPercent)/2)*baseThickness;

intakePortWidth=19;
intakePortLength=30;

difference() {
    difference() {  // cut out innerAirPocket
        union() {
            spreaderPoint(0, 0, 0);
            spreaderPoint(90, distributorHeadWidth+baseCornerInset*2, 0);
            spreaderPoint(180, distributorHeadWidth+baseCornerInset*2,
                   distributorHeadLength+baseCornerInset*2);
            spreaderPoint(270, 0, distributorHeadLength+baseCornerInset*2);

            // Base
            translate([baseCornerInset, baseCornerInset, 0])
            difference() {
                diskEndedPlate(distributorHeadWidth, 
                        distributorHeadLength, baseThickness); 
                // holes            
                holes(holeColumns, holeRows, distributorHeadHoleDia, 
                        distributorHeadWidth, distributorHeadLength, 
                        baseThickness, 6, true);
            }
        }
        translate([baseCornerInset, baseCornerInset, 0])
        translate([innerAirPocketXOffset, 
            innerAirPocketYOffset, 
            innerAirPocketZOffset])
        scale([innerAirPocketWidthPercent, innerAirPocketLengthPercent, 
                innerAirPocketThicknessPercent]) {
            diskEndedPlate(distributorHeadWidth, distributorHeadLength, 
                    baseThickness);     
        }
        
    }
    // TODO: Cut out for bottom part here.
    translate([baseCornerInset+bottomPartInsetX,
            baseCornerInset+bottomPartInsetY,-overlap])
        scale([1,1,1.1]) 
            bottomPartInsertSolid();
}

module intakePort() {
    cube([intakePortWidth, intakePortLength, baseThickness/4]);
}

module baseShape() {
    union() {
        translate([distributorHeadWidth/2,distributorHeadWidth/2,0]) 
            cylinder(d=distributorHeadWidth-baseCornerInset*2, h=baseThickness);
        translate([distributorHeadWidth/2,
                distributorHeadLength-distributorHeadWidth/2,0]) 
            cylinder(d=distributorHeadWidth-baseCornerInset*2, h=baseThickness);
        translate([baseCornerInset,distributorHeadWidth/2,0]) 
            cube([distributorHeadWidth-baseCornerInset*2, 
                distributorHeadLength-distributorHeadWidth, baseThickness]);
    }
}

module spreaderPoint(rotation, xOffset, yOffset) {
    translate([xOffset, yOffset, 0]) {
        rotate([0,0,rotation]) {
            hull() {
                translate([0, 0, spreaderTipHeight]) 
                    sphere(r=roundness);
                translate([baseCornerInset, baseCornerInset*2, roundness])
                    sphere(r=roundness);
                translate([baseCornerInset*2, baseCornerInset, roundness])
                    sphere(r=roundness);
                translate([distributorHeadWidth/2-hullCenterSize/2,distributorHeadWidth/2-hullCenterSize/2,0]) 
                    cube([hullCenterSize, hullCenterSize, baseThickness/2]);
            }
        }
    }
}
