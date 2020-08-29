package nl.benmens.cellsimulation;

import java.util.ArrayList;

import nl.benmens.processing.PApplet;
import nl.benmens.processing.SharedPApplet;

class CellView extends ViewBase {
  float HAND_CIRCLE_RADIUS = 28;
  float HAND_CIRCLE_WIDTH = 1.3f;
  float HAND_SIZE = 6.5f;

  final float WALL_SIZE_ON_MAX_HEALTH = 10;
  final float ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY = 8;

  CellModel cellModel;

  float handAnchorAngle;
  float handPointerRadiusInward;
  float handPointerRadiusOutward;

  boolean isDisabled = false;

  CellView(ViewBase parentView, CellModel cellModel) {
    super(parentView);

    this.cellModel = cellModel;

    this.setBoundsRect(0, 0, 100, 100);

    this.shouldClip = true;

    this.handAnchorAngle = PApplet.asin(HAND_SIZE / 2 / HAND_CIRCLE_RADIUS);

    float handPointerDistainceFromCircle = (1 - PApplet.cos(handAnchorAngle)) * HAND_CIRCLE_RADIUS;
    float handPointerHeight = PApplet.sqrt(PApplet.sq(HAND_SIZE) - PApplet.sq(HAND_SIZE) / 4);

    this.handPointerRadiusInward = HAND_CIRCLE_RADIUS - handPointerDistainceFromCircle - handPointerHeight;
    this.handPointerRadiusOutward = HAND_CIRCLE_RADIUS - handPointerDistainceFromCircle + handPointerHeight;
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

  public void beforeDrawChildren() {
    float screenSize = composedScale().x * 100;
    makeChildsInvisible();

    if (screenSize < 10) {
      SharedPApplet.noStroke();
      SharedPApplet.fill(255, 165, 135);
      SharedPApplet.rect(0, 0, 100, 100);

    } else {
      SharedPApplet.noStroke();
      SharedPApplet.fill(250, 90, 70);
      SharedPApplet.rect(0, 0, 100, 100);

      if (cellModel.edited == true) {
        SharedPApplet.fill(115, 230, 155);

      } else if (!isDisabled && cellModel.isSelected()) {
        SharedPApplet.fill(35, 225, 230);

      } else {
        SharedPApplet.fill(255, 165, 135);
      }
      float wallSize = cellModel.wallHealth * WALL_SIZE_ON_MAX_HEALTH;
      SharedPApplet.rect(wallSize, wallSize, 100 - 2 * wallSize, 100 - 2 * wallSize);

      if (screenSize > 15) {
        makeChildsVisible();

        SharedPApplet.fill(0);
        SharedPApplet.noStroke();
        SharedPApplet.ellipse(50, 50, 2 * ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY, 2 * ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY);

        if (screenSize > 45) {
          float energySymbolSize = cellModel.energyLevel * ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY;

          SharedPApplet.noStroke();
          SharedPApplet.fill(245, 245, 115);
          SharedPApplet.beginShape();
          SharedPApplet.vertex(50 - 0.00f * energySymbolSize, 50 - 1.00f * energySymbolSize);
          SharedPApplet.vertex(50 - 0.48f * energySymbolSize, 50 + 0.12f * energySymbolSize);
          SharedPApplet.vertex(50 + 0.15f * energySymbolSize, 50 + 0.15f * energySymbolSize);
          SharedPApplet.vertex(50 - 0.00f * energySymbolSize, 50 + 1.00f * energySymbolSize);
          SharedPApplet.vertex(50 + 0.48f * energySymbolSize, 50 - 0.12f * energySymbolSize);
          SharedPApplet.vertex(50 - 0.15f * energySymbolSize, 50 - 0.15f * energySymbolSize);
          SharedPApplet.endShape(PApplet.CLOSE);

          if (screenSize > 80) {
            float progressToNextCodonTick = PApplet.norm(cellModel.ticksSinceLastCodonTick, 0, cellModel.ticksPerCodonTick);
            ArrayList<CodonBaseModel> codonModels = (ArrayList<CodonBaseModel>) cellModel.codonModels.clone();

            // calculating codon hand angle
            float codonHandAngle = 0;
            if (cellModel.codonModels.size() != 0) {
              float currentCodonAngle = codonModels
                  .get(cellModel.currentCodon % codonModels.size()).segmentAngleInCodonCircle;
              float nextCodonAngle = codonModels
                  .get((cellModel.currentCodon + 1) % codonModels.size()).segmentAngleInCodonCircle;
              if (cellModel.currentCodon >= codonModels.size()) {
                currentCodonAngle += PApplet.TWO_PI;
              }
              if (cellModel.currentCodon + 1 >= codonModels.size()) {
                nextCodonAngle += PApplet.TWO_PI;
              }

              codonHandAngle = smoothLerp(currentCodonAngle, nextCodonAngle, 0.1f, 0.8f, progressToNextCodonTick);
            }

            // drawing codon hand
            float x1 = 50 + PApplet.sin(codonHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;
            float y1 = 50 - PApplet.cos(codonHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;

            float x2 = 50 + PApplet.sin(codonHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;
            float y2 = 50 - PApplet.cos(codonHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;

            float x3 = 50 + PApplet.sin(codonHandAngle) * handPointerRadiusInward;
            float y3 = 50 - PApplet.cos(codonHandAngle) * handPointerRadiusInward;

            SharedPApplet.noStroke();
            SharedPApplet.fill(200, 0, 0);
            SharedPApplet.triangle(x1, y1, x2, y2, x3, y3);

            // calculating execution hand angle
            float executeHandAngle = 0;
            if (cellModel.codonModels.size() != 0) {
              float previousCodonAngle = cellModel.codonModels
                  .get(cellModel.previousExecuteHandPosition).segmentAngleInCodonCircle;
              float currentCodonAngle = cellModel.codonModels
                  .get(cellModel.executeHandPosition).segmentAngleInCodonCircle;
              if (currentCodonAngle < previousCodonAngle) {
                currentCodonAngle += PApplet.TWO_PI;
              }

              executeHandAngle = smoothLerp(previousCodonAngle, currentCodonAngle, 0.05f, 0.95f,
                  progressToNextCodonTick);
            }

            // calculating execution hand pointer radius
            float previousExecuteHandPointerRadius = (cellModel.previousIsExecuteHandPointingOutward)
                ? handPointerRadiusOutward
                : handPointerRadiusInward;
            float currentExecuteHandPointerRadius = (cellModel.isExecuteHandPointingOutward)
                ? handPointerRadiusOutward
                : handPointerRadiusInward;
            float executeHandPointerRadius = smoothLerp(previousExecuteHandPointerRadius,
                currentExecuteHandPointerRadius, 0.05f, 0.95f, progressToNextCodonTick);

            // drawing execution hand
            x1 = 50 + PApplet.sin(executeHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;
            y1 = 50 - PApplet.cos(executeHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;

            x2 = 50 + PApplet.sin(executeHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;
            y2 = 50 - PApplet.cos(executeHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;

            x3 = 50 + PApplet.sin(executeHandAngle) * executeHandPointerRadius;
            y3 = 50 - PApplet.cos(executeHandAngle) * executeHandPointerRadius;

            SharedPApplet.noStroke();
            SharedPApplet.fill(0, 200, 0);
            SharedPApplet.triangle(x1, y1, x2, y2, x3, y3);
          }

          SharedPApplet.strokeWeight(HAND_CIRCLE_WIDTH);
          SharedPApplet.stroke(0, 150, 0);
          SharedPApplet.noFill();
          SharedPApplet.ellipse(50, 50, HAND_CIRCLE_RADIUS * 2, HAND_CIRCLE_RADIUS * 2);
        }
      }
    }
  }

  public boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
    if (mousePressed && !isDisabled) {
      if (getBoundsRect().contains(mouseX, mouseY)) {
        if (cellModel.isSelected()) {
          cellModel.unSelectCell();
        } else {
          cellModel.selectCell();
        }
        return true;
      } else {
        cellModel.unSelectCell();
        return false;
      }
    }

    return false;
  }

}