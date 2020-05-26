class CellEditorController implements CellModelClient, CellEditorViewClient {
    CellModel cellModel;
    CellEditorView cellEditorView;

    CellEditorController(ViewBase parentView, CellModel cellModel, Rectangle2D.Float frameRect) {
        this.cellModel = cellModel;
        this.cellEditorView = new CellEditorView(parentView, cellModel);

        this.cellEditorView.frameRect = frameRect;

        this.cellModel.registerClient(this);
        this.cellEditorView.registerClient(this);
    }


    void destroy() {
        cellEditorView.setParentView(null);
        cellEditorView.unregisterClient(this);
        cellModel.unregisterClient(this);
    }


    void onDestroy(CellModel cellModel) {
        destroy();
    }


    void onAddCodon(CodonBaseModel codonModel) {
    }
    

    void onRemoveCodon(CodonBaseModel codonModel) {
    }
}
