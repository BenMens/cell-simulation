package nl.benmens.cellsimulation.codon;

import nl.benmens.processing.PApplet;
import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.View;
import processing.core.PVector;

public class CodonView extends View {
  final float SEGMENT_SPACING_PERCENTAGE = 0.2f;
  final float SEGMENT_CIRCLE_INNER_RADIUS = 10;
  final float SEGMENT_CIRCLE_OUTER_RADIUS = 20;
  final float SEGMENT_CIRCLE_CENTER_RADIUS = PApplet.lerp(SEGMENT_CIRCLE_INNER_RADIUS, SEGMENT_CIRCLE_OUTER_RADIUS, 0.5f);
  final float MAX_CODON_WIDTH = 7;

  CodonBaseModel codonModel;

  CodonView(View parentView, CodonBaseModel codonModel) {
    super(parentView);

    this.codonModel = codonModel;

    this.setBoundsRect(-50, -50, getBoundsRect().width, getBoundsRect().height);
  }

  public void beforeDrawChildren() {
    float screenSize = composedScale().x * 100;
    makeChildsInvisible();

    if (screenSize > 75) {
      float codonWidth = SEGMENT_CIRCLE_CENTER_RADIUS
          * PApplet.tan((0.5f - 0.5f * SEGMENT_SPACING_PERCENTAGE) * codonModel.segmentSizeInCodonCircle);
      codonWidth = PApplet.min(codonWidth, MAX_CODON_WIDTH);

      PVector x1Point = new PVector(-codonWidth, -SEGMENT_CIRCLE_CENTER_RADIUS);
      PVector x2Point = new PVector(codonWidth, -SEGMENT_CIRCLE_CENTER_RADIUS);
      PVector y1Point = new PVector(0, -SEGMENT_CIRCLE_INNER_RADIUS);
      PVector y2Point = new PVector(0, -SEGMENT_CIRCLE_OUTER_RADIUS);

      PVector degradatedY1Point = new PVector(0,
          -PApplet.lerp(SEGMENT_CIRCLE_OUTER_RADIUS, SEGMENT_CIRCLE_CENTER_RADIUS, codonModel.degradation));
      PVector degradatedY2Point = new PVector(0,
          -PApplet.lerp(SEGMENT_CIRCLE_INNER_RADIUS, SEGMENT_CIRCLE_CENTER_RADIUS, codonModel.degradation));

      SharedPApplet.rotate(codonModel.segmentAngleInCodonCircle);

      SharedPApplet.noStroke();
      SharedPApplet.fill(SharedPApplet.color(0));
      SharedPApplet.beginShape();
      SharedPApplet.vertex(x1Point.x, x1Point.y);
      SharedPApplet.vertex(y1Point.x, y1Point.y);
      SharedPApplet.vertex(x2Point.x, x2Point.y);
      SharedPApplet.vertex(y2Point.x, y2Point.y);
      SharedPApplet.endShape(PApplet.CLOSE);

      SharedPApplet.fill(codonModel.getMainColor());
      SharedPApplet.beginShape();
      SharedPApplet.vertex(x1Point.x, x1Point.y);
      SharedPApplet.vertex(x2Point.x, x2Point.y);
      SharedPApplet.vertex(degradatedY1Point.x, degradatedY1Point.y);
      SharedPApplet.endShape(PApplet.CLOSE);

      SharedPApplet.fill(codonModel.getSecondaryColor());
      SharedPApplet.beginShape();
      SharedPApplet.vertex(x1Point.x, x1Point.y);
      SharedPApplet.vertex(x2Point.x, x2Point.y);
      SharedPApplet.vertex(degradatedY2Point.x, degradatedY2Point.y);
      SharedPApplet.endShape(PApplet.CLOSE);

    } else if (screenSize > 35) {
      float segmentCircleRadius = SEGMENT_CIRCLE_OUTER_RADIUS - SEGMENT_CIRCLE_INNER_RADIUS;

      SharedPApplet.pushMatrix();
      SharedPApplet.rotate(codonModel.segmentAngleInCodonCircle + PApplet.PI);

      SharedPApplet.stroke(SharedPApplet.lerpColor(codonModel.getMainColor(), SharedPApplet.color(0), codonModel.degradation));
      SharedPApplet.strokeWeight(segmentCircleRadius * 0.5f);
      SharedPApplet.point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.75f);

      SharedPApplet.stroke(SharedPApplet.lerpColor(codonModel.getSecondaryColor(), SharedPApplet.color(0), codonModel.degradation));
      SharedPApplet.strokeWeight(segmentCircleRadius * 0.5f);
      SharedPApplet.point(0, SEGMENT_CIRCLE_INNER_RADIUS + segmentCircleRadius * 0.25f);
      SharedPApplet.popMatrix();
    }
  }
}