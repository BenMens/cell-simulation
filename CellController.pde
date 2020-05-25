class CellController implements CellModelClient, CellViewClient {
    CellModel cellModel;
    CellView cellView;

    ArrayList<CodonController> codonControllers = new ArrayList<CodonController>();


    CellController(ViewBase parentView, CellModel cellModel) {
        this.cellModel = cellModel;
        this.cellView = new CellView(parentView, cellModel);

        this.cellView.frameRect = new Rectangle2D.Float(cellModel.position.x * 100, cellModel.position.y * 100, 100, 100);

        this.cellModel.registerClient(this);
        this.cellView.registerClient(this);
    }


    void destroy() {
        cellView.setParentView(null);
        cellView.unregisterClient(this);
        cellModel.unregisterClient(this);
    }


    void onAddCodon(CodonBaseModel codonModel) {
        CodonController newCodonController = new CodonController(cellView ,codonModel);

        codonControllers.add(newCodonController);
    }


    void onDestroy(CellModel cellModel) {
        destroy();
    }
}
