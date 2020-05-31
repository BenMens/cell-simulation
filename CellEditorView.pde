class CellEditorView extends ViewBase {
    CellModel cellModel;

    ArrayList<CellEditorViewClient> clients = new ArrayList<CellEditorViewClient>();

    PFont font;


    CellEditorView(ViewBase parentView, CellModel cellModel) {
        super(parentView);

        this.cellModel = cellModel;

        this.shouldClip = true;

        font = createFont("courrier.dfont", 24);
    }

    void beforeLayoutChildren() {
        setBoundsRect(0, 0, getFrameRect().width, getFrameRect().height);
    }


    void registerClient(CellEditorViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }  
    }


    void unregisterClient(CellEditorViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        background(10, 10, 10);

        fill(255);
        textFont(font);
        text(String.format("Energy: %.1f",this.cellModel.energyLevel * 100), 10, 252);
        text(String.format("WallHealth: %.1f",this.cellModel.wallHealth * 100), 10, 284);
    }

}
