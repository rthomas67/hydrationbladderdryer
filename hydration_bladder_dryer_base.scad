include <hydration_bladder_dryer_common.scad>

overlap=0.001;

// Measurements of the blower fan
blowerWidth=53;
blowerHeight=51.2;
fanCenterY=24;
fanCenterZ=26;
fanCenterToMountHole1Y=20;
fanCenterToMountHole2Y=22.5;
fanCenterToMountHole1Z=17.3;
fanCenterToMountHole2Z=21;
fanDia=32;
mountHoleDia=5;

// This pops the top of the insertion 
// hole up a bit so the blower will slide in.
blowerInsertionClearance=2.5;

// COMMON blowerPortWidth=15.5;
blowerPortLength=20;
// COMMON towerWallThickness=2;
intakeWallThickness=4;
intakeSupportHeight=6;

blowerFanCenterToPortCenter=17;

baseWidth=80;
baseLength=110;
baseHeight=5;

// COMMON tubeTowerWidth=blowerPortWidth+(towerWallThickness*2);
// outer dimension of the long side of the tube.
// COMMON tubeTowerLength=35;

tubeTowerBlowerPartHeight=100;

tubeTowerX = (baseWidth/2) - (tubeTowerWidth / 2);
tubeTowerY = (baseLength/3*2) - (tubeTowerLength / 2);

intakeOuterDia=45;
intakeOuterLength=(baseWidth/2) - (tubeTowerWidth/2) + towerWallThickness;
intakeInnerDia=intakeOuterDia-(2 * intakeWallThickness);

intakeAssemblyCenterY=0;  // during assembly the intake is centered on axis
intakeAssemblyCenterZ=intakeSupportHeight + intakeOuterDia/2;

mountPostWidth = 8;
mountPostThickness = 6;
mountPostHoleDia = 5;

// Note: Posts start centered on x-axis, 
//    so y positions apply to the center of the mounting hole
mountPost1Height = intakeAssemblyCenterZ + fanCenterToMountHole1Z;
// Note: post starts centered at X=0
mountPost1X = -(mountPostThickness/2 - towerWallThickness);
mountPost1Y = intakeAssemblyCenterY-fanCenterToMountHole1Y;
mountPost2Height = intakeAssemblyCenterZ-fanCenterToMountHole2Z;
mountPost2X = mountPost1X;
mountPost2Y = intakeAssemblyCenterY+fanCenterToMountHole2Y;

mountHole1Y=intakeAssemblyCenterY-mountPost1Y;
mountHole1Z=10;

mountHole2Y=10;
mountHole2Z=10;


// x position inside the wide side of the tube
// y position right side of the blower inside the narrow side of the tube

// TODO: Figure out how to actually calculate blowerZOffsetFromBase
blowerZOffsetFromBase=2.5;

*translate([tubeTowerX+towerWallThickness, 
        tubeTowerY+intakeAssemblyCenterY-fanCenterY,
        baseHeight+blowerZOffsetFromBase]) {
    blowerPlaceHolder();
}

// base
difference() {
    union() {
        cube([baseWidth, baseLength, baseHeight]);
        translate([2,35,baseHeight-overlap]) {
            rotate([0,0,0]) {
                powerJackMount();
            }
        }

        // Tower tube
        translate([tubeTowerX, tubeTowerY ,baseHeight]) {
            // All of these things are positioned at z=0
            union() {
                difference() {
                    union() {
                        difference() {
                            cube([tubeTowerWidth, 
                                tubeTowerLength, 
                                tubeTowerBlowerPartHeight]);
                            translate([towerWallThickness, 
                                    towerWallThickness, -overlap]) {
                                cube([tubeTowerWidth-2*towerWallThickness, 
                                    tubeTowerLength-2*towerWallThickness, 
                                    tubeTowerBlowerPartHeight + overlap*2]);
                            }
                        }
                        // intake
                        translate([tubeTowerWidth-towerWallThickness+overlap,
                                0,
                                -overlap]) {
                            intake();
                        }
                        
                    }
                    // blower opening
                    translate([towerWallThickness,-overlap,-overlap]) {
                        cube([tubeTowerWidth-towerWallThickness*2,
                            towerWallThickness + overlap*2, 
                                blowerHeight+blowerInsertionClearance]);
                    }
                    // cutout for intake
                    translate([(tubeTowerWidth-towerWallThickness)-overlap, 
                            0, intakeOuterDia/2+intakeSupportHeight]) {
                        rotate([0,90,0]) {
                            cylinder(d=intakeInnerDia, h=towerWallThickness+overlap*2);
                        }
                    }
                    // cutout for mount post 2 and 2b 
                    // (goes all the way through edge of intake)
                    translate([mountPost2X, mountPost2Y, -overlap]) {
                        scale([50,1,1]) {
                            mountPost(mountPostWidth, mountPostThickness, 
                                mountPost2Height, 0);
                        }
                    }

                }
                // Mount Post 1
                translate([mountPost1X, mountPost1Y, 0]) {
                    mountPost(mountPostWidth, mountPostThickness, 
                        mountPost1Height, mountPostHoleDia);
                }

                // Mount Post 2
                translate([mountPost2X, mountPost2Y, 0]) {
                    mountPost(mountPostWidth, mountPostThickness, 
                        mountPost2Height, mountPostHoleDia);
                }
                
                // Mount Post 2b  (through the edge of the intake.
                translate([mountPost2X+(tubeTowerWidth-
                       (towerWallThickness/2))+ intakeOuterLength/2, mountPost2Y, 0]) {
                    mountPost(mountPostWidth, intakeOuterLength, 
                        mountPost2Height, mountPostHoleDia);
                }
            }
        }
    }
    *trialPrintReductionCuts();
}
// ------------------------------------------------------------------
//
//      Modules
//
// ------------------------------------------------------------------
module powerJackMount() {
    powerJackMountBoxThickness=2;
    powerJackMountSurfaceThickness=1.7;
    powerJackMountBoxInnerHeight=14;
    powerJackMountBoxInnerWidth=12;
    powerJackMountBoxLength=25;
    powerJackMountHoleDia=8.5;
    union() {
        difference() {
            cube([powerJackMountBoxInnerWidth+powerJackMountBoxThickness*2,
                powerJackMountBoxLength,
                powerJackMountBoxInnerHeight+powerJackMountBoxThickness*2]);
            translate([powerJackMountBoxThickness,
                    -overlap,
                    powerJackMountBoxThickness]) {
                cube([powerJackMountBoxInnerWidth,
                    powerJackMountBoxLength+overlap*2,
                    powerJackMountBoxInnerHeight]);
            }
        }
        translate([0,powerJackMountBoxLength-overlap,0]) {
            difference() {
                cube([powerJackMountBoxInnerWidth+powerJackMountBoxThickness*2,
                        powerJackMountSurfaceThickness,
                        powerJackMountBoxInnerHeight+powerJackMountBoxThickness*2]);
                translate([(powerJackMountBoxInnerWidth+powerJackMountBoxThickness*2)/2,
                        -overlap,
                        (powerJackMountBoxInnerHeight+powerJackMountBoxThickness*2)/2]) {
                    rotate([-90,0,0]) {
                        cylinder(d=powerJackMountHoleDia, 
                                h=powerJackMountSurfaceThickness+overlap*2);
                    }
                }
            }
        }
    }
} 

module intake() {
    translate([0,0,intakeOuterDia/2 + intakeSupportHeight]) {
        rotate([0, 90, 0]) {
            difference() {
                union() {
                    // Note: multiplier on diameter and $fn work together
                    // here to make the outer surface coarsly faceted.
                    // The purpose is both style, and to be 3D printer friendly
                    intakeOuterSides=12;
                    // Rotation puts flat sides across top and on left and right
                    rotate([0,0,180/intakeOuterSides]) {
                        cylinder(d=intakeOuterDia, h=intakeOuterLength, 
                            $fn=intakeOuterSides);
                    }
                    // Intake Support
                    // Note: Since the outer "cylinder" is made into a polygon
                    // by setting a small number of sides, the actual width
                    // of the base should be the apothem (low/flat-side) radius
                    // The forumla for the apothem, given the radius (r) and
                    // number of sides (n) is:  apothem = r cos (180/n)
                    // So, to make the base and cyl match up exactly...
                    flatSideRadius = intakeOuterDia/2 
                        * cos(180/intakeOuterSides);
                    
                    translate([intakeOuterDia/4 + intakeSupportHeight/2,
                                   0, intakeOuterLength/2]) {
                        cube([intakeOuterDia/2+intakeSupportHeight, 
                            flatSideRadius*2, intakeOuterLength],center=true);
                    }
                }
                // hole for air to pass through
                translate([0,0,-overlap]) {
                    cylinder(d=intakeInnerDia, h=intakeOuterLength+overlap*2);
                }
                // camfer leading edge of intake
                translate([0,0,intakeOuterLength-intakeWallThickness]) {
                    cylinder(d1=intakeInnerDia-overlap, 
                        d2=intakeOuterDia-intakeWallThickness, 
                    h=intakeWallThickness+overlap*2);
                }
            }
        }
    }
}

// blower place holder
module blowerPlaceHolder() {
    difference() {
        color([1,0,0]) cube([blowerPortWidth,blowerWidth,blowerHeight]);
        translate([-1, fanCenterY, fanCenterZ]) 
            rotate([0,90,0]) cylinder(d=fanDia, h=17, $fn=20);
        // mount-hole upper-left
        translate([-1, fanCenterY-fanCenterToMountHole1Y, 
                fanCenterZ+fanCenterToMountHole1Z]) 
            rotate([0,90,0]) cylinder(d=mountHoleDia, h=17, $fn=20);
        // mount-hole lower-right
        translate([-1, fanCenterY+fanCenterToMountHole2Y, 
                fanCenterZ-fanCenterToMountHole2Z]) 
            rotate([0,90,0]) cylinder(d=mountHoleDia, h=17, $fn=20);
    }
}

// mount_post - Creates a post with a hole in the top
// * Hole size is relative to the width of the post
// * argMountPostHeight positions the center of the hole
// * returned object is centered at [0,0] and bottom is at z=0
module mountPost(argMountPostWidth, argMountPostThickness, 
        argMountPostHeight, argMountHoleDia) {
    difference() {
        union() {
            // domed top
            domedTopSides=8;
            // The difference between this and the actual radius must
            // be added to the radius of the outer cylinder
            flatSideRadius = argMountPostWidth/2 
                * cos(180/domedTopSides);
            facetedCylinderShrinkAmount = argMountPostWidth-flatSideRadius*2;
            translate([-argMountPostThickness/2, 0, argMountPostHeight]) {
                rotate([0, 90, 0]) {
                    rotate([0,0,180/domedTopSides]) {
                        cylinder(d=(argMountPostWidth + facetedCylinderShrinkAmount), 
                            h=argMountPostThickness, 
                            $fn=domedTopSides);
                    }
                }
            }
            // column
            translate([-argMountPostThickness/2, -argMountPostWidth/2, 0]) {
                cube([argMountPostThickness, argMountPostWidth, 
                    argMountPostHeight]);
            }
        }
        translate([-argMountPostThickness/2-overlap, 0, argMountPostHeight]) {
            rotate([0, 90, 0]) {
                cylinder(d=argMountHoleDia, 
                    h=argMountPostThickness+(overlap*2), $fn=30);
            }
        }
    }
};

module trialPrintReductionCuts() {
    translate([55,30,20]) cube([500,500,500]); // cut bulk of intake
    translate([0,0,63]) cube([500,500,500]); // cut top
    translate([-1,-1,-1]) cube([500,500,4]); // trim base 1
    translate([-1,-1,-1]) cube([20,500,500]); // trim base 2
    translate([-1,-1,-1]) cube([500,30,500]); // trim base 3
    translate([-1,95,-1]) cube([500,500,500]); // trim base 4
    translate([60,-1,-1]) cube([500,500,500]); // trim base 5
}

