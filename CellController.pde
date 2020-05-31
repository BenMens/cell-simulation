class CellController extends ControllerBase implements CellModelClient, CellViewClient {
    CellModel cellModel;
    CellView cellView;

    CellController(ControllerBase parentController, ViewBase parentView, CellModel cellModel) {
        super(parentController);
        
        this.cellModel = cellModel;
        this.cellView = new CellView(parentView, cellModel);

        this.cellView.setFrameRect(cellModel.position.x * 100, cellModel.position.y * 100, 100, 100);

        this.cellModel.registerClient(this);
        this.cellView.registerClient(this);
    }


    void onDestroy() {
        cellView.destroy();
        cellView.unregisterClient(this);
        cellModel.unregisterClient(this);
    }


    void onAddCodon(CodonBaseModel codonModel) {
        new CodonController(this, cellView ,codonModel);
    }


    void onDestroy(CellModel cellModel) {
        destroy();
    }

    void onRemoveCodon(CodonBaseModel codonModel) {
    }
}
