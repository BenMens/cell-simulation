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

        this.frameRect = new Rectangle2D.Float(cellModel.position.x * 100, cellModel.position.y * 100, 100, 100);
        this.boundsRect = new Rectangle2D.Float(0, 0, 100, 100);
        
        this.hasClip = true;

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

                    if(screenSize > 75) {
                        float progressToNextActionTick = norm(cellModel.ticksSinceLastActionTick, 0, cellModel.ticksPerActionTick);
                        float actionHandPositionBetweenAction = 1;
                        if (progressToNextActionTick < 0.1) {
                            actionHandPositionBetweenAction = 0;
                        } else if (progressToNextActionTick < 0.8) {
                            actionHandPositionBetweenAction = 1 / (1 + exp(-map(progressToNextActionTick, 0, 1, -6, 6)));
                        }

                        float currentActionAngle = cellModel.actionModels.get(cellModel.currentAction).segmentAngleInActionCircle;
                        float nextActionAngle;
                        if (cellModel.currentAction + 1 == cellModel.actionModels.size()) {
                            nextActionAngle = cellModel.actionModels.get(0).segmentAngleInActionCircle + TWO_PI;
                        } else {
                            nextActionAngle = cellModel.actionModels.get(cellModel.currentAction + 1).segmentAngleInActionCircle;
                        }

                        float actionHandAngle = lerp(currentActionAngle, nextActionAngle, actionHandPositionBetweenAction);

                        float x1 = 50 + sin(actionHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;
                        float y1 = 50 - cos(actionHandAngle - handAnchorAngle) * HAND_CIRCLE_RADIUS;

                        float x2 = 50 + sin(actionHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;
                        float y2 = 50 - cos(actionHandAngle + handAnchorAngle) * HAND_CIRCLE_RADIUS;

                        float x3 = 50 + sin(actionHandAngle) * handPointerRadiusInward;
                        float y3 = 50 - cos(actionHandAngle) * handPointerRadiusInward;

                        noStroke();
                        fill(200, 0, 0);
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


    boolean afterMousePressedChildren(float viewMouseX, float viewMouseY) {
        if (viewMouseX > 0 && viewMouseX < 100 && viewMouseY > 0 && viewMouseY < 100) {
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
}
