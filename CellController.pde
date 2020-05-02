class CellController implements CellModelClient, CellViewClient {
    CellModel cellModel;
    CellView cellView;


    CellController(CellModel cellModel) {
        this.cellModel = cellModel;
        this.cellView = viewFactory.createView(cellModel);

        this.cellModel.registerClient(this);
        this.cellView.registerClient(this);
    }


    void draw() {
        cellView.draw();
    }


    void tick() {
    }
}
