class CellView extends ViewBase {
    ArrayList<CellViewClient> clients = new ArrayList<CellViewClient>();
    CellModel cellModel;


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
        pushMatrix();

        noStroke();
        fill(255, 165, 135);
        rect(0, 0, 100, 100);

        fill(0, 0, 0);
        text(String.valueOf(cellModel.wallHealth) , 10, 50);

        popMatrix();
    }
}
