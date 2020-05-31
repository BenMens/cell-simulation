import java.awt.geom.Rectangle2D;


class CodonView extends ViewBase {
    final float SEGMENT_SPACING_PERCENTAGE = 0.2;
    final float SEGMENT_CIRCLE_INNER_RADIUS = 10;
    final float SEGMENT_CIRCLE_OUTER_RADIUS = 20;
    final float SEGMENT_CIRCLE_CENTER_RADIUS = lerp(SEGMENT_CIRCLE_INNER_RADIUS, SEGMENT_CIRCLE_OUTER_RADIUS, 0.5);
    final float MAX_CODON_WIDTH = 7;

    ArrayList<CodonViewClient> clients = new ArrayList<CodonViewClient>();
    CodonBaseModel codonModel;


    CodonView(ViewBase parentView, CodonBaseModel codonModel) {
        super(parentView);
        
        this.codonModel = codonModel;

        this.boundsRect.x = -50;
        this.boundsRect.y = -50;
    }


    void registerClient(CodonViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(CodonViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        float screenSize = composedScale().x * 100;
        makeChildsInvisible();

        if (screenSize > 75) {
            float codonWidth = SEGMENT_CIRCLE_CENTER_RADIUS * tan((0.5 - 0.5 * SEGMENT_SPACING_PERCENTAGE) * codonModel.segmentSizeInCodonCircle);
            codonWidth = min(codonWidth, MAX_CODON_WIDTH);

            PVector x1Point = new PVector( -codonWidth, -SEGMENT_CIRCLE_CENTER_RADIUS);
            PVector x2Point = new PVector(  codonWidth, -SEGMENT_CIRCLE_CENTER_RADIUS);
            PVector y1Point = new PVector(0, -SEGMENT_CIRCLE_INNER_RADIUS);
            PVector y2Point = new PVector(0, -SEGMENT_CIRCLE_OUTER_RADIUS);

            PVector degradatedY1Point = new PVector(0, -lerp(SEGMENT_CIRCLE_OUTER_RADIUS, SEGMENT_CIRCLE_CENTER_RADIUS, codonModel.degradation));
            PVector degradatedY2Point = new PVector(0, -lerp(SEGMENT_CIRCLE_INNER_RADIUS, SEGMENT_CIRCLE_CENTER_RADIUS, codonModel.degradation));

            float secondVertexAngle = codonModel.segmentAngleInCodonCircle;
            rotate(codonModel.segmentAngleInCodonCircle);

            noStroke();
            fill(color(0));
            beginShape();
            vertex(x1Point.x, x1Point.y);
            vertex(y1Point.x, y1Point.y);
            vertex(x2Point.x, x2Point.y);
            vertex(y2Point.x, y2Point.y);
            endShape(CLOSE);

            fill(codonModel.getMainColor());
            beginShape();
            vertex(x1Point.x, x1Point.y);
            vertex(x2Point.x, x2Point.y);
            vertex(degradatedY1Point.x, degradatedY1Point.y);
            endShape(CLOSE);

            fill(codonModel.getSecondaryColor());
            beginShape();
            vertex(x1Point.x, x1Point.y);
            vertex(x2Point.x, x2Point.y);
            vertex(degradatedY2Point.x, degradatedY2Point.y);
            endShape(CLOSE);

        } else if (screenSize > 35) {
            float segmentCircleRadius = SEGMENT_CIRCLE_OUTER_RADIUS - SEGMENT_CIRCLE_INNER_RADIUS;

            pushMatrix();
            rotate(codonModel.segmentAngleInCodonCircle + PI);

            stroke(lerpColor(codonModel.getMainColor(), color(0), codonModel.degradation));
            strokeWeight(segmentCircleRadius * 0.5);
            point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.75);

            stroke(lerpColor(codonModel.getSecondaryColor(), color(0), codonModel.degradation));
            strokeWeight(segmentCircleRadius * 0.5);
            point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.25);
            popMatrix();
        }
    }
}
