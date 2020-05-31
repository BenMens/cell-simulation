class CellEditorController extends ControllerBase implements CellModelClient, CellEditorViewClient {
    CellModel cellModel;
    CellEditorView cellEditorView;
    CellController cellController;
    ArrayList<CodonDetailsView> codonDetailsViews = new ArrayList<CodonDetailsView>();


    CellEditorController(ControllerBase parentController, ViewBase parentView, CellModel cellModel) {
        super(parentController);
        
        this.cellModel = cellModel;
        cellEditorView = new CellEditorView(parentView, cellModel);

        cellController = new CellController(this, cellEditorView, cellModel);
            
        cellModel.registerClient(this);
        cellEditorView.registerClient(this);

        rebuildCodonViews();
    }

    void beforeLayoutChildren() {
        Rectangle2D.Float frameRect = cellEditorView.getFrameRect();

        cellEditorView.setBoundsRect(0, 0, frameRect.width, frameRect.height);
        cellController.cellView.setFrameRect(20, 20, 200, 200);

        float codonHeight = cellEditorView.calcCodonsHeight();
        float codonY = cellEditorView.CODONS_Y_POS;
        for (CodonDetailsView codonView: codonDetailsViews) {
            codonView.setFrameRect(40, codonY, frameRect.width - 80, codonHeight);

            codonY += codonHeight + cellEditorView.CODONS_SPACING;
        }
    }

    void onDestroy() {
        cellEditorView.destroy();
        cellEditorView.unregisterClient(this);
        cellModel.unregisterClient(this);

        destroyCodonViews();
    }

    void onDestroy(CellModel cellModel) {
        destroy();
    }


    void destroyCodonViews() {
        for (CodonDetailsView codonView: codonDetailsViews) {
            codonView.destroy();
        }

        codonDetailsViews.clear();
    }

    void rebuildCodonViews() {
        destroyCodonViews();

        for (CodonBaseModel codonModel: cellModel.codonModels) {
            codonDetailsViews.add(new CodonDetailsView(this.cellEditorView, codonModel));
        }

        updateLayout();
    }

    void onAddCodon(CodonBaseModel codonModel) {
        rebuildCodonViews();
    }
    

    void onRemoveCodon(CodonBaseModel codonModel) {
        rebuildCodonViews();
    }
}
