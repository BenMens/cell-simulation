class CellController implements CellModelClient, CellViewClient {
    CellModel cellModel;
    CellView cellView;

    ArrayList<ActionController> actionControllers = new ArrayList<ActionController>();


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


    void onAddAction(ActionBaseModel actionModel) {
        ActionController newActionController = new ActionController(cellView ,actionModel);

        actionControllers.add(newActionController);
    }
}
