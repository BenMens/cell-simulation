class CellView extends ViewBase {
    ArrayList<CellViewClient> clients = new ArrayList<CellViewClient>();
    CellModel cellModel;


    CellView(CellModel cellModel) {
        this.cellModel = cellModel;

        this.position = cellModel.position.copy().mult(100);
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
        noStroke();

        fill(250, 90, 70);
        rect(0, 0, 100, 100);

        fill((cellModel.isSelected()) ? color(0, 0, 200) : color(255, 165, 135));
        rect(10, 10, 80, 80);
        
        fill(0, 0, 0);
        text(String.valueOf(cellModel.wallHealth) , 10, 50);
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
