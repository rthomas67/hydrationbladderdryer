translate([50,0,0]) boxTube(20,35,50,1.5);

boxTubeReduction(20,35,2,0.5,75,20,15,0);

module boxTube(innerX, innerY, height, wallThickness) {
    internalOverlap=0.05;
    difference() {
        cube([innerX+wallThickness*2, innerY+wallThickness*2, height]);
        translate([wallThickness, wallThickness, -internalOverlap]) {
            cube([innerX, innerY, height+internalOverlap*2]);
        }
    }
}


/*
 * Creates a larger box tube into which another can insert
 * and a smaller box tube which would insert into the same
 * size opening as the larger box tube.
 *
 * The reason this is factored out as a module is that it
 * isn't trivial to "glue" the inner and outer boxes 
 * together.  Because this is intended to be used for 3D
 * printing, there must be some tolerance allowed for the
 * inner and outer pieces to actually fit together.  This
 * means the inner dimensions of the insertion box tube
 * must be slightly expanded, but the outer dimensions of
 * the smaller box tube cannot be.  This leaves a gap that
 * must be filled with a strategicly translated 3rd box tube
 * that is big enough to overlap both the inner and outer
 * surfaces of that gap and "glue" it together into the same
 * object, but only where the smaller and larger tubes intersect.
 * 
 * This is sorta how it looks in a cross section.
 *
 *        |             |  <--- inner
 *        |             |
 *      |||             |||
 *      |||             |||
 *      |\               /|
 *      | \             / |  <--- outer
 *      |  \__"glue"___/  |
 *
 * overlap = thin margin added to inner and outer dimensions
 *    to make the object merge with exact sized items in
 *    the model to which the object is returned.
 */
module boxTubeReduction(matedWidth, matedLength, 
        wallThickness, toleranceGap, 
        coreTubeLength, slipInsertionDepth,
        coreToSlipOverlapDepth, overlap) {
    internalOverlap=0.05;
    coreTubeInnerWidth=matedWidth-wallThickness*2;
    coreTubeInnerLength=matedLength-wallThickness*2;
    union() {
        boxTube(matedWidth+toleranceGap*2, 
                matedLength+toleranceGap*2, 
                slipInsertionDepth+coreToSlipOverlapDepth,
                wallThickness);
        // Since expanding the slip tube leaves a gap between it
        // and the outer surface of the core tube, the gap needs
        // to be filled to connect the model.
        // Note: The thickness of this tube is 1 * toleranceGap, 
        // but to overlap both outer and inner tubes, it expanded
        // by internalOverlap * 2 and positioned -1 * internalOverlap
        translate([wallThickness-internalOverlap,
                wallThickness-internalOverlap,
                slipInsertionDepth]) {
            // inner size starts at the core tube outer size (width or length
            // + 2x wall thickness) and is shrunk by 1 x slipTolerance, which is
            // really 2 * 1/2 * slipTolerance (i.e. 1/2 on each side * 2 sides).
            boxTube(matedWidth-internalOverlap*2,
                    matedLength-internalOverlap*2,
                    coreToSlipOverlapDepth,
                    toleranceGap+internalOverlap*2);
        }

        /* Core Part of Tube
         * Note: The slip tube internal size is adjusted by "overlap,"
         * so the core tube position must be centered by positioning at
         * -1 overlap in both X and Y directions.
         * Note: Length of core tube accounts for the slip overlap on both ends
         * and it is positioned lower by the slip overlap on one end.
         */
        translate([wallThickness+toleranceGap-overlap,
                wallThickness+toleranceGap-overlap,
                slipInsertionDepth]) {
            boxTube(coreTubeInnerWidth,
                    coreTubeInnerLength, 
                coreTubeLength,
                wallThickness+overlap);
        }
    }
}