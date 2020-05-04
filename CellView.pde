class CellView extends ViewBase {
    ArrayList<CellViewClient> clients = new ArrayList<CellViewClient>();
    CellModel cellModel;

    boolean selected = false;


    CellView(CellModel cellModel) {
        this.cellModel = cellModel;
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
        rect(cellModel.position.x * 100, cellModel.position.y * 100, 100, 100);

        fill((selected) ? color(0, 0, 200) : color(255, 165, 135));
        rect(cellModel.position.x * 100 + 10, cellModel.position.y * 100 + 10, 80, 80);

        strokeWeight(10);
        stroke(0);
        fill(100);
        //rect()
    }


    boolean afterMousePressedChildren() {
        if(relativeMousePositionX > cellModel.position.x && relativeMousePositionX < cellModel.position.x + 1 && relativeMousePositionY > cellModel.position.y && relativeMousePositionY < cellModel.position.y + 1) {
            selected = !selected;
            return true;
        } else if(mouseX < 2000) {
            selected = false;
        }

        return false;
    }
}
