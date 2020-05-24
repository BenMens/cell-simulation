class CellController implements CellModelClient, CellViewClient {
    CellModel cellModel;
    CellView cellView;

    ArrayList<CodonController> codonControllers = new ArrayList<CodonController>();


    CellController(ViewBase parentView, CellModel cellModel) {
        this.cellModel = cellModel;
        this.cellView = new CellView(parentView, cellModel);

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
}
