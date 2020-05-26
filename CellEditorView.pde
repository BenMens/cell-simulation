class CellEditorView extends ViewBase {
    CellModel cellModel;

    ArrayList<CellEditorViewClient> clients = new ArrayList<CellEditorViewClient>();


    CellEditorView(ViewBase parentView, CellModel cellModel) {
        super(parentView);

        this.cellModel = cellModel;

        this.boundsRect = new Rectangle2D.Float(0, 0, 200, 300);
        this.shouldClip = true;
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

        text("Hello Strings!",10,10);
    }

}
