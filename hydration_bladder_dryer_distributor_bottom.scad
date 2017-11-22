use <box_tube_modules.scad>
include <hydration_bladder_dryer_common.scad>
include <hydration_bladder_dryer_distributor_common.scad>

renderResolution=10;
roundness = 1;
$fn=15;

overlap=0.007;

// Use this to move the intake port a bit to align it
// between the holes in the bottom plate.
intakeOffsetTuningAdjust=1.15;

distributorHeadHoleDia=6;
holeColumns=2;
holeRows=8;

plateThickness=2;

hullCenterSize=10;

bottomInsertInsetAmount=2;


lowerPlateThickness=2; 

cutoutSides=6;

intakePortHeight=15;

tubeInnerWidth=tubeTowerWidth-towerWallThickness*2;
tubeInnerLength=tubeTowerLength-towerWallThickness*2;

tubeSlipOverlap=5;
tubeSlipHeight=20;

intakeCenteringOffsetX=distributorHeadWidth/2-tubeTowerWidth/2;
intakeOffsetY = distributorHeadLength/5 + intakeOffsetTuningAdjust;

bottomPartInsertWidth=distributorHeadWidth-bottomPartInsetX*2;
bottomPartInsertLength=distributorHeadLength-bottomPartInsetY*2;

bottomPartInsertToleranceGap=0.5;  // mm
bottomPartInsertToleranceScaleX=(bottomPartInsertWidth-2*bottomPartInsertToleranceGap)/
        bottomPartInsertWidth;
bottomPartInsertToleranceScaleY=(bottomPartInsertLength-2*bottomPartInsertToleranceGap)/
        bottomPartInsertLength;
echo(concat("bottomPartInsertToleranceScaleX: ", bottomPartInsertToleranceScaleX));
echo(concat("bottomPartInsertToleranceScaleY: ", bottomPartInsertToleranceScaleY));

union() {
    difference() {
        union() {
            bottomPartSolid();
            translate([bottomPartInsetX+bottomPartInsertToleranceGap,
                    bottomPartInsetY+bottomPartInsertToleranceGap,
                    lowerPlateThickness-overlap]) {
                // Note: Scaling is done here because the raw
                // full-size bottomPartInsertSolid is used to
                // cut out the hole in the other part.
                scale([bottomPartInsertToleranceScaleX,
                        bottomPartInsertToleranceScaleY,1]) {
                    bottomPartInsertSolid();
                }
            }
        }
        // holes
        translate([0,0,-overlap])
            holes(holeColumns, holeRows, distributorHeadHoleDia, distributorHeadWidth, distributorHeadLength, 
                    lowerPlateThickness*2+overlap*2, 6, true);
        // intake opening
        translate([intakeCenteringOffsetX, 
                intakeOffsetY, -overlap])
            cube([tubeTowerWidth-overlap*2,
                tubeTowerLength-overlap*2,
                    lowerPlateThickness*2+overlap*2]);
    }
    slipTolerance=0.5;
    translate([intakeCenteringOffsetX-(towerWallThickness+slipTolerance),
            intakeOffsetY-(towerWallThickness+slipTolerance)+overlap,
            -tubeSlipHeight-intakePortHeight+lowerPlateThickness*2]) {
        boxTubeReduction(tubeTowerWidth,tubeTowerLength,
                towerWallThickness,slipTolerance,
                intakePortHeight,tubeSlipHeight,
                tubeSlipOverlap, overlap);
    }

}

module bottomPartSolid() {
    diskEndedPlate(distributorHeadWidth, distributorHeadLength, lowerPlateThickness);
}

// Note: This is used by the other half to cut the hole for it
//  so it is not reduced yet here.
module bottomPartInsertSolid() {
    diskEndedPlate(bottomPartInsertWidth, 
            bottomPartInsertLength, 
            lowerPlateThickness);
}


