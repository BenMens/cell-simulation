package nl.benmens.cellsimulation;

import nl.benmens.processing.PApplet;
import nl.benmens.processing.SharedPApplet;
import processing.core.PFont;
import java.awt.geom.Rectangle2D;


public class CellEditorView extends ViewBase {
  CellModel cellModel;

  PFont font;

  final float CODONS_Y_POS = 380f;
  final float CODONS_SPACING = 5f;

  CellEditorView(ViewBase parentView, CellModel cellModel) {
    super(parentView);

    this.cellModel = cellModel;

    this.shouldClip = true;

    font = SharedPApplet.createFont("courrier.dfont", 24);
  }

  public float calculatedCodonsHeight() {
    float verticalSpace = getFrameRect().height - CODONS_Y_POS - 40;
    float codonHeight = (verticalSpace + CODONS_SPACING) / cellModel.codonModels.size() - CODONS_SPACING;
    codonHeight = PApplet.min(codonHeight, 60);

    return codonHeight;
  }

  public void beforeDrawChildren() {
    SharedPApplet.background(10, 10, 10);

    Rectangle2D.Float boundsRect = getBoundsRect();

    SharedPApplet.fill(255);
    SharedPApplet.textFont(font);
    SharedPApplet.textAlign(PApplet.LEFT, PApplet.TOP);

    SharedPApplet.text(String.format("Food #: %d", cellModel.getContainingParticles("food").size()), 250, 20);
    SharedPApplet.text(String.format("Waste #: %d", cellModel.getContainingParticles("waste").size()), 250, 50);

    SharedPApplet.text(String.format("Oxygen: NA"), 20, 234);
    SharedPApplet.text(String.format("Food: NA"), 20, 264);
    SharedPApplet.text(String.format("Energy: %.1f", this.cellModel.energyLevel * 100), 20, 294);
    SharedPApplet.text(String.format("WallHealth: %.1f", this.cellModel.wallHealth * 100), 20, 324);

    float codonHeight = calculatedCodonsHeight();

    float progressToNextCodonTick = PApplet.norm(cellModel.ticksSinceLastCodonTick, 0, cellModel.ticksPerCodonTick);

    if (cellModel.codonModels.size() > 0) {
      float currentCodonPos = cellModel.currentCodon * (codonHeight + CODONS_SPACING) + codonHeight * .5f;
      float nextCodonPos = ((cellModel.currentCodon + 1) % cellModel.codonModels.size())
          * (codonHeight + CODONS_SPACING) + codonHeight * .5f;

      float codonHandYPos = smoothLerp(currentCodonPos, nextCodonPos, 0.1f, 0.8f, progressToNextCodonTick)
          + CODONS_Y_POS;

      SharedPApplet.noStroke();

      SharedPApplet.fill(200, 200, 200);
      SharedPApplet.rect(20, CODONS_Y_POS - 20, boundsRect.width - 40, boundsRect.height - CODONS_Y_POS);

      SharedPApplet.fill(245, 245, 115);

      SharedPApplet.beginShape();
      SharedPApplet.vertex(25, codonHandYPos - 15);
      SharedPApplet.vertex(40, codonHandYPos);
      SharedPApplet.vertex(25, codonHandYPos + 15);
      SharedPApplet.endShape(PApplet.CLOSE);

      SharedPApplet.beginShape();
      SharedPApplet.vertex(boundsRect.width - 25, codonHandYPos - 15);
      SharedPApplet.vertex(boundsRect.width - 40, codonHandYPos);
      SharedPApplet.vertex(boundsRect.width - 25, codonHandYPos + 15);
      SharedPApplet.endShape(PApplet.CLOSE);
    }
  }

  public float smoothLerp(float start, float end, float startLerping, float stopLerping, float fraction) {
    float lerpFraction = 1;

    if (fraction < startLerping) {
      lerpFraction = 0;
    } else if (fraction < stopLerping) {
      lerpFraction = 1 / (1 + PApplet.exp(-PApplet.map(fraction, startLerping, stopLerping, -6, 6)));
    }

    return PApplet.lerp(start, end, lerpFraction);
  }

}