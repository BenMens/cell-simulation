class CellEditorController extends ControllerBase implements CellModelClient, CellEditorViewClient {
    CellModel cellModel;
    CellEditorView cellEditorView;
    CellController cellController;
    CodonDetailsView codonDetailsView;

    CellEditorController(ControllerBase parentController, ViewBase parentView, CellModel cellModel) {
        super(parentController);
        
        this.cellModel = cellModel;
        cellEditorView = new CellEditorView(parentView, cellModel);

        cellController = new CellController(this, cellEditorView, cellModel);
            
        codonDetailsView = new CodonDetailsView(this.cellEditorView);

        cellModel.registerClient(this);
        cellEditorView.registerClient(this);
    }

    void beforeLayoutChildren() {
        cellEditorView.setBoundsRect(0, 0, cellEditorView.getFrameRect().width, cellEditorView.getFrameRect().height);
        cellController.cellView.setFrameRect(20, 20, 200, 200);

        codonDetailsView.setFrameRect(20, 290, 100, 80);
        codonDetailsView.setBoundsRect(0, 0, 100, 80);
    }


    void onDestroy() {
        cellEditorView.destroy();
        cellEditorView.unregisterClient(this);
        cellModel.unregisterClient(this);

        codonDetailsView.destroy();
    }

    void onDestroy(CellModel cellModel) {
        destroy();
    }


    void onAddCodon(CodonBaseModel codonModel) {
    }
    

    void onRemoveCodon(CodonBaseModel codonModel) {
    }
}
