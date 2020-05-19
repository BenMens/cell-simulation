class CellView extends ViewBase {
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
        PVector screenSize = viewSizeToScreenSize(size);
        makeChildsInvisible();
        
        if(screenSize.x < 10 && screenSize.y < 10) {
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

            if(screenSize.x > 15 && screenSize.y > 15) {
                fill(0);
                noStroke();
                ellipse(50, 50, 2 * energySymbolSizeOnMaxEnergy, 2 * energySymbolSizeOnMaxEnergy);

                if(screenSize.x > 45 && screenSize.y > 45) {
                    makeChildsVisible();

                    float energySymbolSize = cellModel.energyLevel * energySymbolSizeOnMaxEnergy;
                    fill(245, 245, 115);
                    beginShape();
                    vertex(50 - 0.00 * energySymbolSize, 50 - 1.00 * energySymbolSize);
                    vertex(50 - 0.48 * energySymbolSize, 50 + 0.12 * energySymbolSize);
                    vertex(50 + 0.15 * energySymbolSize, 50 + 0.15 * energySymbolSize);
                    vertex(50 - 0.00 * energySymbolSize, 50 + 1.00 * energySymbolSize);
                    vertex(50 + 0.48 * energySymbolSize, 50 - 0.12 * energySymbolSize);
                    vertex(50 - 0.15 * energySymbolSize, 50 - 0.15 * energySymbolSize);
                    endShape(CLOSE);
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
