import java.awt.geom.Rectangle2D;


class CodonView extends ViewBase {
    final float SEGMENT_SPACING_PERCENTAGE = 0.2;
    final float SEGMENT_CIRCLE_INNER_RADIUS = 10;
    final float SEGMENT_CIRCLE_OUTER_RADIUS = 20;

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
            float secondVertexAngle = codonModel.segmentAngleInCodonCircle;
            float firstVertexAngle = secondVertexAngle + (0.5 * SEGMENT_SPACING_PERCENTAGE - 0.5) * codonModel.segmentSizeInCodonCircle;
            float thirdVertexAngle = secondVertexAngle + (0.5 - 0.5 * SEGMENT_SPACING_PERCENTAGE) * codonModel.segmentSizeInCodonCircle;

            float segmentCircleBetweenRadius = lerp(SEGMENT_CIRCLE_INNER_RADIUS, SEGMENT_CIRCLE_OUTER_RADIUS, 0.5);
            float segmentCircleInnerDegradationRadius = lerp(SEGMENT_CIRCLE_INNER_RADIUS, segmentCircleBetweenRadius, codonModel.getDegradation());
            float segmentCircleOuterDegradationRadius = lerp(SEGMENT_CIRCLE_OUTER_RADIUS, segmentCircleBetweenRadius, codonModel.getDegradation());
            
            float sinFirstVertexAngle = sin(firstVertexAngle);
            float sinSecondVertexAngle = sin(secondVertexAngle);
            float sinThirdVertexAngle = sin(thirdVertexAngle);
            float cosFirstVertexAngle = cos(firstVertexAngle);
            float cosSecondVertexAngle = cos(secondVertexAngle);
            float cosThirdVertexAngle = cos(thirdVertexAngle);

            noStroke();
            fill(color(0));
            beginShape();
            vertex(sinSecondVertexAngle * SEGMENT_CIRCLE_INNER_RADIUS, -cosSecondVertexAngle * SEGMENT_CIRCLE_INNER_RADIUS);
            vertex(sinFirstVertexAngle * segmentCircleBetweenRadius, -cosFirstVertexAngle * segmentCircleBetweenRadius);
            vertex(sinSecondVertexAngle * SEGMENT_CIRCLE_OUTER_RADIUS, -cosSecondVertexAngle * SEGMENT_CIRCLE_OUTER_RADIUS);
            vertex(sinThirdVertexAngle * segmentCircleBetweenRadius, -cosThirdVertexAngle * segmentCircleBetweenRadius);
            endShape(CLOSE);

            if (codonModel.getMainColor() != color(0)) {
                fill(codonModel.getMainColor());
                beginShape();
                vertex(sinFirstVertexAngle * segmentCircleBetweenRadius, -cosFirstVertexAngle * segmentCircleBetweenRadius);
                vertex(sinSecondVertexAngle * segmentCircleOuterDegradationRadius, -cosSecondVertexAngle * segmentCircleOuterDegradationRadius);
                vertex(sinThirdVertexAngle * segmentCircleBetweenRadius, -cosThirdVertexAngle * segmentCircleBetweenRadius);
                endShape(CLOSE);
            }

            if (codonModel.getSecondaryColor() != color(0)) {
                fill(codonModel.getSecondaryColor());
                beginShape();
                vertex(sinSecondVertexAngle * segmentCircleInnerDegradationRadius, -cosSecondVertexAngle * segmentCircleInnerDegradationRadius);
                vertex(sinFirstVertexAngle * segmentCircleBetweenRadius, -cosFirstVertexAngle * segmentCircleBetweenRadius);
                vertex(sinThirdVertexAngle * segmentCircleBetweenRadius, -cosThirdVertexAngle * segmentCircleBetweenRadius);
                endShape(CLOSE);
            }

        } else if (screenSize > 35) {
            float segmentCircleRadius = SEGMENT_CIRCLE_OUTER_RADIUS - SEGMENT_CIRCLE_INNER_RADIUS;

            pushMatrix();
            rotate(codonModel.segmentAngleInCodonCircle + PI);

            stroke(lerpColor(codonModel.getMainColor(), color(0), codonModel.getDegradation()));
            strokeWeight(segmentCircleRadius * 0.5);
            point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.75);

            stroke(lerpColor(codonModel.getSecondaryColor(), color(0), codonModel.getDegradation()));
            strokeWeight(segmentCircleRadius * 0.5);
            point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.25);
            popMatrix();
        }
    }
}
