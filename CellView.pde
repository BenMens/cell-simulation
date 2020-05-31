class CellView extends ViewBase {
    float HAND_CIRCLE_RADIUS = 28;
    float HAND_CIRCLE_WIDTH = 1.3;
    float HAND_SIZE = 6.5;

    final float WALL_SIZE_ON_MAX_HEALTH = 10;
    final float ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY = 8;

    ArrayList<CellViewClient> clients = new ArrayList<CellViewClient>();
    CellModel cellModel;

    float handAnchorAngle;
    float handPointerRadiusInward;
    float handPointerRadiusOutward;


    CellView(ViewBase parentView, CellModel cellModel) {
        super(parentView);
        
        this.cellModel = cellModel;

        this.boundsRect = new Rectangle2D.Float(0, 0, 100, 100);
        
        this.shouldClip = true;

        this.handAnchorAngle = asin(HAND_SIZE / 2 / HAND_CIRCLE_RADIUS);

        float handPointerDistainceFromCircle = (1 - cos(handAnchorAngle)) * HAND_CIRCLE_RADIUS;
        float handPointerHeight = sqrt(sq(HAND_SIZE) - sq(HAND_SIZE) / 4);

        this.handPointerRadiusInward = HAND_CIRCLE_RADIUS - handPointerDistainceFromCircle - handPointerHeight;
        this.handPointerRadiusOutward = HAND_CIRCLE_RADIUS - handPointerDistainceFromCircle + handPointerHeight;
    }


    void registerClient(CellViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }  
    }


    void unregisterClient(CellViewClient client) {
        clients.remove(client);
    }


    float smoothLerp(float start, float end, float startLerping, float stopLerping, float fraction) {
        float lerpFraction = 1;

        if (fraction < startLerping) {
            lerpFraction = 0;
        } else if (fraction < stopLerping) {
            lerpFraction = 1 / (1 + exp(-map(fraction, startLerping, stopLerping, -6, 6)));
        }

        return lerp(start, end, lerpFraction);
    }


    void beforeDrawChildren() {
        float screenSize = composedScale().x * 100;
        makeChildsInvisible();
        
        if(screenSize < 10) {
            noStroke();
            fill(255, 165, 135);
            rect(0, 0, 100, 100);

        } else {
            noStroke();
            fill(250, 90, 70);
            rect(0, 0, 100, 100);

            if (cellModel.edited == true) {
                fill(115, 230, 155);

            } else if (cellModel.isSelected()) {
                fill(35, 225, 230);

            } else {
                fill(255, 165, 135);
            }
            float wallSize = cellModel.wallHealth * WALL_SIZE_ON_MAX_HEALTH;
            rect(wallSize, wallSize, 100 - 2 * wallSize, 100 - 2 * wallSize);

            if(screenSize > 15) {
                makeChildsVisible();

                fill(0);
                noStroke();
                ellipse(50, 50, 2 * ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY, 2 * ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY);

                if(screenSize > 45) {
                    float energySymbolSize = cellModel.energyLevel * ENERGY_SYMBOL_SIZE_ON_MAX_ENERGY;

                    noStroke();
                    fill(245, 245, 115);
                    beginShape();
                    vertex(50 - 0.00 * energySymbolSize, 50 - 1.00 * energySymbolSize);
                    vertex(50 - 0.48 * energySymbolSize, 50 + 0.12 * energySymbolSize);
                    vertex(50 + 0.15 * energySymbolSize, 50 + 0.15 * energySymbolSize);
                    vertex(50 - 0.00 * energySymbolSize, 50 + 1.00 * energySymbolSize);
                    vertex(50 + 0.48 * energySymbolSize, 50 - 0.12 * energySymbolSize);
                    vertex(50 - 0.15 * energySymbolSize, 50 - 0.15 * energySymbolSize);
                    endShape(CLOSE);

                    if(screenSize > 80) {
                        float progressToNextCodonTick = norm(cellModel.ticksSinceLastCodonTick, 0, cellModel.ticksPerCodonTick);
                        ArrayList<CodonBaseModel> codonModels = (ArrayList<CodonBaseModel>)cellModel.codonModels.clone();

                        // calculating codon hand angle
                        float codonHandAngle = 0;
                        if (cellModel.codonModels.size() != 0) {
                            float currentCodonAngle = codonModels.get(cellModel.currentCodon % codonModels.size()).segmentAngleInCodonCircle;
                            float nextCodonAngle = codonModels.get((cellModel.currentCodon + 1) % codonModels.size()).segmentAngleInCodonCircle;
                            if (cellModel.currentCodon >= codonModels.size()) {
                                currentCodonAngle += TWO_PI;
                            }
                            if (cellModel.currentCodon + 1 >= codonModels.size()) {
                                nextCodonAngle += TWO_PI;
                            }
    
                            codonHandAngle = smoothLerp(currentCodonAngle, nextCodonAngle, 0.1, 0.8, progressToNextCodonTick);
                        }

                        // drawing codon hand
                        float x1 = 50 + sin(codonHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;
                        float y1 = 50 - cos(codonHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;

                        float x2 = 50 + sin(codonHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;
                        float y2 = 50 - cos(codonHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;

                        float x3 = 50 + sin(codonHandAngle) * handPointerRadiusInward;
                        float y3 = 50 - cos(codonHandAngle) * handPointerRadiusInward;

                        noStroke();
                        fill(200, 0, 0);
                        triangle(x1, y1, x2, y2, x3, y3);

                        // calculating execution hand angle
                        float executeHandAngle = 0;
                        if (cellModel.codonModels.size() != 0) {
                            float previousCodonAngle = cellModel.codonModels.get(cellModel.previousExecuteHandPosition).segmentAngleInCodonCircle;
                            float currentCodonAngle = cellModel.codonModels.get(cellModel.executeHandPosition).segmentAngleInCodonCircle;
                            if (currentCodonAngle < previousCodonAngle) {
                                currentCodonAngle += TWO_PI;
                            }
    
                            executeHandAngle = smoothLerp(previousCodonAngle, currentCodonAngle, 0.05, 0.95, progressToNextCodonTick);
                        }

                        // calculating execution hand pointer radius
                        float previousExecuteHandPointerRadius = (cellModel.previousIsExecuteHandPointingOutward) ? handPointerRadiusOutward : handPointerRadiusInward;
                        float currentExecuteHandPointerRadius = (cellModel.isExecuteHandPointingOutward) ? handPointerRadiusOutward : handPointerRadiusInward;
                        float executeHandPointerRadius = smoothLerp(previousExecuteHandPointerRadius, currentExecuteHandPointerRadius, 0.05, 0.95, progressToNextCodonTick);

                        // drawing execution hand
                        x1 = 50 + sin(executeHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;
                        y1 = 50 - cos(executeHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;

                        x2 = 50 + sin(executeHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;
                        y2 = 50 - cos(executeHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;

                        x3 = 50 + sin(executeHandAngle) * executeHandPointerRadius;
                        y3 = 50 - cos(executeHandAngle) * executeHandPointerRadius;

                        noStroke();
                        fill(0, 200, 0);
                        triangle(x1, y1, x2, y2, x3, y3);
                    }

                    strokeWeight(HAND_CIRCLE_WIDTH);
                    stroke(0, 150, 0);
                    noFill();
                    ellipse(50, 50, HAND_CIRCLE_RADIUS * 2, HAND_CIRCLE_RADIUS * 2);
                }
            }
        }
    }


    boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
        if (mousePressed) {
            if (boundsRect.contains(mouseX, mouseY)) {
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
