class CellView extends ViewBase {
    float HAND_CIRCLE_RADIUS = 25;
    float HAND_CIRCLE_WIDTH = 1.2;
    float HAND_SIZE = 4;

    ArrayList<CellViewClient> clients = new ArrayList<CellViewClient>();
    CellModel cellModel;

    final float wallSizeOnMaxHealth = 10;
    final float energySymbolSizeOnMaxEnergy = 8;


    CellView(CellModel cellModel) {
        this.cellModel = cellModel;

        this.position = cellModel.position.copy().mult(100);

        this.hasClip = true;
        this.size = new PVector(100, 100);
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
        float screenSize = composedScale() * 100;
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
            float wallSize = cellModel.wallHealth * wallSizeOnMaxHealth;
            rect(wallSize, wallSize, 100 - 2 * wallSize, 100 - 2 * wallSize);

            if(screenSize > 15) {
                makeChildsVisible();

                fill(0);
                noStroke();
                ellipse(50, 50, 2 * energySymbolSizeOnMaxEnergy, 2 * energySymbolSizeOnMaxEnergy);

                if(screenSize > 45) {
                    float energySymbolSize = cellModel.energyLevel * energySymbolSizeOnMaxEnergy;

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

                    noStroke();
                    fill(200, 0, 0);
                    ellipse(50 + sin(actionHandAngle) * HAND_CIRCLE_RADIUS, 50 + -cos(actionHandAngle) * HAND_CIRCLE_RADIUS, HAND_SIZE, HAND_SIZE);
                }

                strokeWeight(HAND_CIRCLE_WIDTH);
                stroke(0, 150, 0);
                noFill();
                ellipse(50, 50, HAND_CIRCLE_RADIUS * 2, HAND_CIRCLE_RADIUS * 2);
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
