use <box_tube_modules.scad>
include <hydration_bladder_dryer_common.scad>

/*
 * This tube extends the base, or another extension
 * by slipping over the end of the next tube.
 * Note: For now, it's gravity fit, or could be glued.
 * TODO: Add a snap-fit notch or tab of some kind.
 *    Idea: Clip a slot through the corners on the
 *    slip-over part of the tube with a matching notch
 *    on the inserted tube so a paperclip (or any wire
 *    with a bit of springiness) would click in and 
 *    retain the connection.
 */

// Calculated from variables in the common file.
tubeInnerWidth=tubeTowerWidth-towerWallThickness*2;
tubeInnerLength=tubeTowerLength-towerWallThickness*2;

/*
 * This is the amount of height that the tube actually
 * contributes to the overall length of the tube,
 * without the slip/insertion overlapped part.
 * Note: At 100mm each, a normal bladder would require
 * 3 of them stacked up.
 */
tubeCoreHeight=100;

// Specifies how much insertion room there is
tubeSlipInsertionDepth=25;
tubeSlipOverlap=10;

// Millimeters clearance on either side of the box
// "slip" tube to allow a bit of room for the regular
// sized tube to slide in.
slipTolerance=0.6;

overlap=0.05;

// Calculated
tubeSlipInnerWidth=tubeInnerWidth+towerWallThickness*2-overlap*2;
tubeSlipInnerLength=tubeInnerLength+towerWallThickness*2-overlap*2;

/*
 * This creates a stepdown box with enough clearance for
 * one end to slip over the other end.
 */
boxTubeReduction(tubeSlipInnerWidth, tubeSlipInnerLength,
        towerWallThickness, slipTolerance,
        tubeCoreHeight,tubeSlipInsertionDepth,
        tubeSlipOverlap, 0);
        
